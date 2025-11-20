# Prometheus alert rules
    - alert: HighErrorRate
      expr: rate(http_requests_total{status="500"}[5m]) > 0.05
      for: 5m
      annotations:
        summary: "High error rate detected"
    
    - alert: ServiceDown
      expr: up{job="calculator-service"} == 0
      for: 1m
      annotations:
        summary: "Calculator service is down"