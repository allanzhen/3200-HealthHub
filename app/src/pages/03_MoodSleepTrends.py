import pandas as pd
import streamlit as st
import requests
import plotly.express as px
from modules.nav import SideBarLinks

# Streamlit Setup
st.set_page_config(layout='wide')
SideBarLinks()

st.title(f"Mood and Sleep Trends Viewer - {st.session_state['first_name']}")

API_URL = "http://localhost:4000"

# User input
user_id = st.text_input("Enter Client User ID for Mood/Sleep Trends:")

if user_id:
    # Fetch data
    mood_response = requests.get(f"{API_URL}/moodlog", params={"user_id": user_id})
    sleep_response = requests.get(f"{API_URL}/sleeplog", params={"user_id": user_id})

    if mood_response.ok and sleep_response.ok:
        moods = pd.DataFrame(mood_response.json())
        sleeps = pd.DataFrame(sleep_response.json())

        if not moods.empty and not sleeps.empty:
            # Parse dates
            moods['Date'] = pd.to_datetime(moods['Date'])
            sleeps['Date'] = pd.to_datetime(sleeps['Date'])

            # Merge
            merged = pd.merge(moods, sleeps, on=['UserID', 'Date'], how='outer').sort_values('Date')
            merged.columns = merged.columns.str.strip()

            # Only convert SleepDuration to numeric (Mood stays text)
            merged['SleepDuration'] = pd.to_numeric(merged['SleepDuration'], errors='coerce')

            # Drop rows where both Mood and SleepDuration are missing
            merged.dropna(subset=['Mood', 'SleepDuration'], how='all', inplace=True)

            if not merged.empty:
                min_date = merged['Date'].min().date()
                max_date = merged['Date'].max().date()

                # Date picker
                start_date, end_date = st.date_input(
                    "Select Date Range:",
                    [min_date, max_date],
                    min_value=min_date,
                    max_value=max_date
                )

                # Filter by date
                merged = merged[(merged['Date'] >= pd.to_datetime(start_date)) & (merged['Date'] <= pd.to_datetime(end_date))]

                # Show filtered table
                st.dataframe(merged[['Date', 'Mood', 'SleepDuration']])

                # Tabs
                tab1, tab2 = st.tabs(["Mood Log", "Sleep Trend"])

                with tab1:
                    st.subheader("Mood Log")
                    st.dataframe(merged[['Date', 'Mood']])

                with tab2:
                    st.subheader("Sleep Hours Colored by Mood")

                    # Scatter Plot: Sleep Duration vs Date, colored by Mood
                    fig = px.scatter(
                        merged,
                        x='Date',
                        y='SleepDuration',
                        color='Mood',
                        labels={'SleepDuration': 'Hours Slept'},
                        title='Sleep Hours vs Mood',
                        color_discrete_sequence=px.colors.qualitative.Set2
                    )

                    fig.update_traces(marker=dict(size=12))
                    fig.update_layout(xaxis_title="Date", yaxis_title="Hours Slept")

                    st.plotly_chart(fig)
            else:
                st.warning("No valid mood or sleep data after cleaning.")
        else:
            st.warning("No mood or sleep data available.")
    else:
        st.error("Failed to fetch mood or sleep data.")

