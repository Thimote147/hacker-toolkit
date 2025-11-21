# .gitignore pour secrets
   # SSH Keys
   *.pem
   *.key
   *.crt
   *.p12
   *.pfx
   id_rsa*
   id_ed25519*
   
   # Environment variables
   .env
   .env.*
   !.env.example
   
   # Configuration files
   *config.local.*
   secrets.yml
   credentials.yml
   
   # Database
   *.sql
   *.sqlite
   *.db
   
   # Logs
   *.log
   npm-debug.log*
   
   # OS files
   .DS_Store
   Thumbs.db
