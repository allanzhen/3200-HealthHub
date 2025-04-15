import streamlit as st
import logging
logger = logging.getLogger(__name__)
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks
import datetime

SideBarLinks()

mood_options = ['Happy', 'Sad', 'Stressed', 'Okay', 'Tired']

st.write("## Add a new Mood Log")
with st.form("Add a new Mood Log"):
    log_id = st.number_input("Mood Log ID Number:", min_value=0, step=1)
    log_uid = st.number_input("User ID Number:", min_value=0, step=1)
    log_date = st.date_input("Date:", value=datetime.date.today())
    log_mood = st.selectbox("How are you feeling today?:", mood_options)

    submitted = st.form_submit_button("Submit")

    if submitted:
        data = {}
        data['LogID'] = log_id
        data['UserID'] = log_uid
        data['Date'] = str(log_date)
        data['Mood'] = log_mood
        
        st.write(data)

        requests.post('http://localhost:4000/moodlog', json=data)