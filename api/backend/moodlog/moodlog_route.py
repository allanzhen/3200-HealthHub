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

moodlog_route = Blueprint('moodlog_route', __name__)

#------------------------------------------------------------
# Get all mood logs (optionally filtered by user_id)
@moodlog_route.route('/', methods=['GET'])
def get_moods():
    current_app.logger.info('GET /moodlog route')
    user_id = request.args.get('user_id')

    cursor = db.get_db().cursor()

    if user_id:
        query = '''
            SELECT LogID, UserID, Date, Mood
            FROM MoodLog
            WHERE UserID = %s
            ORDER BY Date DESC
        '''
        cursor.execute(query, (user_id,))
    else:
        query = '''
            SELECT LogID, UserID, Date, Mood
            FROM MoodLog
            ORDER BY Date DESC
        '''
        cursor.execute(query)

    theData = cursor.fetchall()

    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

#------------------------------------------------------------
# Get details for a single mood log by MoodID
@moodlog_route.route('/<moodID>', methods=['GET'])
def get_mood(moodID):
    current_app.logger.info(f'GET /moodlog/{moodID} route')

    cursor = db.get_db().cursor()
    query = '''
        SELECT LogID, UserID, Date, Mood
        FROM MoodLog
        WHERE LogID = %s
    '''
    cursor.execute(query, (moodID,))
    
    theData = cursor.fetchall()

    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response