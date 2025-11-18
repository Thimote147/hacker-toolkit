while read folder; do 
  response=$(curl -s -b "token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJzZWN1cml0eS1hZG1pbkB3ZWIyMDAwLWNvcnAuY29tIiwiaWF0IjoxNzYyNDUwNzIwLCJleHAiOjE3NjI0NTQzMjB9.zDz1IgMSmwmygOa4vRjZxLAlN2ghBUXI4oZayIXXbME" "http://fileserver.rogue-sentinels.io:8080/api/v1/folder?folder=$folder")
  if [ "$response" != '{"files":[]}' ]; then
    echo "[+] Found: $folder"
    echo "$response"
    echo "---"
  fi
done < wordlists/common_urls.txt