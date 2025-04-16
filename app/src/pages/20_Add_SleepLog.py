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
        
        st.write(data)

        requests.post('http://localhost:4000/sleeplog/', json=data)