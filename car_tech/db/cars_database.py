from flask import Flask, request, jsonify
from flask_restful import Api, Resource
from flask_cors import CORS
import firebase_admin
from firebase_admin import credentials, firestore

# Inizializza l'app Flask
app = Flask(__name__)
CORS(app)
api = Api(app)

# Configura Firebase
cred = credentials.Certificate("serviceAccountKey.json")  # Sostituisci con il tuo file JSON
firebase_admin.initialize_app(cred)
db = firestore.client()

# Collezione Firestore
CARS_COLLECTION = "auto"

class CarResource(Resource):
    def get(self, car_id=None):
        """Recupera i dati di una singola auto o di tutte le auto."""
        if car_id:
            doc = db.collection(CARS_COLLECTION).document(car_id).get()
            if doc.exists:
                return jsonify(doc.to_dict())
            return {"message": "Car not found"}, 404
        
        cars = [doc.to_dict() for doc in db.collection(CARS_COLLECTION).stream()]
        return jsonify(cars)

    def post(self):
        """Aggiunge una nuova auto al database."""
        data = request.json
        if not data.get("id"):
            return {"error": "ID is required"}, 400
        db.collection(CARS_COLLECTION).document(data["id"]).set(data)
        return {"message": "Car added successfully"}, 201

    def delete(self, car_id):
        """Elimina un'auto dal database."""
        db.collection(CARS_COLLECTION).document(car_id).delete()
        return {"message": "Car deleted successfully"}, 200

api.add_resource(CarResource, "/auto", "/auto/<string:car_id>")

if __name__ == "__main__":
    app.run(debug=True)
