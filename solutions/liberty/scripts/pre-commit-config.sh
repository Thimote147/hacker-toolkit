    # .pre-commit-config.yaml
    repos:
      - repo: https://github.com/Yelp/detect-secrets
        rev: v1.4.0
        hooks:
          - id: detect-secrets
            args: ['--baseline', '.secrets.baseline']
            exclude: package-lock.json
      
      - repo: https://github.com/awslabs/git-secrets
        rev: master
        hooks:
          - id: git-secrets
            entry: 'git-secrets --scan'
            language: system
