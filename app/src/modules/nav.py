import streamlit as st

# ---------------------------------------------
# Sidebar Navigation for Trainer Dashboard
# ---------------------------------------------

def HomeNav():
    if st.sidebar.button("🏠 Home"):
        st.switch_page("Home.py")

def WorkoutHeatmapNav():
    st.sidebar.page_link("pages/01_WorkoutHeatmap.py", label="Workout Heatmap", icon="🔥")

def CaloriesLineChartNav():
    st.sidebar.page_link("pages/02_CaloriesLineChart.py", label="Calories Line Chart", icon="📈")

def MoodSleepTrendsNav():
    st.sidebar.page_link("pages/03_MoodSleepTrends.py", label="Mood & Sleep Trends", icon="🛌")

# ---------------------------------------------
# Main function to load Sidebar Links
# ---------------------------------------------
def SideBarLinks(show_home=True):
    """
    This function adds sidebar links based on the trainer role.
    """

    # Add a logo (optional)
    st.sidebar.image("assets/logo.png", width=150)

    # If user is not authenticated, redirect to Home
    if "authenticated" not in st.session_state:
        st.session_state.authenticated = False
        st.switch_page("Home.py")

    if show_home:
        HomeNav()

    # Show all pages if authenticated
    if st.session_state.get("authenticated", False):

        WorkoutHeatmapNav()
        CaloriesLineChartNav()
        MoodSleepTrendsNav()