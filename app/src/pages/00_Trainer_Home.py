import logging
import streamlit as st
from modules.nav import SideBarLinks 

# Setup logging
logger = logging.getLogger(__name__)

# Configure Streamlit layout
st.set_page_config(layout='wide')

# Sidebar links
SideBarLinks()

# Title and welcome
st.title(f"Welcome Trainer, {st.session_state['first_name']}!")
st.write('')
st.write('')
st.write('### What would you like to view today?')

# Buttons to navigate to different pages
if st.button('View Client Workout Heatmap', 
             type='primary',
             use_container_width=True):
    st.switch_page('pages/01_WorkoutHeatmap.py')

if st.button('View Client Calories Burned Line Chart', 
             type='primary',
             use_container_width=True):
    st.switch_page('pages/02_CaloriesLineChart.py')

if st.button("View Client Mood vs Sleep Trends",
             type='primary',
             use_container_width=True):
    st.switch_page('pages/03_MoodSleepTrends.py')
