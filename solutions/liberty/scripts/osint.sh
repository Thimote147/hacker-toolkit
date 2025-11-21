# Scanner régulièrement l'exposition publique
    $ amass enum -d rogue-sentinels.io
    $ theHarvester -d rogue-sentinels.io -b all
    
    # Rechercher les secrets exposés
    $ trufflehog github --org your-org