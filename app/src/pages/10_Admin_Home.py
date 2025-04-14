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
st.title('Dashboard')
st.write('')
st.write('')
st.write(f"### Welcome to your Admin Dashboard, {st.session_state['first_name']}!")

# Buttons to navigate to different pages
if st.button('Manage User Data', 
             type='primary',
             use_container_width=True):
    st.switch_page('pages/11_User_Data.py')

if st.button('Manage Food List', 
             type='primary',
             use_container_width=True):
    st.switch_page('pages/12_Food_List.py')

if st.button("Read Chat/Support Tickets",
             type='primary',
             use_container_width=True):
    st.switch_page('pages/13_Support_Tickets.py')

if st.button("Assign Work to Employees",
             type='primary',
             use_container_width=True):
    st.switch_page('pages/14_Employee_Tickets.py')