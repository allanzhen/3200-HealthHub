import streamlit as st
import logging
logger = logging.getLogger(__name__)
import requests
from modules.nav import SideBarLinks
import datetime

SideBarLinks()

st.write("## Add a new Sleep Log")
with st.form("Add a new Sleep Log"):
    # inputs
    log_id = st.number_input("Sleep Log ID Number:", min_value=0, step=1)
    log_uid = st.number_input("User ID Number:", min_value=0, step=1)
    log_date = st.date_input("Date:", value=datetime.date.today())
    log_duration = st.number_input("Sleep Duration:", format="%.2f", step=0.01)
    log_quality = st.slider("Sleep Quality (1 = Bad, 10 = Amazing)", 1, 10)

    submitted = st.form_submit_button("Submit")

    if submitted:
        data = {}
        data['LogID'] = log_id
        data['UserID'] = log_uid
        data['Date'] = str(log_date)
        data['SleepDuration'] = log_duration
        data['SleepQuality'] = log_quality
        
        
        # Display data in Streamlit
        st.write(data)

        # Make a POST request to the backend API to save the sleep log
        try:
            response = requests.post('http://localhost:4000/sleeplog/', json=data)
            if response.status_code == 201:
                st.success("Sleep log added successfully!")
            else:
                st.error(f"Failed to add sleep log. Status code: {response.status_code}")
        except requests.exceptions.RequestException as e:
            st.error(f"An error occurred: {e}")