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
st.header('User Data')

users = requests.get('http://localhost:4000/admin/users').json()

try:
    st.dataframe(users)
except:
    st.write('Could not get user list!')

with st.form("Update a user's email"):
    email = st.text_input("Input email to be changed:")
    new_email = st.text_input("Input new email:")

    submitted = st.form_submit_button("Submit")

    if submitted:
        data = {}
        data['Email'] = email
        data['New Email'] = new_email
        data['Name'] = None
        data['New Name'] = None

        st.write("Please refresh page to see updated table.")

        requests.put('http://localhost:4000/admin/users', json=data)

with st.form("Update a user's name"):
    name = st.text_input("Input name to be changed:")
    new_name = st.text_input("Input new name:")

    submitted = st.form_submit_button("Submit")

    if submitted:
        data = {}
        data['Email'] = None
        data['New Email'] = None
        data['Name'] = name
        data['New Name'] = new_name

        st.write("Please refresh page to see updated table.")

        requests.put('http://localhost:4000/admin/users', json=data)

with st.form("Delete a user:"):
    st.write("***WARNING CANNOT BE UNDONE")
    email = st.text_input("Email of user to delete")

    submitted = st.form_submit_button("Submit")

    if submitted:
        data = {}
        data['Email'] = email

        st.write("Please refresh page to see updated table.")

        requests.delete('http://localhost:4000/admin/users', json=data)