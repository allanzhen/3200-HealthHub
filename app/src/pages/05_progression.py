import logging
logger = logging.getLogger(__name__)

import pandas as pd
import streamlit as st
import matplotlib.pyplot as plt
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()
st.header("robert's strength progression")

API_URL = "http://localhost:4000"
USER_ID = 100

# Dropdowns for split and exercise
st.subheader("select workout split and exercise")
split = st.selectbox("Workout Split", ["Push", "Pull", "Legs"])  # Can be hardcoded or pulled from backend

exercise = st.selectbox("Exercise", ["Bench Press", "Shoulder Press", "Tricep Extension", "Deadlift"])

# Fetch progression data
res = requests.get(f"{API_URL}/workoutlog/progression", params={"exercise": exercise})
if res.status_code == 200:
    data = res.json()
    df = pd.DataFrame(data)
    if not df.empty:
        df["date"] = pd.to_datetime(df["date"])
        df = df.sort_values("date")
        fig, ax = plt.subplots(figsize=(10, 5))
        ax.plot(df["date"], df["weightused"], marker="o", linestyle="-", linewidth=2)
        ax.set_title(f"{exercise} Progression")
        ax.set_xlabel("Date")
        ax.set_ylabel("Weight")
        ax.grid(True)
        st.pyplot(fig)
    else:
        st.warning("this exercise has no data")
else:
    st.error("could not get data")
###