# Utiliser un CA interne avec rotation automatique
# Exemple avec Vault PKI
$ vault write -format=json pki/issue/staging-role \
    common_name="staging.rogue-sentinels.io" \
    ttl="720h"
