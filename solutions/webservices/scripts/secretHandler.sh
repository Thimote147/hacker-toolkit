   # Utiliser HashiCorp Vault
   vault kv put secret/geoserver \
       admin_username="geoserver_admin" \
       admin_password="$(openssl rand -base64 32)"
   
   # Récupérer les credentials dans l'application
   vault kv get -field=admin_password secret/geoserver
