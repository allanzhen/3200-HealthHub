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
st.title(f"Welcome User, {st.session_state['first_name']}!")
st.write('')
st.write('')
st.write('### What would you like to view today?')

# Buttons to navigate to different pages
# if st.button('View Calendar', 
#              type='primary',
#              use_container_width=True):
#     st.switch_page('pages/18_Calendar.py')

if st.button('Add Food Log', 
             type='primary',
             use_container_width=True):
    st.switch_page('pages/16_Add_FoodLog.py')

if st.button("Add Mood Log",
             type='primary',
             use_container_width=True):
    st.switch_page('pages/17_Add_MoodLog.py')

if st.button("Add Workout Log",
             type='primary',
             use_container_width=True):
    st.switch_page('pages/19_Add_WorkoutLog.py')
if st.button("Add Sleep Log",
             type='primary',
             use_container_width=True):
    st.switch_page('pages/20_Add_SleepLog.py')