# Vérify shell access in Apache logs
grep "shell.jpg.php" /var/log/apache2/access.log

# Identify suspicious IP addresses
awk '{print $1}' /var/log/apache2/access.log | sort | uniq -c | sort -nr
