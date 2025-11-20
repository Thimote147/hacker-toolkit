<?php
    // Use secrets managers 
    // AWS Secrets Manager, HashiCorp Vault, etc.
    $client = new SecretsManagerClient(['region' => 'us-east-1']);
    $result = $client->getSecretValue(['SecretId' => 'prod/db/credentials']);
    $secret = json_decode($result['SecretString'], true);
?>
