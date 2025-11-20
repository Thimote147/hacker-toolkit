-- Login to MySQL
mysql -u root -p

-- Change the password
ALTER USER 'salmon_admin'@'localhost' IDENTIFIED BY 'NEW_STRONG_PASSWORD_128_CHARS';
FLUSH PRIVILEGES;
