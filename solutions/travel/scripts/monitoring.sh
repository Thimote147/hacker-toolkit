# Keep track the new PHP files in salmon-uploads/
find /var/www/html/salmon-uploads/ -name "*.php" -type f -mtime -1

# Crate a cron task to alert
*/5 * * * * /usr/local/bin/check_malicious_uploads.sh
