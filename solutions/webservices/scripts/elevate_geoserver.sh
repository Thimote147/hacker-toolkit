#!/bin/bash
# Backup the default GeoServer users.xml file
cd /opt/geoserver/data_dir/security/usergroup/default
cp users.xml users.xml.bak

# Create a new users.xml file with specified users and passwords
cat > users.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<userRegistry xmlns="http://www.geoserver.org/security/users" version="1.0">
<users>
<user enabled="true" name="admin" password="digest1:UKQP3k6951wRMuvJ9FP4UK1BckiqL9pR3wknxlc8cyL1h1mb2YbREcgdBw0LrrzZ"/>
<user enabled="true" name="recovery" password="plain:Recovery2024!"/>
</users>
<groups/>
</userRegistry>
EOF


# Backup the default GeoServer roles.xml file
cd /opt/geoserver/data_dir/security/roles/default
cp roles.xml roles.xml.bak

# Create a new roles.xml file with specified roles and user assignments
cat > /opt/geoserver/data_dir/security/role/default/roles.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<roleRegistry version="1.0" xmlns="http://www.geoserver.org/security/roles">
    <roleList>
        <role id="ADMIN"/>
        <role id="GROUP_ADMIN"/>
    </roleList>
    <userList>
        <userRoles username="admin">
            <roleRef roleID="ADMIN"/>
        </userRoles>
        <userRoles username="recovery">
            <roleRef roleID="ADMIN"/>
        </userRoles>
    </userList>
    <groupList/>
</roleRegistry>
EOF

# Now when you connect to GeoServer, you can use the following credentials:
# Username: recovery
# Password: Recovery2024!