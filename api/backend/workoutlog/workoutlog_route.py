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

#------------------------------------------------------------
# gets the PR or max weight for each exercise
@workoutlog_route.route('/pr', methods=['GET'])
def get_pr():
    current_app.logger.info('GET /workoutlog/pr route')

    cursor = db.get_db().cursor()
    query = '''
        SELECT ExerciseType, MAX(WeightUsed) AS PR
        FROM WorkoutLog
        GROUP BY ExerciseType
    '''
    cursor.execute(query)
    data = cursor.fetchall()

    response = make_response(jsonify(data))
    response.status_code = 200
    return response

#------------------------------------------------------------
# add a new workout log
@workoutlog_route.route('/', methods=['POST'])
def add_workout():
    current_app.logger.info('POST /workoutlog route')

    data = request.get_json()
    cursor = db.get_db().cursor()

    query = '''
        INSERT INTO WorkoutLog (UserID, Date, ExerciseType, Duration, 
                                CaloriesBurned, TrainerNotes, setCount, repsInSet, WeightUsed)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
    '''
    cursor.execute(query, (
        data["user_id"],
        data["date"],
        data["exercise"],
        data["duration"],
        data["calories_burned"],
        data["trainer_notes"],
        data["sets"],
        data["reps"],
        data["weight"]
    ))
    db.get_db().commit()

    response = make_response(jsonify({"message": "Workout added"}))
    response.status_code = 201
    return response
#------------------------------------------------------------
# updates a existing log
@workoutlog_route.route('/<logID>', methods=['PUT'])
def update_workout_log(logID):
    current_app.logger.info(f'PUT /workoutlog/{logID} route')

    data = request.get_json()
    cursor = db.get_db().cursor()

    query = '''
        UPDATE WorkoutLog
        SET ExerciseType = %s, Duration = %s, CaloriesBurned = %s,
            TrainerNotes = %s, setCount = %s, repsInSet = %s, WeightUsed = %s
        WHERE LogID = %s
    '''
    values = (
        data['exercise'],
        data['duration'],
        data['calories_burned'],
        data['trainer_notes'],
        data['sets'],
        data['reps'],
        data['weight'],
        logID
    )

    cursor.execute(query, values)
    db.get_db().commit()

    the_response = make_response(jsonify({'message': 'Workout log updated'}))
    the_response.status_code = 200
    return the_response

#------------------------------------------------------------
# delete a log
@workoutlog_route.route('/<logID>', methods=['DELETE'])
def delete_workout_log(logID):
    current_app.logger.info(f'DELETE /workoutlog/{logID} route')

    cursor = db.get_db().cursor()
    query = 'DELETE FROM WorkoutLog WHERE LogID = %s'
    cursor.execute(query, (logID,))
    db.get_db().commit()

    the_response = make_response(jsonify({'message': 'Workout log deleted'}))
    the_response.status_code = 200
    return the_response