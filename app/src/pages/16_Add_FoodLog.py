import streamlit as st
import logging
logger = logging.getLogger(__name__)
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks
import datetime

SideBarLinks()

# meal options for dropdown menu
meal_options = ['Breakfast', 'Lunch', 'Dinner', 'Snack']

st.write("## Add a new Food Log")
with st.form("Add a new Food Log"):
    # inputs
    flog_id = st.number_input("Food Log ID Number:", min_value=0, step=1)
    flog_uid = st.number_input("User ID Number:", min_value=0, step=1)
    flog_date = st.date_input("Date:", value=datetime.date.today())
    flog_mt = st.selectbox("Select a meal type:", meal_options)
    flog_fid = st.number_input("Food ID:", min_value=0, step=1)
    flog_cal = st.number_input("Calories:", min_value=0, step=1)
    flog_protein = st.number_input("Protein:")
    flog_carbs = st.number_input("Carbs:")
    flog_fats = st.number_input("Fats:")

    submitted = st.form_submit_button("Submit")

    if submitted:
        data = {}
        data['LogID'] = flog_id
        data['UserID'] = flog_uid
        data['Date'] = str(flog_date)
        data['MealType'] = flog_mt
        data['FoodID'] = flog_fid
        data['Calories'] = flog_cal
        data['Protein'] = flog_protein
        data['Carbs'] = flog_carbs
        data['Fats'] = flog_fats
        st.write(data)

        requests.post('http://localhost:4000/foodlog', json=data)