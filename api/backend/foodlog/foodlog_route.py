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

#------------------------------------------------------------
# Inserts food and its data to the food log
@foodlog_route.route('/', methods=['POST'])
def add_food_log():
    current_app.logger.info('POST /foodlog route')

    data = request.get_json()
    cursor = db.get_db().cursor()

    query = '''
        INSERT INTO FoodLog (LogID, UserID, Date, FoodID, Calories, MealType)
        VALUES (%s, %s, %s, %s, %s, %s)
    '''

    cursor.execute(query, (
        data["LogID"], 
        data["UserID"],
        data["Date"],
        data["FoodID"],
        data["Calories"],
        data["MealType"]
    ))

    db.get_db().commit()

    the_response = make_response(jsonify({"message": "Food log added"}))
    the_response.status_code = 201
    return the_response

#------------------------------------------------------------
# Update food log info for customer with particular userID
@foodlog_route.route('/', methods=['PUT'])
def update_foodlog():
    current_app.logger.info('PUT /foodlog route')
    data = request.json

    query = '''
        UPDATE FoodLog
        SET UserID = %s, Date = %s, MealType = %s, FoodID = %s,
            Calories = %s, Protein = %s, Carbs = %s, Fats = %s
        WHERE LogID = %s
    '''
    values = (
        data['UserID'], data['Date'], data['MealType'], data['FoodID'],
        data['Calories'], data['Protein'], data['Carbs'],
        data['Fats'], data['LogID']
    )

    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return jsonify({'message': 'Food log updated!'}), 200

