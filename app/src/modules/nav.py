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

## ------------------------ Examples for Role of usaid_worker ------------------------
def ApiTestNav():
    st.sidebar.page_link("pages/12_API_Test.py", label="Test the API", icon="🛜")


def PredictionNav():
    st.sidebar.page_link(
        "pages/11_Prediction.py", label="Regression Prediction", icon="📈"
    )

def MoodSleepTrendsNav():
    st.sidebar.page_link("pages/03_MoodSleepTrends.py", label="Mood & Sleep Trends", icon="🛌")


# ---------------------------------------------
# Sidebar Navigation for Admin Dashboard
# ---------------------------------------------
 
def UserDataNav():
     st.sidebar.page_link('pages/11_User_Data.py', label='User Data', icon='🔑')
 
def FoodListNav():
     st.sidebar.page_link('pages/12_Food_List.py', label='Food List', icon='🍗')
 
def SupportTicketsNav():
     st.sidebar.page_link('pages/13_Support_Tickets.py', label = 'Support Tickets', icon='🎫')
 
def EmployeeTicketsNav():
     st.sidebar.page_link('pages/14_Employee_Tickets.py', label = 'Employee Tickets', icon='🪪')

# ---------------------------------------------
# Robert sidebars
# ---------------------------------------------
def WorkoutLog():
    st.sidebar.page_link('pages/04_WorkoutLogger.py', label = ' Workout Log', icon='📓')
def progressionGraph():
    st.sidebar.page_link('pages/05_progression.py', label = ' Progression Graph', icon='📈')
def prCalculator():
    st.sidebar.page_link('pages/06_pr_calc.py', label = ' Personal Best Calculations', icon='🏋️‍♂️')

# ---------------------------------------------
# Jane sidebars
# ---------------------------------------------
def addWorkoutLog():
    st.sidebar.page_link('pages/19_Add_WorkoutLog.py', label = 'Add a new Workout Log', icon = '💪')
def addFoodLog():
    st.sidebar.page_link('pages/16_Add_FoodLog.py', label = 'Add New Food Log', icon = '🍱')
# def calendarView():
#     st.sidebar.page_link('pages/18_Calendar.py', label = 'Calendar', icon = '🗓️')
def addMoodLog():
    st.sidebar.page_link('pages/17_AddMoodLog.py', label = 'Add New Mood Log', icon = '🧘')
def addSleepLog():
    st.sidebar.page_link('pages/20_AddSleepLog.py', label = 'Add New Sleep Log', icon = '🛌')

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

        # Show Workout Heatmap, Calories Line Chart, and Mood Sleep Trends if the user is trainer
        if (st.session_state['role'] == 'trainer'):
            WorkoutHeatmapNav()
            CaloriesLineChartNav()
            MoodSleepTrendsNav()
        
        # Show User Data, Food List, Support Tickets, and Employee Tickets
        # if the user is a system administrator
        if (st.session_state['role'] == 'sysadmin'):
            UserDataNav()
            FoodListNav()
            SupportTicketsNav()
            EmployeeTicketsNav()

        if (st.session_state['role'] == 'user'):
            ## INSERT THE NAVS YOU WANT HERE FOR USERS
            WorkoutHeatmapNav()
            WorkoutLog()
            progressionGraph()
            prCalculator()
            addWorkoutLog()
            addMoodLog()
            addSleepLog()


