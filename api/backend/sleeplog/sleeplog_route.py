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