import streamlit as st
import pandas as pd
import calendar
from datetime import datetime
from modules.nav import SideBarLinks
import requests
# Setup sidebar and page
SideBarLinks()
st.header('Calendar Heatmap')


API_URL = "http://localhost:4000"

# Get current date
date = datetime.now()

# Add dropdown boxes for month and year
col1, col2 = st.columns(2)
with col1:
    selected_month = st.selectbox(
        "Select Month",
        options=list(calendar.month_name)[1:],
        index=date.month-1 # default is current month
    )
with col2:
    selected_year = st.selectbox(
        "Select Year",
        options=range(date.year-5, date.year+6),
        index=5 # default is current year
    )
log = st.selectbox("Select Log", ["Mood Log", "Sleep Log"])

# user id
user_id = st.number_input("User ID:", min_value=0, step=1)
# Generates calendar after selecting a month and year
if st.button("Update Calendar"):
    day_names = list(calendar.day_abbr)
    month_num = list(calendar.month_name).index(selected_month)
    
    # Create title with current month/year
    st.title(f"{selected_month} {selected_year}")

    cal = calendar.monthcalendar(selected_year, month_num)
    df = pd.DataFrame(cal, columns=day_names) #replace(0, "")
    
    st.dataframe(
        df,
        use_container_width=True,
        hide_index=True
    )