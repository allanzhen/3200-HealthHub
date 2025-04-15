import streamlit as st
import logging
logger = logging.getLogger(__name__)
import requests
from modules.nav import SideBarLinks
import datetime

SideBarLinks()

st.write("## Add a new Workout Log")
with st.form("Add a new Workout Log"):
    log_id = st.number_input("Workout Log ID Number:", min_value=0, step=1)
    log_uid = st.number_input("User ID Number:", min_value=0, step=1)
    log_date = st.date_input("Date:", value=datetime.date.today())
    log_et = st.text_input("Exercise Type:")
    log_duration = st.number_input("Workout Duration:", min_value=0, step=1)
    log_cb = st.number_input("Calories Burned:", min_value=0, step=1)
    log_sc = st.number_input("Number of Sets:", min_value=0, step=1)
    log_reps = st.number_input("Number of Repetitions:", min_value=0, step=1)
    log_weight = st.number_input("Weight Used:", format="%.2f", step=0.01)
    submitted = st.form_submit_button("Submit")

    if submitted:
        data = {}
        data['LogID'] = log_id
        data['UserID'] = log_uid
        data['Date'] = str(log_date)
        data['ExerciseType'] = log_et
        data['Duration'] = log_duration
        data['CaloriesBurned'] = log_cb
        data['setCount'] = log_sc
        data['repsInSet'] = log_reps
        data['WeightUsed'] = log_weight
        st.write(data)

        requests.post('http://localhost:4000/workoutlog', json=data)