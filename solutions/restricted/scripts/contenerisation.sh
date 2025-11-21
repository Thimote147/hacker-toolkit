# Kubernetes deployment avec auto-restart
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: calculator-service
    spec:
      replicas: 3  # Haute disponibilité
      template:
        spec:
          containers:
          - name: calculator
            livenessProbe:
              httpGet:
                path: /health
                port: 8080
              initialDelaySeconds: 30
              periodSeconds: 10
            readinessProbe:
              httpGet:
                path: /health
                port: 8080
