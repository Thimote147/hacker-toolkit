# Encrypt the backup file using GPG with AES-256
gpg --symmetric --cipher-algo AES256 --output backup.sql.gpg backup.sql

# Or with OpenSSL
openssl enc -aes-256-cbc -salt -in backup.sql -out backup.sql.enc -k "STRONG_PASSPHRASE_32_CHARS_MIN"
