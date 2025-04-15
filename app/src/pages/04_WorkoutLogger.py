

import logging
logger = logging.getLogger(__name__)

import pandas as pd
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

# sidebar navigation and header
SideBarLinks()
st.header("Roberts Workout Logger")


API_URL = "http://localhost:4000"
USER_ID = 100

# add a new workout
st.subheader("Add a New Workout")

with st.form("add_workout_form"):
    date = st.date_input("Workout Date")
    exercise = st.text_input("Exercise type")
    duration = st.number_input("Duration in Minutes", min_value=0)
    calories = st.number_input("Calories Burned", min_value=0)
    notes = st.text_input("trainer Notes ")
    sets = st.number_input("Num of Sets", min_value=1)
    reps = st.number_input("Reps per Set", min_value=1)
    weight = st.number_input("Weight", min_value=0.0)

    submitted = st.form_submit_button("Log Workout")

    if submitted:
        workout_data = {
            "user_id": USER_ID,
            "date": str(date),
            "exercise": exercise,
            "duration": duration,
            "calories_burned": calories,
            "trainer_notes": notes,
            "sets": sets,
            "reps": reps,
            "weight": weight
        }

        res = requests.post(f"{API_URL}/workoutlog", json=workout_data)

        if res.status_code == 201:
            st.success("workout log sucessfully added")
        else:
            st.error("could not add workout log")

# look at existing logs
st.subheader("Previous Workouts")
res = requests.get(f"{API_URL}/workoutlog", params={"user_id": USER_ID})
if res.status_code == 200:
    logs = res.json()
    df = pd.DataFrame(logs)
    if not df.empty:
        df['date'] = pd.to_datetime(df['date'])
        df = df.sort_values("date", ascending=False)
        df = df[["date", "ExerciseType", "Duration", "CaloriesBurned", "WeightUsed", "setCount", "repsInSet", "TrainerNotes"]]
        df.columns = ["date", "Exercise", "Duration", "Calories", "Weight", "Sets", "Reps", "Notes"]

        st.dataframe(df, use_container_width=True)
    else:
        st.info("There Are No Workouts In the Log")
else:
    st.error("error")
