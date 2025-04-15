import logging
logger = logging.getLogger(__name__)

import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

# Sidebar and page header
SideBarLinks()
st.header("robert's pr calculator")
st.subheader("estimate working set weight for a target pr")

API_URL = "http://localhost:4000"

# Input fields
goal = st.number_input("target pr weight", min_value=1)
reps = st.number_input("number of reps", min_value=1, max_value=30)

# Submit
if st.button("calculate working set weight"):
    res = requests.get(f"{API_URL}/workoutlog/prcalc", params={"goal": goal, "reps": reps})
    if res.status_code == 200:
        result = res.json()
        weight = result.get("target_weight_for_reps")
        st.success(f"to hit a {int(goal)} lb pr for {int(reps)} reps, aim for **{weight} lbs**.")
    else:
        st.error("could not calculate target weight. check input or try again later.")
