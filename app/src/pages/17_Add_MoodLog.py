import streamlit as st
import logging
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks
import datetime

SideBarLinks()

# selectable mood options for dropdown menu
mood_options = ['Happy', 'Sad', 'Stressed', 'Okay', 'Tired']

st.write("## Add a new Mood Log")
with st.form("Add a new Mood Log"):
    # inputs
    log_id = st.number_input("Mood Log ID Number:", min_value=0, step=1)
    log_uid = st.number_input("User ID Number:", min_value=0, step=1)
    log_date = st.date_input("Date:", value=datetime.date.today())
    log_mood = st.selectbox("How are you feeling today?:", mood_options)

    submitted = st.form_submit_button("Submit")

    if submitted:
        data = {}
        data['LogID'] = log_id  # Ensure you provide a valid LogID
        data['UserID'] = log_uid
        data['Date'] = str(log_date)
        data['Mood'] = log_mood

                
        # Display data in Streamlit
        st.write(data)

        # Make a POST request to the backend API to save the mood log
        try:
            response = requests.post('http://localhost:4000/moodlog/', json=data)
            if response.status_code == 201:
                st.success("Mood log added successfully!")
            else:
                st.error(f"Failed to add mood log. Status code: {response.status_code}")
        except requests.exceptions.RequestException as e:
            st.error(f"An error occurred: {e}")
