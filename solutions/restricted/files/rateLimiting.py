   from flask_limiter import Limiter
   from flask_limiter.util import get_remote_address
   
   limiter = Limiter(
       app,
       key_func=get_remote_address,
       default_limits=["100 per hour", "10 per minute"]
   )
   
   @app.route('/calculate', methods=['POST'])
   @limiter.limit("5 per minute")  # Maximum 5 calculs par minute
   def calculate():
       