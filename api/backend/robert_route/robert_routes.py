from flask import (Blueprint, 
                   request, 
                   jsonify, 
                   make_response, 
                   current_app)
from backend.db_connection import db

robert_routes = Blueprint('robert_routes', __name__)

# Route 1: GET /workoutlog - Get all workout logs for Robert
@robert_routes.route('/workoutlog', methods=['GET'])
def get_workout_logs():
    current_app.logger.info("GET /workoutlog handler")
    cursor = db.get_db().cursor(dictionary=True)
    cursor.execute("SELECT * FROM WorkoutLog WHERE UserID = 100")
    result = cursor.fetchall()
    response = make_response(jsonify(result))
    response.status_code = 200
    return response

# Route 2: POST /workoutlog - Add a new workout entry
@robert_routes.route('/workoutlog', methods=['POST'])
def add_workout_log():
    current_app.logger.info("POST /workoutlog handler")
    data = request.get_json()
    cursor = db.get_db().cursor()
    query = """
        INSERT INTO WorkoutLog (UserID, Date, ExerciseType, WeightUsed, setCount, repsInSet)
        VALUES (%s, %s, %s, %s, %s, %s)
    """
    cursor.execute(query, (
        100,  # fixed UserID for Robert
        data.get("date"),
        data.get("exercise"),
        data.get("weight"),
        data.get("sets"),
        data.get("reps")
    ))
    db.get_db().commit()
    response = make_response(jsonify({"message": "Workout log added"}))
    response.status_code = 201
