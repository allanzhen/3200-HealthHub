import logging
logger = logging.getLogger(__name__)

import pandas as pd
import streamlit as st
from streamlit_extras.app_logo import add_logo
import matplotlib.pyplot as plt
import seaborn as sns
import requests
from modules.nav import SideBarLinks

# Setup sidebar and page
SideBarLinks()
st.header('Client Workout Heatmap')

# Welcome message
st.write(f"### Hi, {st.session_state['first_name']}. Let's view your client's workout intensity!")

API_URL = "http://localhost:4000"

# Get user input
user_id = st.text_input("Enter Client User ID for Heatmap:")

if user_id:
    # Fetch workout data
    response = requests.get(f"{API_URL}/workoutlog", params={"user_id": user_id})

    if response.status_code == 200:
        workouts = response.json()
        df = pd.DataFrame(workouts)

        if not df.empty:
            # Convert the Date column to the correct format
            df['Date'] = pd.to_datetime(df['Date'], format='%a, %d %b %Y %H:%M:%S GMT')
            df['Date'] = df['Date'].dt.strftime('%Y-%m-%d')  # Convert to YYYY-MM-DD format

            # Extract day and month
            df['Day'] = pd.to_datetime(df['Date']).dt.day
            df['Month'] = pd.to_datetime(df['Date']).dt.month

            # Pivot data for heatmap
            pivot = df.pivot_table(index='Month', columns='Day', values='Duration', aggfunc='sum')

            # Heatmap
            st.subheader("Workout Duration Heatmap (Minutes)")

            heatmap_fig, ax = plt.subplots(figsize=(12, 6))
            sns.heatmap(pivot, cmap="Blues", annot=True, fmt=".0f", linewidths=.5, ax=ax)
            st.pyplot(heatmap_fig)
        else:
            st.warning("No workout data found for this client.")
    else:
        st.error("Failed to fetch workout data.")