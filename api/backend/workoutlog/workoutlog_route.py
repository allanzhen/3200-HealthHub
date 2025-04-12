# Filename: workoutlog_route.py
from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db


workoutlog_route = Blueprint('workoutlog_route', __name__)

#------------------------------------------------------------
# Get all workouts (optionally filter by user_id)
@workoutlog_route.route('/', methods=['GET'])
def get_workouts():
    current_app.logger.info('GET /workoutlog route')
    user_id = request.args.get('user_id')

    cursor = db.get_db().cursor()

    if user_id:
        query = '''
            SELECT LogID, UserID, Date, ExerciseType, Duration, 
                   CaloriesBurned, TrainerNotes, setCount, repsInSet, WeightUsed
            FROM WorkoutLog
            WHERE UserID = %s
            ORDER BY Date DESC
        '''
        cursor.execute(query, (user_id,))
    else:
        query = '''
            SELECT LogID, UserID, Date, ExerciseType, Duration, 
                   CaloriesBurned, TrainerNotes, setCount, repsInSet, WeightUsed
            FROM WorkoutLog
            ORDER BY Date DESC
        '''
        cursor.execute(query)

    theData = cursor.fetchall()

    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

#------------------------------------------------------------
# Get details for a single workout by log ID
@workoutlog_route.route('/<logID>', methods=['GET'])
def get_workout(logID):
    current_app.logger.info(f'GET /workoutlog/{logID} route')

    cursor = db.get_db().cursor()
    query = '''
        SELECT LogID, UserID, Date, ExerciseType, Duration, 
               CaloriesBurned, TrainerNotes, setCount, repsInSet, WeightUsed
        FROM WorkoutLog
        WHERE LogID = %s
    '''
    cursor.execute(query, (logID,))
    
    theData = cursor.fetchall()

    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response