# Delete the isolation rules to allow all incoming traffic to port 8080
sudo iptables -D INPUT -p tcp --dport 8080 -j DROP
sudo iptables -D INPUT -s [IP_ADMIN_AUTHORIZED] -p tcp --dport 8080 -j ACCEPT