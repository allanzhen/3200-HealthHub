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

foodlog_route = Blueprint('foodlog_route', __name__)

#------------------------------------------------------------
# Get all food logs (optionally filtered by user_id)
@foodlog_route.route('/', methods=['GET'])
def get_food_logs():
    current_app.logger.info('GET /foodlog route')
    user_id = request.args.get('user_id')

    cursor = db.get_db().cursor()

    if user_id:
        query = '''
            SELECT LogID, UserID, Date, FoodID, Calories, MealType
            FROM FoodLog
            WHERE UserID = %s
            ORDER BY Date DESC
        '''
        cursor.execute(query, (user_id,))
    else:
        query = '''
            SELECT LogID, UserID, Date, FoodID, Calories, MealType
            FROM FoodLog
            ORDER BY Date DESC
        '''
        cursor.execute(query)

    theData = cursor.fetchall()

    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

#------------------------------------------------------------
# Get details for a single food log by FoodLogID
@foodlog_route.route('/<foodLogID>', methods=['GET'])
def get_food_log(foodLogID):
    current_app.logger.info(f'GET /foodlog/{foodLogID} route')

    cursor = db.get_db().cursor()
    query = '''
        SELECT LogID, UserID, Date, FoodID, Calories, MealType
        FROM FoodLog
        WHERE LogID = %s
    '''
    cursor.execute(query, (foodLogID,))
    
    theData = cursor.fetchall()

    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response