   # Vérifier les logs d'accès
   sudo cat /opt/geoserver/logs/access.log | grep -i "wfs\|POST"
   
   # Rechercher les connexions suspectes
   sudo netstat -tulpn | grep -E "4444|4445|ESTABLISHED"
   
   # Vérifier les processus suspects
   ps aux | grep -E "nc|bash|sh" | grep -v grep
