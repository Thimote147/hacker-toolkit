# Créer un fichier avec le hash
echo "00b39b8be62c67284bbb157e7143e4ef796f061ca75f6e1d06a5123ab1e5144c" > hash.txt

# Cracking avec John
john --format=raw-sha256 --wordlist=leaked_passwords.txt hash.txt