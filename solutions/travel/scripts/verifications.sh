# Identify and delete malicious files in the salmon-uploads directory
find /var/www/html/salmon-uploads/ -name "*.php" -delete
find /var/www/html/salmon-uploads/ -name "*.jpg.php" -delete

# Verify remaining files
find /var/www/html/salmon-uploads/ -type f -exec file {} \;
