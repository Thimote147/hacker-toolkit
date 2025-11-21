# ✅ CODE CORRIGÉ
   @app.route('/calculate', methods=['POST'])
   def calculate():
       try:
           x = int(request.form.get('x', 0))
           y = int(request.form.get('y', 0))
           z = int(request.form.get('z', 0))
           
           # Validation des plages
           if not all(0 <= val <= 999999 for val in [x, y, z]):
               return jsonify({"error": "Values out of range"}), 400
           
           result = x + y + z
           
           # Supprimer l'easter egg ou le gérer correctement
           # if result == 42069:
           #     # Ne PAS crasher, retourner une réponse normale
           
           return jsonify({"result": result}), 200
           
       except ValueError:
           return jsonify({"error": "Invalid input"}), 400
       except Exception as e:
           # Logger l'erreur sans exposer les détails
           logger.error(f"Calculation error: {str(e)}")
           return jsonify({"error": "Internal server error"}), 500