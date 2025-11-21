# .github/workflows/security-scan.yml
    name: Security Scan
    
    on: [push, pull_request]
    
    jobs:
      secret-scan:
        runs-on: ubuntu-latest
        steps:
          - uses: actions/checkout@v3
            with:
              fetch-depth: 0  # Scan tout l'historique
          
          - name: GitGuardian scan
            uses: GitGuardian/ggshield-action@v1
            env:
              GITGUARDIAN_API_KEY: ${{ secrets.GITGUARDIAN_API_KEY }}
          
          - name: TruffleHog scan
            uses: trufflesecurity/trufflehog@main
            with:
              path: ./
              base: ${{ github.event.repository.default_branch }}
              head: HEAD