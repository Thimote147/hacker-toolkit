   # Télécharger la dernière version corrigée
   wget https://sourceforge.net/projects/geoserver/files/GeoServer/2.24.4/geoserver-2.24.4-bin.zip
   
   # Arrêter le service actuel
   sudo systemctl stop tomcat
   
   # Sauvegarder l'ancienne installation
   sudo mv /opt/geoserver /opt/geoserver.old.vulnerable
   
   # Installer la nouvelle version
   sudo unzip geoserver-2.24.4-bin.zip -d /opt/
   sudo mv /opt/geoserver-2.24.4 /opt/geoserver
   
   # Restaurer les configurations
   sudo cp -r /opt/geoserver.old.vulnerable/data_dir /opt/geoserver/
   
   # Redémarrer le service
   sudo systemctl start tomcat
   
   # Vérifier la version
   curl http://localhost:8080/geoserver/web/wicket/bookmarkable/org.geoserver.web.AboutGeoServerPage
