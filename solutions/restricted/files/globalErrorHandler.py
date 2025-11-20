@app.errorhandler(Exception)
   def handle_exception(e):
       # Logger l'erreur complète en interne
       logger.exception("Unhandled exception")
       
       # Retourner un message générique
       return jsonify({
           "error": "An unexpected error occurred",
           "request_id": generate_request_id()  # Pour traçabilité
       }), 500
