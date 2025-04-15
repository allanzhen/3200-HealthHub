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
st.header('Employee Tickets')

employee_tickets = requests.get('http://api:4000/a/employee_tix').json()

try:
    st.dataframe(employee_tickets)
except:
    st.write('Could not get user list!')

with st.form('Update a ticket\'s status'):
    id = st.text_input("Input Ticket ID to be assigned:")
    employee = st.text_input("Input the ID of the employee who will work on this ticket:")

    submitted = st.form_submit_button("Submit")

    if submitted:
        data = {}
        data['TicketID'] =  id
        data['EmployeeID'] = employee

        st.write("Please refresh page to see updated table.")

        requests.post('http://api:4000/a/employee_tix', json=data)