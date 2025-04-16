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
st.header('Food List')

food = requests.get('http://localhost:4000/admin/food_list').json()

try:
    st.dataframe(food)
except:
    st.write('Could not get user list!')

with st.form("Add a food"):
    id = st.text_input("Input Food ID (Optional):")
    name = st.text_input("Input Food Name:")
    cals = st.text_input("Input Food Calories:")

    submitted = st.form_submit_button("Submit")

    if submitted:
        data = {}
        data['FoodID'] = id
        data['FoodName'] = name
        data['Calories'] = cals
        st.write(data)

        st.write("Please refresh page to see updated table.")

        requests.post('http://localhost:4000/admin/food_list', json=data)