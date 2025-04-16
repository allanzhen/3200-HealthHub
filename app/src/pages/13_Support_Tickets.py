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
st.header('Support Tickets')

support_tickets = requests.get('http://localhost:4000/admin/support_tix').json()

try:
    st.dataframe(support_tickets)
except:
    st.write('Could not get user list!')

with st.form('Update a ticket\'s status'):
    id = st.text_input("Input Ticket ID to be updated:")
    status = st.text_input("Input the new status of the ticket (Open/Closed):")

    submitted = st.form_submit_button("Submit")

    if submitted:
        data = {}
        data['TicketID'] =  id
        data['Status'] = status

        st.write("Please refresh page to see updated table.")

        requests.put('http://localhost:4000/admin/support_tix', json=data)