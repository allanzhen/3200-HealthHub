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

heartratelog_route = Blueprint('heartratelog_route', __name__)

#------------------------------------------------------------
# Get all heart rate logs (optionally filtered by user_id)
@heartratelog_route.route('/', methods=['GET'])
def get_heartrate_logs():
    current_app.logger.info('GET /heartratelog route')
    user_id = request.args.get('user_id')

    cursor = db.get_db().cursor()

    if user_id:
        query = '''
            SELECT LogID, UserID, Date, AvgHeartRate
            FROM HeartRateLog
            WHERE UserID = %s
            ORDER BY Date DESC
        '''
        cursor.execute(query, (user_id,))
    else:
        query = '''
            SELECT LogID, UserID, Date, AvgHeartRate
            FROM HeartRateLog
            ORDER BY Date DESC
        '''
        cursor.execute(query)

    theData = cursor.fetchall()

    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

#------------------------------------------------------------
# Get details for a single heart rate log by HeartRateLogID
@heartratelog_route.route('/<heartRateLogID>', methods=['GET'])
def get_heartrate_log(heartRateLogID):
    current_app.logger.info(f'GET /heartratelog/{heartRateLogID} route')

    cursor = db.get_db().cursor()
    query = '''
        SELECT LogID, UserID, Date, AvgHeartRate
        FROM HeartRateLog
        WHERE LogID = %s
    '''
    cursor.execute(query, (heartRateLogID,))
    
    theData = cursor.fetchall()

    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response