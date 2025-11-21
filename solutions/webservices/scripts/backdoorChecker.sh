# Rechercher les clés SSH ajoutées
   sudo find /home -name "authorized_keys" -exec cat {} \;
   
   # Vérifier les crontabs
   sudo crontab -l
   for user in $(cut -d: -f1 /etc/passwd); do
       sudo crontab -u $user -l 2>/dev/null
   done
   
   # Vérifier les services systemd suspects
   sudo systemctl list-units --type=service --state=running
