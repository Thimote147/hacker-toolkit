    # Intégration Trivy dans la CI/CD
    trivy image geoserver:2.24.4
    
    # Scan hebdomadaire avec OpenVAS
    0 2 * * 0 /usr/bin/openvas-scan.sh webservices.rogue-sentinels.io
