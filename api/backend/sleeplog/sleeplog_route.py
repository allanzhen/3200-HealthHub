########################################################
# Sample customers blueprint of endpoints
# Remove this file if you are not using it in your project
########################################################
from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db


sleeplog_route = Blueprint('sleeplog_route', __name__)

#------------------------------------------------------------
# Get all sleep logs (optionally filtered by user_id)
@sleeplog_route.route('/', methods=['GET'])
def get_sleep_logs():
    current_app.logger.info('GET /sleeplog route')
    user_id = request.args.get('user_id')

    cursor = db.get_db().cursor()

    if user_id:
        query = '''
            SELECT LogID, UserID, Date, SleepDuration, SleepQuality
            FROM SleepLog
            WHERE UserID = %s
            ORDER BY Date DESC
        '''
        cursor.execute(query, (user_id,))
    else:
        query = '''
            SELECT LogID, UserID, Date, SleepDuration, SleepQuality
            FROM SleepLog
            ORDER BY Date DESC
        '''
        cursor.execute(query)

    theData = cursor.fetchall()

    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

#------------------------------------------------------------
# Get details for a single sleep log by SleepID
@sleeplog_route.route('/<sleepID>', methods=['GET'])
def get_sleep_log(sleepID):
    current_app.logger.info(f'GET /sleeplog/{sleepID} route')

    cursor = db.get_db().cursor()
    query = '''
        SELECT LogID, UserID, Date, SleepDuration, SleepQuality
        FROM SleepLog
        WHERE LogID = %s
    '''
    cursor.execute(query, (sleepID,))
    
    theData = cursor.fetchall()

    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

#------------------------------------------------------------
# Inserts food and its data to the food log
@sleeplog_route.route('/', methods=['POST'])
def add_sleep_log():
    current_app.logger.info('POST /sleeplog route')

    data = request.get_json()
    cursor = db.get_db().cursor()

    query = '''
        INSERT INTO SleepLog (UserID, Date, SleepDuration, SleepQuality)
        VALUES (%s, %s, %s, %s, %s)
    '''

    cursor.execute(query, (
        data["user_id"], 
        data["date"], 
        data["food_id"], 
        data["calories"], 
        data["meal_type"]
    ))
    db.get_db().commit()

    the_response = make_response(jsonify({"message": "Sleep log added!"}))
    the_response.status_code = 201
    return the_response

#------------------------------------------------------------
# Update food log info for customer with particular userID
@sleeplog_route.route('/', methods=['PUT'])
def update_sleeplog():
    current_app.logger.info('PUT /sleeplog route')
    data = request.json

    query = '''
        UPDATE SleepLog
        SET UserID = %s, Date = %s, SleepDuration = %s, SleepQuality = %s
        WHERE LogID = %s
    '''
    values = (
        data['UserID'], data['Date'], data['SleepDuration'], data['SleepQuality'],
        data['LogID']
    )

    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return jsonify({'message': 'Sleep log updated!'}), 200