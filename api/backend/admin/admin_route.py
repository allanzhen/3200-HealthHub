########################################################
# System Admin blueprint of endpoints
########################################################
from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

admin_route = Blueprint('admin_route', __name__)

# Gets all user data
@admin_route.route('/users', methods=['GET'])
def get_user_info():
    cursor = db.get_db().cursor()
    the_query = '''
    SELECT *
    FROM User;
    '''
    cursor.execute(the_query)
    theData = cursor.fetchall()
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    the_response.mimetype='application/json'
    return the_response

# Gets all the food items stored in the predefined food list
@admin_route.route('/food_list', methods=['GET'])
def get_food_list():
    cursor = db.get_db().cursor()
    the_query = '''
    SELECT *
    FROM Food;
    '''
    cursor.execute(the_query)
    theData = cursor.fetchall()
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    the_response.mimetype='application/json'
    return the_response

# Gets all the support tickets that are open
@admin_route.route('/support_tix', methods=['GET'])
def get_support_tickets():
    cursor = db.get_db().cursor()
    the_query = '''
    SELECT *
    FROM SupportTicket
    '''

    cursor.execute(the_query)
    theData = cursor.fetchall()
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    the_response.mimetype='application/json'
    return the_response

# Gets all the employee tickets given by supervisors to assign work to employees
@admin_route.route('/employee_tix', methods=['GET'])
def get_employee_tickets():
    cursor = db.get_db().cursor()
    the_query = '''
    SELECT *
    FROM TicketEmployee
    '''
    cursor.execute(the_query)
    theData = cursor.fetchall()
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    the_response.mimetype='application/json'
    return the_response

# Put add a food item into the food list
@admin_route.route('/food_list', methods=['POST'])
def add_food_item():
    ## Get data from request
    the_data = request.json
    current_app.logger.info(the_data)

    ## Turn data from json into variables
    id = the_data['FoodID']
    name = the_data['FoodName']
    cals = the_data['Calories']

    query = f'''
        INSERT INTO Food (FoodID, FoodName, Calories)
        VALUES({str(id)}, '{name}', {str(cals)});
    '''

    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    response = make_response("Successfully added food")
    response.status_code = 200
    return response

# Remove a user from the user data table
@admin_route.route('/users', methods=['DELETE'])
def remove_user():
    ## Get data from request
    the_data = request.json
    current_app.logger.info(the_data)

    ## Turn data from json into variables
    email = the_data['Email']

    query = f'''
        DELETE
        FROM User
        WHERE Email = '{email}';
    '''

    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    response = make_response(f"Successfully removed user with email '{email}'")
    response.status_code = 200
    return response

# Update user information depending on details of request
@admin_route.route('/users', methods=['PUT'])
def update_user():
    ## Get data from request
    the_data = request.json
    current_app.logger.info(the_data)

    ## Check variables to see what is in json
    email = the_data['Email']
    new_email = the_data['New Email']
    name = the_data['Name']
    new_name = the_data['New Name']

    response_message = ''
    if email != None and new_email != None:
        query = f'''
            UPDATE User
            SET Email = '{new_email}'
            WHERE Email = '{email}';
        '''

        current_app.logger.info(query)

        cursor = db.get_db().cursor()
        cursor.execute(query)
        db.get_db().commit()

        response_message += f"Successfully updated email '{email}' to '{new_email}'\n"
    
    if name != None and new_name != None:
        query = f'''
            UPDATE User
            SET Name = '{new_name}'
            WHERE Name = '{name}';
        '''

        current_app.logger.info(query)

        cursor = db.get_db().cursor()
        cursor.execute(query)
        db.get_db().commit()

        response_message += f"Successfully updated name '{name}' to '{new_name}'\n"
    
    response = make_response(response_message)
    response.status_code = 200
    return response

@admin_route.route('/support_tix', methods=['PUT'])
def update_support_ticket():
    the_data = request.json
    current_app.logger.info(the_data)

    id = the_data['TicketID']
    status = the_data['Status']

    query = f'''
        UPDATE SupportTicket
        SET Status = '{status}'
        WHERE TicketID = {id};
    '''

    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    response = make_response('Successfully updated support ticket.')
    response.status_code = 200
    return response

@admin_route.route('/employee_tix', methods=['POST'])
def assign_employee_ticket():
    the_data = request.json
    current_app.logger.info(the_data)

    employee = the_data['EmployeeID']
    ticket = the_data['TicketID']

    query = f'''
        INSERT INTO TicketEmployee(TicketID, EmployeeID)
        VALUES ({ticket}, {employee});
    '''

    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    response = make_response('Successfully assigned work')
    response.status_code = 200
    return response