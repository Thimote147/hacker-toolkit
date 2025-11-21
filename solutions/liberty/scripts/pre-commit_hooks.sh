# Installer git-secrets
   $ brew install git-secrets  # macOS
   $ sudo apt install git-secrets  # Linux
   
   # Configurer pour le repository
   $ cd /path/to/repo
   $ git secrets --install
   $ git secrets --register-aws
   
   # Ajouter des patterns personnalisés
   $ git secrets --add 'BEGIN.*PRIVATE KEY'
   $ git secrets --add 'password\s*=\s*.+'
   $ git secrets --add '[a-zA-Z0-9]{32,}'  # Tokens/API keys
