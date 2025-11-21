# Installer TruffleHog
    $ pip install trufflehog
    
    # Scanner tout l'historique Git
    $ trufflehog git file:///path/to/repo --only-verified
    
    # Scanner depuis GitHub
    $ trufflehog github --org=organization-name --repo=repo-name
