import logging
   from logging.handlers import RotatingFileHandler
   
   # Logger structuré
   handler = RotatingFileHandler('app.log', maxBytes=10000000, backupCount=5)
   handler.setLevel(logging.INFO)
   
   formatter = logging.Formatter(
       '[%(asctime)s] %(levelname)s in %(module)s: %(message)s'
   )
   handler.setFormatter(formatter)
   app.logger.addHandler(handler)
   
   # Log de toutes les requêtes
   @app.before_request
   def log_request():
       app.logger.info(f"Request: {request.method} {request.path} from {request.remote_addr}")
