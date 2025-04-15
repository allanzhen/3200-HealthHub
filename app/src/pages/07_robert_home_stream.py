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
st.title("Robert's Dashboard")
st.write('')
st.write('')
st.write(f"### Welcome back, {st.session_state['first_name']}! Ready to train smarter?")

if st.button("Log a Workout", 
             type='primary',
             use_container_width=True):
    st.switch_page('pages/04_WorkoutLogger.py')

if st.button("View Strength Progression", 
             type='primary',
             use_container_width=True):
    st.switch_page('pages/05_progression.py')

if st.button("Calculate PR Weights", 
             type='primary',
             use_container_width=True):
    st.switch_page('pages/06_pr_calc.py')
