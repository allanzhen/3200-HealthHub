import logging
logger = logging.getLogger(__name__)

import pandas as pd
import streamlit as st
import matplotlib.pyplot as plt
import requests
from modules.nav import SideBarLinks

st.set_page_config(layout='wide')
SideBarLinks()

st.title(f"Calories Burned Viewer - {st.session_state['first_name']}")

st.write('Use this page to view a client\'s calories burned over time.')

API_URL = "http://localhost:4000"

# Enter user ID
user_id = st.text_input("Enter Client User ID for Line Chart:")

if user_id:
    response = requests.get(f"{API_URL}/workoutlog", params={"user_id": user_id})

    if response.status_code == 200:
        workouts = response.json()
        df = pd.DataFrame(workouts)

        if not df.empty:
            # Convert the 'Date' column to datetime with the correct format
            df['Date'] = pd.to_datetime(df['Date'], format='%a, %d %b %Y %H:%M:%S GMT')

            # Sort the data by date
            df = df.sort_values('Date')

            st.subheader("Calories Burned Over Time")
            fig, ax = plt.subplots(figsize=(10, 5))
            ax.plot(df['Date'], df['CaloriesBurned'], marker='o')
            ax.set_title('Calories Burned Over Time')
            ax.set_xlabel('Date')
            ax.set_ylabel('Calories Burned')
            plt.xticks(rotation=45)
            st.pyplot(fig)
        else:
            st.warning("No workout data found for this client.")
    else:
        st.error("Failed to fetch workout data.")