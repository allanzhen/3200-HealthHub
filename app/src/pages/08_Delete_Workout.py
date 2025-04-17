import logging
logger = logging.getLogger(__name__)

import pandas as pd
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

# Sidebar navigation and header
SideBarLinks()
st.header("Delete a Workout Log")

API_URL = "http://localhost:4000"

# Delete a workout log
st.subheader("Delete a Workout Log")

with st.form("delete_workout_form"):
    log_id_to_delete = st.number_input("Log ID to Delete", min_value=0, step=1)
    
    # Submit button to delete workout log
    submitted_delete = st.form_submit_button("Delete Workout Log")
    
    if submitted_delete:
        # Make API request to delete workout log
        res = requests.delete(f"{API_URL}/workoutlog/{log_id_to_delete}")
        
        if res.status_code == 200:
            st.success(f"Workout log {log_id_to_delete} successfully deleted.")
        else:
            st.error(f"Failed to delete workout log {log_id_to_delete}. Status code: {res.status_code}")