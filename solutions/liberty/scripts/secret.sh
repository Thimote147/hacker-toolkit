# ✅ Utiliser HashiCorp Vault
    import hvac
    
    client = hvac.Client(url='https://vault.company.com')
    client.token = os.environ['VAULT_TOKEN']
    
    # Récupérer les secrets de manière sécurisée
    secret = client.secrets.kv.v2.read_secret_version(path='staging/ssh-keys')
    ssh_key = secret['data']['data']['private_key']