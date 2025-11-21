# Supprimer le fichier compromis
   sudo rm /opt/geoserver/ADMIN_CREDENTIALS.txt
   
   # Vérifier qu'il n'y a pas d'autres fichiers sensibles
   sudo find /opt/geoserver -name "*.txt" -exec grep -l -i "password\|credential\|secret" {} \;
