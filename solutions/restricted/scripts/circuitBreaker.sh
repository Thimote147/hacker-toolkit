from pybreaker import CircuitBreaker
    
    breaker = CircuitBreaker(fail_max=5, timeout_duration=60)
    
    @breaker
    def perform_calculation(x, y, z):
        # Si trop d'erreurs, le circuit s'ouvre et refuse les requêtes
        return x + y + z