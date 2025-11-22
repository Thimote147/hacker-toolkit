# Block all incoming traffic to port 8080 except from the authorized admin IP
sudo iptables -I INPUT -p tcp --dport 8080 -j DROP
sudo iptables -I INPUT -s [IP_ADMIN_AUTORISEE] -p tcp --dport 8080 -j ACCEPT