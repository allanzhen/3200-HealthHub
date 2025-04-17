import streamlit as st
import logging
import requests
import datetime

# Set up logging
logger = logging.getLogger(__name__)

# SideBarLinks (Make sure you have the correct module for this)
from modules.nav import SideBarLinks

SideBarLinks()

# Meal options for dropdown menu
meal_options = ['Breakfast', 'Lunch', 'Dinner', 'Snack']

st.write("## Add a new Food Log")

with st.form("Add a new Food Log"):
    # Inputs
    flog_id = st.number_input("Food Log ID Number:", min_value=0, step=1)
    flog_uid = st.number_input("User ID Number:", min_value=0, step=1)
    flog_date = st.date_input("Date:", value=datetime.date.today())
    flog_mt = st.selectbox("Select a meal type:", meal_options)
    flog_fid = st.number_input("Food ID:", min_value=0, step=1)
    flog_cal = st.number_input("Calories:", min_value=0, step=1)
    flog_protein = st.number_input("Protein:", min_value=0, step=1)
    flog_carbs = st.number_input("Carbs:", min_value=0, step=1)
    flog_fats = st.number_input("Fats:", min_value=0, step=1)

    # Submit button
    submitted = st.form_submit_button("Submit")

    if submitted:
        data = {
            'LogID': flog_id,
            'UserID': flog_uid,  # Ensure this matches backend expected key (i.e. 'user_id')
            'Date': str(flog_date),
            'MealType': flog_mt,
            'FoodID': flog_fid,
            'Calories': flog_cal,
            'Protein': flog_protein,
            'Carbs': flog_carbs,
            'Fats': flog_fats
        }

        # Display data in Streamlit
        st.write(data)

        # Make a POST request to the backend API to save the food log
        try:
            response = requests.post('http://localhost:4000/foodlog/', json=data)
            if response.status_code == 201:
                st.success("Food log added successfully!")
            else:
                st.error(f"Failed to add food log. Status code: {response.status_code}")
        except requests.exceptions.RequestException as e:
            st.error(f"An error occurred: {e}")
        