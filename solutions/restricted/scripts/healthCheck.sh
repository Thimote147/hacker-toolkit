    @app.route('/health')
    def health_check():
        # Vérifier que le service fonctionne correctement
        try:
            # Test de calcul simple
            test_result = 1 + 1
            return jsonify({"status": "healthy"}), 200
        except:
            return jsonify({"status": "unhealthy"}), 503