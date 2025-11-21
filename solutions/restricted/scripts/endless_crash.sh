while true
do
    curl -X POST http://restricted.rogue-sentinels.io:64375/calculate -d "x=42069&y=0&z=0"
    sleep 1
done