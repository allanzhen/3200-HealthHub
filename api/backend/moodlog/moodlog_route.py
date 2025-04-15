########################################################
# MoodLog blueprint of endpoints
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

#------------------------------------------------------------
# Inserts mood and its data to the mood log
@moodlog_route.route('/', methods=['POST'])
def add_mood_log():
    current_app.logger.info('POST /moodlog route')

    data = request.get_json()
    cursor = db.get_db().cursor()

    query = '''
        INSERT INTO MoodLog (UserID, Date, Mood)
        VALUES (%s, %s, %s)
    '''

    cursor.execute(query, (
        data["user_id"], 
        data["date"], 
        data["mood"]
    ))
    db.get_db().commit()

    the_response = make_response(jsonify({"message": "Mood log added"}))
    the_response.status_code = 201
    return the_response

#------------------------------------------------------------
# Update mood log info for customer with particular LogID
@moodlog_route.route('/', methods=['PUT'])
def update_moodlog():
    current_app.logger.info('PUT /moodlog route')
    data = request.json

    query = '''
        UPDATE MoodLog
        SET UserID = %s, Date = %s, Mood = %s
        WHERE LogID = %s
    '''
    values = (
        data['UserID'], data['Date'], data['Mood'], data['LogID']
    )

    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return jsonify({'message': 'Mood log updated!'}), 200
