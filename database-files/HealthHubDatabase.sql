DROP DATABASE IF EXISTS HealthHub;

CREATE DATABASE HealthHub;
USE HealthHub;

CREATE TABLE Trainer (
    TrainerID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Certifications TEXT,
    Specializations TEXT
);

CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Role VARCHAR(50)
);

CREATE TABLE User (
    UserID INT PRIMARY KEY,
    TrainerID INT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Age INT,
    Gender VARCHAR(10),
    Height DECIMAL(5,2),
    Weight DECIMAL(5,2),
    Goals TEXT,
    Goal_Weight DECIMAL(5,2),
    DOB DATE,
    FOREIGN KEY (TrainerID) REFERENCES Trainer(TrainerID) ON DELETE SET NULL
);

CREATE TABLE SupportTicket (
    TicketID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    Issue TEXT NOT NULL,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    Status VARCHAR(20) DEFAULT 'Open',
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE
);

CREATE TABLE WorkoutPlan (
    PlanID INT PRIMARY KEY,
    UserID INT,
    TrainerID INT,
    PlanName VARCHAR(100),
    Duration INT, # in weeks
    Goal VARCHAR(100),
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE,
    FOREIGN KEY (TrainerID) REFERENCES Trainer(TrainerID) ON DELETE SET NULL
);

CREATE TABLE Split (
    SplitID INT PRIMARY KEY AUTO_INCREMENT,
    SplitName VARCHAR(100) NOT NULL,
    UserID INT,
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE
);

CREATE TABLE WorkoutLog (
    LogID INT,
    UserID INT,
    Date DATE NOT NULL,
    ExerciseType VARCHAR(50),
    Duration INT,
    CaloriesBurned INT,
    TrainerNotes TEXT,
    setCount INT,
    repsInSet INT,
    WeightUsed DECIMAL(5,2),
    PRIMARY KEY (UserID, LogID),
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE
);

CREATE TABLE Food (
    FoodID INT PRIMARY KEY AUTO_INCREMENT,
    FoodName VARCHAR(100) NOT NULL,
    Calories INT
);

CREATE TABLE FoodLog (
    LogID INT,
    UserID INT,
    Date DATE NOT NULL,
    MealType VARCHAR(50), # Breakfast, Lunch, Dinner, Snack
    FoodID INT,
    Calories INT,
    Protein DECIMAL(5,2),
    Carbs DECIMAL(5,2),
    Fats DECIMAL(5,2),
    PRIMARY KEY (UserID, LogID),
    FOREIGN KEY (FoodID) REFERENCES Food(FoodID) ON DELETE SET NULL,
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE
);

CREATE TABLE SleepLog (
    LogID INT,
    UserID INT,
    Date DATE NOT NULL,
    SleepDuration DECIMAL(4,2),
    SleepQuality INT CHECK (SleepQuality BETWEEN 1 AND 10),
    PRIMARY KEY (UserID, LogID),
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE
);

CREATE TABLE MoodLog (
    LogID INT,
    UserID INT,
    Date DATE NOT NULL,
    Mood VARCHAR(50),
    PRIMARY KEY (UserID, LogID),
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE
);
CREATE TABLE ProgressTracking (
    ProgressID INT PRIMARY KEY,
    UserID INT,
    Date DATE NOT NULL,
    Weight DECIMAL(5,2),
    BMI DECIMAL(5,2),
    BodyFatPercentage DECIMAL(5,2),
    TrainerComments TEXT,
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE
);

CREATE TABLE Appointment (
    AppointmentID INT PRIMARY KEY,
    UserID INT,
    ClientID INT,
    Date DATE NOT NULL,
    Notes TEXT,
    FOREIGN KEY (UserID) REFERENCES Trainer(TrainerID) ON DELETE CASCADE,
    FOREIGN KEY (ClientID) REFERENCES User(UserID) ON DELETE CASCADE
);

CREATE TABLE HeartRateLog (
    LogID INT,
    UserID INT,
    Date DATE NOT NULL,
    AvgHeartRate INT NOT NULL,
    PRIMARY KEY (UserID, LogID),
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE
);

CREATE TABLE VisualizationData (
    VizID INT PRIMARY KEY,
    UserID INT,
    MoodLogUserID INT,
    MoodLogID INT,
    HeartRateUserID INT,
    HeartRateID INT,
    SleepLogUserID INT,
    SleepLogID INT,
    WorkoutLogUserID INT,
    WorkoutLogID INT,
    FoodLogUserID INT,
    FoodLogID INT,
    Date DATE NOT NULL,
    DataType VARCHAR(50), -- Calories, Workouts, Sleep, Mood, etc.
    Value DECIMAL(10,2),

    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE,

    FOREIGN KEY (MoodLogUserID, MoodLogID)
        REFERENCES MoodLog(UserID, LogID) ON DELETE CASCADE,

    FOREIGN KEY (HeartRateUserID, HeartRateID)
        REFERENCES HeartRateLog(UserID, LogID) ON DELETE CASCADE,

    FOREIGN KEY (SleepLogUserID, SleepLogID)
        REFERENCES SleepLog(UserID, LogID) ON DELETE CASCADE,

    FOREIGN KEY (WorkoutLogUserID, WorkoutLogID)
        REFERENCES WorkoutLog(UserID, LogID) ON DELETE CASCADE,

    FOREIGN KEY (FoodLogUserID, FoodLogID)
        REFERENCES FoodLog(UserID, LogID) ON DELETE CASCADE
);

CREATE TABLE AIInsights (
    InsightID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    TrainerID INT,
    Date DATE NOT NULL,
    PredictedWeight DECIMAL(5,2),
    PredictedMood VARCHAR(50),
    PredictedCalories INT,
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE,
    FOREIGN KEY (TrainerID) REFERENCES Trainer(TrainerID) ON DELETE SET NULL
);


CREATE TABLE DailySchedule (
    ScheduleID INT PRIMARY KEY AUTO_INCREMENT,
    SplitID INT,
    Date DATE NOT NULL,
    FOREIGN KEY (SplitID) REFERENCES Split(SplitID) ON DELETE CASCADE
);

# Many-to-Many Relationships Bridge Tables
CREATE TABLE TicketEmployee (
    TicketID INT,
    EmployeeID INT,
    AssignedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (TicketID, EmployeeID),
    FOREIGN KEY (TicketID) REFERENCES SupportTicket(TicketID) ON DELETE CASCADE,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID) ON DELETE CASCADE
);

CREATE TABLE Exercise (
    ExerciseID INT PRIMARY KEY,
    Name VARCHAR(100),
    Description TEXT,
    MuscleGroup VARCHAR(50),
    EquipmentRequired VARCHAR(50),
    PersonalRecord DOUBLE,
    SplitID int,
    FOREIGN KEY (SplitID) REFERENCES Split(SplitID) ON DELETE CASCADE
);

CREATE TABLE ClientExercise (
    UserID INT,
    ExerciseID INT,
    PRIMARY KEY (UserID, ExerciseID),
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE,
    FOREIGN KEY (ExerciseID) REFERENCES Exercise(ExerciseID) ON DELETE CASCADE
);

CREATE TABLE WorkoutPlanExercise (
    PlanID INT,
    ExerciseID INT,
    PRIMARY KEY (PlanID, ExerciseID),
    FOREIGN KEY (PlanID) REFERENCES WorkoutPlan(PlanID) ON DELETE CASCADE,
    FOREIGN KEY (ExerciseID) REFERENCES Exercise(ExerciseID) ON DELETE CASCADE
);

# Sample Data

# Insert into Trainer
INSERT INTO Trainer (TrainerID, Name, Email, Certifications, Specializations)
VALUES
(1, 'John Doe', 'johndoe@example.com', 'ACE Certified Personal Trainer, CPR Certified', 'Strength Training, Nutrition'),
(2, 'Jane Smith', 'janesmith@example.com', 'NSCA Certified Strength Coach', 'Cardio, Weight Loss'),
(3, 'Michael Johnson', 'michaelj@example.com', 'Certified Fitness Trainer', 'HIIT, Endurance Training'),
(4, 'Sara Lee', 'saralee@example.com', 'Personal Trainer Certification', 'Bodybuilding, Flexibility'),
(5, 'Emily Davis', 'emilyd@example.com', 'Yoga Instructor Certification', 'Yoga, Pilates'),
(6, 'David Williams', 'davidw@example.com', 'ACE Certified Personal Trainer, CPR Certified', 'Strength Training, Endurance'),
(7, 'Sophia Johnson', 'sophiaj@example.com', 'NASM Certified Personal Trainer', 'Pilates, Stretching'),
(8, 'Lucas Brown', 'lucasb@example.com', 'CSCS Certified Strength Coach', 'Powerlifting, Functional Fitness'),
(9, 'Olivia White', 'oliviaw@example.com', 'Certified Strength and Conditioning Specialist', 'Endurance, Strength Training'),
(10, 'Liam Harris', 'liamh@example.com', 'Yoga Alliance Certified Instructor', 'Yoga, Meditation'),
(11, 'Isabella Martinez', 'isabellam@example.com', 'ACE Certified Personal Trainer', 'Bodyweight Training, Flexibility'),
(12, 'Jackson Moore', 'jacksonm@example.com', 'NSCA Certified Strength Coach', 'Olympic Lifting, Endurance'),
(13, 'Mason Taylor', 'masont@example.com', 'National Academy of Sports Medicine (NASM)', 'HIIT, CrossFit'),
(14, 'Ethan Anderson', 'ethana@example.com', 'Certified Personal Trainer', 'Running, Cardio Fitness'),
(15, 'Charlotte Robinson', 'charlotter@example.com', 'Yoga Instructor Certified', 'Yoga, Meditation'),
(16, 'Amelia Clark', 'ameliac@example.com', 'Certified Personal Trainer, CrossFit Level 1', 'Strength Training, CrossFit'),
(17, 'James Lewis', 'jamesl@example.com', 'ACE Certified Personal Trainer', 'Muscle Building, Cardio'),
(18, 'Benjamin Walker', 'benjaminw@example.com', 'NSCA Certified Strength Coach', 'Weight Training, Strength Training'),
(19, 'Avery Harris', 'averyh@example.com', 'Certified Fitness Trainer', 'Strength, Flexibility'),
(20, 'Harper Young', 'harpery@example.com', 'Certified Personal Trainer', 'Running, Weight Loss'),
(21, 'Henry King', 'henryk@example.com', 'Certified CrossFit Coach', 'CrossFit, Olympic Lifting'),
(22, 'Mila Scott', 'milas@example.com', 'Yoga Instructor Certified', 'Yoga, Flexibility'),
(23, 'Eli Carter', 'elic@example.com', 'Certified Personal Trainer, Sports Nutritionist', 'Sports Performance, Weight Management'),
(24, 'Grace Walker', 'gracew@example.com', 'Certified Strength and Conditioning Specialist', 'Football, Conditioning'),
(25, 'Samuel Allen', 'samuela@example.com', 'ACE Certified Personal Trainer', 'Functional Movement, Injury Prevention'),
(26, 'Victoria Hall', 'victoriah@example.com', 'Certified Personal Trainer', 'Strength Training, Pilates'),
(27, 'Leo Adams', 'leoa@example.com', 'CrossFit Level 2 Coach', 'CrossFit, Conditioning'),
(28, 'Ella Nelson', 'ellan@example.com', 'Certified Fitness Trainer', 'Strength, Posture Improvement'),
(29, 'Evan Baker', 'evanb@example.com', 'NSCA Certified Strength Coach', 'Speed and Agility, Strength Training'),
(30, 'Scarlett Perez', 'scarlettp@example.com', 'Yoga Alliance Certified Instructor', 'Hatha Yoga, Strength Building');

# Insert into Employee
INSERT INTO Employee (EmployeeID, Name, Email, Role)
VALUES
(1, 'John Doe', 'johndoe@example.com', 'Software Developer'),
(2, 'Jane Smith', 'janesmith@example.com', 'Full Stack Developer'),
(3, 'Michael Johnson', 'michaelj@example.com', 'Web Developer'),
(4, 'Sara Lee', 'saralee@example.com', 'Data Analyst'),
(5, 'Emily Davis', 'emilyd@example.com', 'Mobile App Developer'),
(6, 'David Williams', 'davidw@example.com', 'DevOps Engineer'),
(7, 'Sophia Clark', 'sophiac@example.com', 'QA Engineer'),
(8, 'Lucas Brown', 'lucasb@example.com', 'UI/UX Designer'),
(9, 'Olivia Harris', 'oliviah@example.com', 'Database Administrator'),
(10, 'Liam Martinez', 'liamm@example.com', 'Backend Developer'),
(11, 'Isabella Taylor', 'isabellat@example.com', 'Software Engineer'),
(12, 'James King', 'jamesk@example.com', 'Frontend Developer'),
(13, 'Benjamin Lee', 'benjaminl@example.com', 'Project Manager'),
(14, 'Mason Robinson', 'masonr@example.com', 'Systems Architect'),
(15, 'Charlotte Young', 'charlottey@example.com', 'Product Manager'),
(16, 'Amelia Walker', 'ameliaw@example.com', 'Cloud Engineer'),
(17, 'Henry Anderson', 'henrya@example.com', 'Software Developer'),
(18, 'Ella Scott', 'ellas@example.com', 'Business Analyst'),
(19, 'Jack Taylor', 'jackt@example.com', 'Security Engineer'),
(20, 'Grace Miller', 'gracem@example.com', 'Network Administrator'),
(21, 'Oliver Scott', 'olivers@example.com', 'Machine Learning Engineer'),
(22, 'Lily Evans', 'lilye@example.com', 'Web Developer'),
(23, 'Ethan Nelson', 'ethann@example.com', 'Application Support Specialist'),
(24, 'Mia White', 'miaw@example.com', 'Game Developer'),
(25, 'Nathan Brooks', 'nathanb@example.com', 'Cloud Solutions Architect'),
(26, 'Zoe Allen', 'zoea@example.com', 'Database Engineer'),
(27, 'Daniel Carter', 'danielc@example.com', 'Front-end Developer'),
(28, 'Sophia Turner', 'sophiat@example.com', 'Business Intelligence Analyst'),
(29, 'Henry Green', 'henryg@example.com', 'Technical Lead'),
(30, 'Ava Perez', 'avap@example.com', 'Product Designer');


# Insert into User
INSERT INTO User (UserID, TrainerID, Name, Email, Age, Gender, Height, Weight, Goals, Goal_Weight, DOB)
VALUES
(1, 1, 'Jake Anderson', 'jakea@example.com', 30, 'Male', 180.00, 80.50, 'Lose 10kg, Build Muscle', 70.00, '1995-04-10'),
(2, 2, 'Olivia Smith', 'olivias@example.com', 28, 'Female', 165.00, 70.00, 'Weight Loss, Improve Cardio', 60.00, '1997-06-15'),
(3, 3, 'Liam Brown', 'liamb@example.com', 35, 'Male', 175.00, 90.00, 'Increase Stamina, Run a Marathon', 75.00, '1990-11-21'),
(4, 4, 'Sophia Williams', 'sophiaw@example.com', 32, 'Female', 160.00, 65.00, 'Tone Body, Improve Strength', 60.00, '1993-02-05'),
(5, 5, 'Ethan Davis', 'ethand@example.com', 25, 'Male', 185.00, 85.00, 'Improve Flexibility, Lose Fat', 75.00, '2000-01-30'),
(6, 6, 'Emma Green', 'emmag@example.com', 22, 'Female', 160.00, 58.00, 'Lose weight, Improve flexibility', 50.00, '2002-03-11'),
(7, 7, 'Oliver King', 'oliverk@example.com', 40, 'Male', 180.00, 92.00, 'Build muscle mass', 80.00, '1985-07-21'),
(8, 8, 'Mason Scott', 'masons@example.com', 29, 'Male', 170.00, 78.00, 'Improve strength, Lean body', 70.00, '1996-01-15'),
(9, 9, 'Ava Taylor', 'avat@example.com', 33, 'Female', 162.00, 65.00, 'Body Toning', 60.00, '1992-10-03'),
(10, 10, 'Lucas White', 'lucasw@example.com', 27, 'Male', 175.00, 80.00, 'Build muscle, Lose belly fat', 72.00, '1998-09-05'),
(11, 11, 'Grace Miller', 'gracem@example.com', 26, 'Female', 168.00, 72.00, 'Improve strength, Lean muscle', 65.00, '1999-04-18'),
(12, 12, 'Liam Clark', 'liamc@example.com', 32, 'Male', 177.00, 84.00, 'Strength, Increase endurance', 80.00, '1993-08-09'),
(13, 13, 'Zoe Harrison', 'zoeh@example.com', 30, 'Female', 160.00, 63.00, 'Body sculpting, Flexibility', 58.00, '1995-02-25'),
(14, 14, 'Eli Carter', 'elic@example.com', 27, 'Male', 182.00, 85.00, 'Run a 10k, Lose weight', 75.00, '1998-11-14'),
(15, 15, 'Chloe Bennett', 'chloeb@example.com', 24, 'Female', 158.00, 55.00, 'Improve fitness, Bodyweight exercises', 50.00, '2000-06-12'),
(16, 16, 'Ethan Brooks', 'ethanb@example.com', 28, 'Male', 185.00, 90.00, 'Increase muscle mass, Strength', 80.00, '1997-02-22'),
(17, 17, 'Sophia Green', 'sophiag@example.com', 31, 'Female', 170.00, 70.00, 'Lose weight, Improve endurance', 65.00, '1994-09-30'),
(18, 18, 'Aidan Harris', 'aidanh@example.com', 34, 'Male', 180.00, 88.00, 'Strength, Cardio fitness', 78.00, '1991-04-01'),
(19, 19, 'Lily Carter', 'lilyc@example.com', 26, 'Female', 165.00, 60.00, 'Lean body, Flexibility', 55.00, '1999-08-12'),
(20, 20, 'Mason Wright', 'masonw@example.com', 33, 'Male', 178.00, 82.00, 'Bodybuilding, Strength', 77.00, '1992-05-15'),
(21, 21, 'Harper King', 'harperk@example.com', 27, 'Female', 155.00, 50.00, 'Weight loss, Running', 48.00, '1998-10-21'),
(22, 22, 'Oliver Scott', 'oliversc@example.com', 29, 'Male', 179.00, 85.00, 'Endurance running, Improve stamina', 74.00, '1996-03-18'),
(23, 23, 'Zara Roberts', 'zarar@example.com', 25, 'Female', 163.00, 60.00, 'Core strength, Flexibility', 55.00, '2000-07-22'),
(24, 24, 'Nathan White', 'nathanw@example.com', 32, 'Male', 183.00, 88.00, 'Strength training, Muscle growth', 80.00, '1993-01-05'),
(25, 25, 'Isabelle Adams', 'isabellea@example.com', 26, 'Female', 167.00, 65.00, 'Tone body, Improve mobility', 60.00, '1999-04-20'),
(26, 26, 'Jacob Mitchell', 'jacobm@example.com', 30, 'Male', 182.00, 86.00, 'Muscle building, Cardio endurance', 78.00, '1995-02-10'),
(27, 27, 'Maya Turner', 'mayat@example.com', 29, 'Female', 165.00, 58.00, 'Flexibility, Improve posture', 52.00, '1996-11-17'),
(28, 28, 'Evan Cooper', 'evanc@example.com', 33, 'Male', 180.00, 84.00, 'Cardio training, Strength', 78.00, '1992-03-25'),
(29, 29, 'Victoria Scott', 'victorias@example.com', 30, 'Female', 168.00, 72.00, 'Toning body, Improve flexibility', 66.00, '1995-05-09'),
(30, 30, 'Aiden Miller', 'aidenm@example.com', 31, 'Male', 178.00, 88.00, 'Build muscle mass, Improve core strength', 82.00, '1994-02-03');

# Insert into SupportTicket
INSERT INTO SupportTicket (UserID, Issue, Status)
VALUES
(1, 'App crashes when loading workout plan', 'Open'),
(2, 'Unable to sync food log data', 'Closed'),
(3, 'Trainer feedback not updating in real-time', 'Closed'),
(4, 'Notifications for appointments not showing', 'Open'),
(5, 'Unable to view progress tracking graphs', 'Closed'),
(6, 'Unable to add new exercises to workout plan', 'Open'),
(7, 'Error while updating profile details', 'Closed'),
(8, 'App freezes when trying to view progress graphs', 'Open'),
(9, 'Food log not syncing with workout log', 'Closed'),
(10, 'Unable to delete past workout logs', 'Open'),
(11, 'Notifications for new workouts not received', 'Closed'),
(12, 'App crashes when changing the workout split', 'Open'),
(13, 'Unable to log heart rate data', 'Closed'),
(14, 'Profile picture not updating', 'Open'),
(15, 'User data not reflecting in the dashboard', 'Closed'),
(16, 'App crashes during exercise log submission', 'Open'),
(17, 'Calories burned not calculating correctly', 'Closed'),
(18, 'Unable to add new food items to the food log', 'Closed'),
(19, 'Graphical data not loading on the dashboard', 'Open'),
(20, 'Login issues, unable to authenticate', 'Closed'),
(21, 'Unable to reset password', 'Open'),
(22, 'Incorrect workout data displayed in progress tracking', 'Closed'),
(23, 'Workout plan is not syncing across devices', 'Open'),
(24, 'Unable to track mood data', 'Closed'),
(25, 'App not syncing with health tracking device', 'Open'),
(26, 'Crash when navigating to the "Add New Meal" page', 'Closed'),
(27, 'Food items in the log not showing correct calories', 'Open'),
(28, 'Unable to view exercise history', 'Closed'),
(29, 'Error while updating progress tracking data', 'Closed'),
(30, 'User unable to log sleep data', 'Open'),
(1, 'Difficulty syncing progress tracking with wearable device', 'Closed'),
(2, 'App crashes when switching between workout plans', 'Open'),
(3, 'Unable to log workout completion times', 'Closed'),
(4, 'Food log not displaying correct meal types', 'Closed'),
(5, 'Unable to track steps data', 'Open'),
(6, 'App fails to send reminders for upcoming workouts', 'Closed'),
(7, 'Unable to edit previous workouts', 'Open'),
(8, 'Graphical reports not generating on dashboard', 'Closed'),
(9, 'User unable to update trainer information', 'Open'),
(10, 'Progress tracker showing incorrect weight', 'Closed'),
(11, 'Unable to track calories consumed by meal type', 'Open'),
(12, 'App freezes when attempting to add new workout split', 'Closed'),
(13, 'Unable to view workout split summary', 'Open'),
(14, 'App showing incorrect workout intensity', 'Closed'),
(15, 'Food log not updating meal information correctly', 'Closed'),
(16, 'Unable to add new workout plan for the user', 'Open'),
(17, 'Unable to set workout goals for the current week', 'Closed'),
(18, 'User data not syncing with cloud backup', 'Open'),
(19, 'App crashes when trying to add sleep data', 'Closed'),
(20, 'Unable to track protein intake in food log', 'Open'),
(21, 'Unable to add new workout plan for the user', 'Open'),
(22, 'Food log not syncing correctly with workout plan', 'Closed'),
(23, 'Unable to view meal data on dashboard', 'Open'),
(24, 'Trainer feedback not syncing with user profile', 'Closed'),
(25, 'Calories burned not updating correctly', 'Closed'),
(26, 'App crashes when switching workout splits', 'Open'),
(27, 'Profile data not updating correctly on dashboard', 'Closed'),
(28, 'Workout data not syncing across all devices', 'Closed'),
(29, 'Food log meal info not syncing with progress data', 'Closed'),
(30, 'Unable to track water intake', 'Open');

# Insert into WorkoutPlan
INSERT INTO WorkoutPlan (PlanID, UserID, TrainerID, PlanName, Duration, Goal)
VALUES
(1, 1, 1, 'Muscle Gain', 12, 'Increase muscle mass and strength'),
(2, 2, 2, 'Fat Loss', 8, 'Lose 10kg in 2 months'),
(3, 3, 3, 'Endurance Running', 10, 'Train for marathon'),
(4, 4, 4, 'Body Toning', 6, 'Reduce body fat and improve strength'),
(5, 5, 5, 'Yoga Flexibility', 14, 'Improve flexibility and balance'),
(6, 6, 1, 'Cardio Blast', 8, 'Lose weight, improve cardiovascular health'),
(7, 7, 2, 'Strength & Power', 12, 'Build strength and muscle mass'),
(8, 8, 3, 'Muscle Endurance', 10, 'Increase muscle endurance and stamina'),
(9, 9, 4, 'Athletic Conditioning', 10, 'Improve agility and explosiveness'),
(10, 10, 5, 'Flexibility & Mobility', 12, 'Enhance joint health and flexibility'),
(11, 11, 1, 'Weight Loss & Strength', 6, 'Lose fat while building strength'),
(12, 12, 2, 'Full Body Strength', 8, 'Focus on overall body strength'),
(13, 13, 3, 'Marathon Training', 20, 'Prepare for a full marathon'),
(14, 14, 4, 'Speed & Agility', 10, 'Enhance speed and quickness'),
(15, 15, 5, 'Core Strength', 6, 'Build a stronger core for overall stability'),
(16, 16, 1, 'Functional Strength', 10, 'Increase functional fitness for daily activities'),
(17, 17, 2, 'Beginner Bodybuilding', 12, 'Start your bodybuilding journey'),
(18, 18, 3, 'Cardio Conditioning', 8, 'Build stamina and improve endurance'),
(19, 19, 4, 'Powerlifting', 12, 'Focus on maximizing your squat, bench press, and deadlift'),
(20, 20, 5, 'HIIT Training', 6, 'High-intensity interval training for fat burning'),
(21, 21, 1, 'Strength & Conditioning', 12, 'Enhance athletic performance and strength'),
(22, 22, 2, 'Bodybuilding Split', 12, 'Focus on individual muscle groups'),
(23, 23, 3, 'Run Strong', 8, 'Build endurance and speed for running'),
(24, 24, 4, 'Lean Muscle', 10, 'Build lean muscle while reducing body fat'),
(25, 25, 5, 'Bodyweight Training', 8, 'Train using just your body weight for full-body strength'),
(26, 26, 1, 'Power Endurance', 8, 'Enhance strength while increasing endurance'),
(27, 27, 2, 'Strength for Women', 12, 'Strength training focused on women’s fitness'),
(28, 28, 3, 'Track & Field Conditioning', 10, 'Prepare for track and field competitions'),
(29, 29, 4, 'Kettlebell Conditioning', 8, 'Use kettlebells to build strength and endurance'),
(30, 30, 5, 'Pilates & Yoga Fusion', 12, 'Blend Pilates and Yoga for strength and flexibility');

# Insert into Split
INSERT INTO Split (SplitID, SplitName, UserID)
VALUES
(1, 'Upper Body', 1),
(2, 'Lower Body', 2),
(3, 'Full Body', 3),
(4, 'Push/Pull', 4),
(5, 'Leg Day', 5),
(6, 'Chest & Triceps', 6),
(7, 'Back & Biceps', 7),
(8, 'Shoulders & Abs', 8),
(9, 'Core & Cardio', 9),
(10, 'Glutes & Hamstrings', 10),
(11, 'Full Body Strength', 11),
(12, 'Strength & Conditioning', 12),
(13, 'Abs & Obliques', 13),
(14, 'Cardio & Endurance', 14),
(15, 'Powerlifting Split', 15),
(16, 'Upper Body Push', 16),
(17, 'Upper Body Pull', 17),
(18, 'Lower Body Strength', 18),
(19, 'Bodyweight Workout', 19),
(20, 'CrossFit Style', 20),
(21, 'Bodybuilding Split', 21),
(22, 'Athletic Performance', 22),
(23, 'Plyometrics & Speed', 23),
(24, 'HIIT & Strength', 24),
(25, 'Total Body Burn', 25),
(26, 'Push/Pull/Legs', 26),
(27, 'Cardio & Abs', 27),
(28, 'Kettlebell Training', 28),
(29, 'Functional Training', 29),
(30, 'Mobility & Stretching', 30);


# Insert into WorkoutLog
INSERT INTO WorkoutLog (UserID, LogID, Date, ExerciseType, Duration, CaloriesBurned, TrainerNotes, setCount, repsInSet, WeightUsed)
VALUES
(1, 1, '2025-04-10', 'Squats', 60, 500, 'Form looks good', 4, 12, 100.00),
(1, 2, '2025-04-11', 'Leg Press', 50, 600, 'Focus on leg extension', 4, 10, 110.00),
(1, 3, '2025-04-12', 'Barbell Curl', 30, 250, 'Slow down the reps', 4, 12, 50.00),
(1, 4, '2025-04-13', 'Squats', 60, 550, 'Increase depth next time', 5, 10, 105.00),
(1, 5, '2025-04-14', 'Push-ups', 40, 400, 'Increase reps next time', 4, 15, NULL),
(1, 6, '2025-04-15', 'Mountain Climbers', 25, 300, 'Increase speed next time', NULL, NULL, NULL),
(2, 1, '2025-04-11', 'Push-ups', 30, 250, 'Increase reps next time', 3, 15, NULL),
(2, 2, '2025-04-16', 'Plank', 5, 150, 'Hold longer next time', NULL, NULL, NULL),
(2, 3, '2025-04-17', 'Burpees', 30, 320, 'Increase speed and power', NULL, NULL, NULL),
(2, 4, '2025-04-18', 'Tricep Dips', 35, 280, 'Control the descent', 4, 12, NULL),
(2, 5, '2025-04-19', 'Chest Press', 50, 450, 'Increase weight next time', 4, 10, 85.00),
(2, 6, '2025-05-01', 'Leg Press', 60, 600, 'Increase weight', 4, 12, 100.00),
(3, 1, '2025-04-12', 'Running', 45, 600, 'Focus on breathing', NULL, NULL, NULL),
(3, 2, '2025-04-17', 'Jumping Jacks', 20, 180, 'Increase speed next time', NULL, NULL, NULL),
(3, 3, '2025-04-22', 'Lunges', 45, 350, 'Focus on depth', 4, 10, 70.00),
(3, 4, '2025-04-27', 'Overhead Press', 40, 380, 'Work on stability', 4, 8, 60.00),
(3, 5, '2025-05-02', 'Treadmill Running', 60, 650, 'Increase pace', NULL, NULL, NULL),
(4, 1, '2025-04-13', 'Deadlifts', 75, 700, 'Lift heavier next week', 5, 10, 120.00),
(4, 2, '2025-04-18', 'Pull-ups', 30, 300, 'Focus on form', 3, 12, NULL),
(4, 3, '2025-04-23', 'Chest Flyes', 40, 300, 'Work on controlled motion', 4, 12, 45.00),
(4, 4, '2025-04-28', 'Deadlifts', 80, 750, 'Increase reps next time', 5, 10, 125.00),
(4, 5, '2025-05-03', 'Bicep Curls', 40, 350, 'Focus on form', 3, 10, 55.00),
(5, 1, '2025-04-14', 'Bench Press', 45, 400, 'Work on stability', 4, 8, 80.00),
(5, 2, '2025-04-19', 'Dumbbell Rows', 45, 400, 'Increase weight next time', 4, 10, 40.00),
(5, 3, '2025-04-24', 'Russian Twists', 20, 200, 'Increase range of motion', NULL, NULL, NULL),
(5, 4, '2025-04-29', 'Leg Curls', 45, 400, 'Focus on form', 4, 12, 50.00),
(5, 5, '2025-05-04', 'Jump Rope', 20, 250, 'Increase speed next time', NULL, NULL, NULL),
(5, 6, '2025-05-09', 'Dumbbell Shoulder Press', 45, 400, 'Focus on controlled motion', 4, 10, 55.00),
(6, 1, '2025-04-27', 'Pull-ups', 30, 280, 'Focus on proper form', 4, 10, NULL),
(6, 2, '2025-05-06', 'Chest Press', 50, 450, 'Increase weight next time', 4, 10, 85.00),
(7, 1, '2025-05-09', 'Squat Jumps', 20, 300, 'Focus on explosiveness', NULL, NULL, NULL),
(8, 1, '2025-05-12', 'Tricep Pushdowns', 30, 250, 'Increase weight', 4, 10, 40.00),
(9, 1, '2025-05-15', 'Leg Extensions', 40, 350, 'Slow the descent', 4, 12, 60.00),
(10, 1, '2025-05-18', 'Barbell Rows', 50, 450, 'Focus on form and control', 4, 10, 75.00),
(11, 1, '2025-05-20', 'Leg Press', 60, 600, 'Increase weight', 4, 12, 100.00),
(12, 1, '2025-05-22', 'Plank', 5, 150, 'Increase time', NULL, NULL, NULL),
(13, 1, '2025-05-25', 'Mountain Climbers', 30, 320, 'Focus on speed', NULL, NULL, NULL),
(14, 1, '2025-05-28', 'Barbell Rows', 50, 450, 'Focus on form and control', 4, 10, 75.00),
(15, 1, '2025-05-31', 'Dumbbell Lunges', 40, 350, 'Increase weight', 4, 12, 60.00),
(16, 1, '2025-06-03', 'Squats', 70, 650, 'Focus on depth', 5, 10, 110.00),
(17, 1, '2025-06-05', 'Box Jumps', 30, 300, 'Focus on explosiveness', NULL, NULL, NULL),
(18, 1, '2025-06-07', 'Deadlifts', 90, 800, 'Increase reps', 5, 8, 130.00),
(19, 1, '2025-06-10', 'Bicep Curls', 40, 360, 'Focus on form', 4, 10, 55.00),
(20, 1, '2025-06-12', 'Jump Rope', 25, 250, 'Increase speed', NULL, NULL, NULL),
(21, 1, '2025-06-15', 'Burpees', 30, 320, 'Increase speed and power', NULL, NULL, NULL),
(22, 1, '2025-06-18', 'Overhead Press', 40, 380, 'Work on stability', 4, 8, 60.00),
(23, 1, '2025-06-21', 'Deadlifts', 80, 750, 'Increase reps next time', 5, 10, 125.00),
(24, 1, '2025-06-23', 'Leg Curls', 45, 400, 'Focus on form', 4, 12, 50.00),
(25, 1, '2025-06-25', 'Mountain Climbers', 25, 300, 'Increase speed next time', NULL, NULL, NULL),
(26, 1, '2025-06-28', 'Burpees', 30, 320, 'Increase speed and power', NULL, NULL, NULL),
(27, 1, '2025-07-01', 'Overhead Press', 40, 380, 'Work on stability', 4, 8, 60.00),
(28, 1, '2025-07-03', 'Deadlifts', 80, 750, 'Increase reps next time', 5, 10, 125.00),
(29, 1, '2025-07-06', 'Leg Curls', 45, 400, 'Focus on form', 4, 12, 50.00),
(30, 1, '2025-07-09', 'Push-ups', 30, 270, 'Improve form and speed', 3, 20, NULL);

# Insert into Food
INSERT INTO Food (FoodID, FoodName, Calories)
VALUES
(1, 'Apple', 95),
(2, 'Banana', 105),
(3, 'Chicken Breast', 165),
(4, 'Rice', 200),
(5, 'Broccoli', 55),
(6, 'Eggs', 150),
(7, 'Almonds', 160),
(8, 'Avocado', 240),
(9, 'Salmon', 350),
(10, 'Oatmeal', 150),
(11, 'Orange', 62),
(12, 'Yogurt', 100),
(13, 'Spinach', 23),
(14, 'Carrots', 41),
(15, 'Sweet Potato', 112),
(16, 'Peanut Butter', 190),
(17, 'Almond Butter', 190),
(18, 'Cottage Cheese', 206),
(19, 'Quinoa', 120),
(20, 'Tuna', 200),
(21, 'Chicken Thigh', 210),
(22, 'Pineapple', 82),
(23, 'Mango', 99),
(24, 'Greek Yogurt', 130),
(25, 'Tomato', 22),
(26, 'Cucumber', 16),
(27, 'Hummus', 166),
(28, 'Beef Steak', 242),
(29, 'Turkey Breast', 135),
(30, 'Chia Seeds', 138);

# Insert into FoodLog
INSERT INTO FoodLog (UserID, LogID, Date, MealType, FoodID, Calories, Protein, Carbs, Fats)
VALUES
(1, 1, '2025-04-10', 'Breakfast', 1, 95, 0.5, 25, 0),
(1, 2, '2025-04-11', 'Lunch', 3, 165, 30, 0, 7),
(1, 3, '2025-04-12', 'Dinner', 4, 200, 4, 45, 0),
(1, 4, '2025-04-13', 'Snack', 2, 105, 1.3, 27, 0.3),
(1, 5, '2025-04-14', 'Dinner', 9, 350, 25, 5, 15),
(2, 1, '2025-04-15', 'Lunch', 6, 150, 12, 1, 10),
(2, 2, '2025-04-16', 'Snack', 7, 160, 6, 5, 14),
(2, 3, '2025-04-17', 'Dinner', 10, 100, 5, 20, 5),
(3, 1, '2025-04-18', 'Breakfast', 12, 80, 3, 19, 2),
(3, 2, '2025-04-19', 'Lunch', 13, 140, 6, 27, 1),
(3, 3, '2025-04-20', 'Snack', 14, 120, 4, 5, 8),
(4, 1, '2025-04-21', 'Dinner', 15, 90, 3, 18, 0),
(4, 2, '2025-04-22', 'Breakfast', 16, 110, 5, 15, 2),
(4, 3, '2025-04-23', 'Lunch', 17, 160, 10, 18, 7),
(5, 1, '2025-04-24', 'Snack', 18, 130, 5, 12, 5),
(5, 2, '2025-04-25', 'Dinner', 19, 180, 22, 15, 12),
(5, 3, '2025-04-26', 'Breakfast', 20, 200, 10, 5, 8),
(6, 1, '2025-04-27', 'Lunch', 21, 150, 12, 20, 10),
(7, 1, '2025-04-28', 'Snack', 22, 170, 7, 25, 4),
(8, 1, '2025-04-29', 'Dinner', 23, 190, 20, 10, 8),
(9, 1, '2025-04-30', 'Breakfast', 24, 180, 15, 25, 6),
(10, 1, '2025-05-01', 'Lunch', 25, 130, 10, 12, 3),
(11, 1, '2025-05-02', 'Dinner', 26, 140, 15, 10, 4),
(12, 1, '2025-05-03', 'Snack', 27, 150, 6, 12, 7),
(13, 1, '2025-05-04', 'Dinner', 28, 200, 8, 25, 3),
(14, 1, '2025-05-05', 'Lunch', 29, 180, 12, 30, 9),
(15, 1, '2025-05-06', 'Dinner', 30, 250, 20, 18, 11),
(16, 1, '2025-05-07', 'Snack', 3, 160, 7, 12, 6),
(17, 1, '2025-05-08', 'Lunch', 23, 220, 15, 28, 7),
(18, 1, '2025-05-09', 'Dinner', 3, 240, 18, 22, 9),
(19, 1, '2025-05-10', 'Snack', 4, 150, 8, 10, 4),
(20, 1, '2025-05-11', 'Dinner', 5, 270, 22, 12, 14),
(21, 1, '2025-05-12', 'Breakfast', 25, 220, 12, 25, 10),
(22, 1, '2025-05-13', 'Lunch', 1, 200, 18, 30, 8),
(23, 1, '2025-05-14', 'Dinner', 10, 230, 20, 22, 9),
(24, 1, '2025-05-15', 'Snack', 12, 160, 10, 15, 5),
(25, 1, '2025-05-16', 'Breakfast', 3, 190, 15, 20, 7),
(26, 1, '2025-05-17', 'Lunch', 27, 180, 18, 25, 9),
(27, 1, '2025-05-18', 'Snack', 19, 130, 5, 12, 3),
(28, 1, '2025-05-19', 'Dinner', 21, 250, 20, 18, 10),
(29, 1, '2025-05-20', 'Lunch', 27, 160, 8, 20, 5),
(30, 1, '2025-05-21', 'Dinner', 30, 270, 25, 15, 12),
(30, 2, '2025-05-22', 'Lunch', 20, 220, 15, 20, 6),
(1, 10, '2025-05-23', 'Snack', 7, 160, 6, 15, 6),
(2, 8, '2025-05-24', 'Dinner', 4, 230, 20, 18, 11),
(3, 7, '2025-05-25', 'Lunch', 10, 140, 8, 22, 5),
(4, 6, '2025-05-26', 'Snack', 3, 150, 10, 12, 6),
(5, 5, '2025-05-27', 'Breakfast', 21, 140, 7, 18, 4),
(1, 11, '2025-05-28', 'Lunch', 25, 210, 12, 28, 8),
(2, 9, '2025-05-29', 'Dinner', 30, 230, 15, 20, 7);

# Insert into SleepLog
INSERT INTO SleepLog (UserID, LogID, Date, SleepDuration, SleepQuality)
VALUES
(1, 1, '2025-04-10', 7.5, 8),
(1, 2, '2025-04-11', 7.0, 8),
(1, 3, '2025-04-12', 7.2, 7),
(1, 4, '2025-04-13', 7.3, 8),
(1, 5, '2025-04-14', 7.1, 9),
(2, 1, '2025-04-15', 6.0, 6),
(2, 2, '2025-04-16', 6.5, 7),
(2, 3, '2025-04-17', 6.8, 7),
(3, 1, '2025-04-18', 8.0, 9),
(3, 2, '2025-04-19', 8.2, 9),
(3, 3, '2025-04-20', 8.1, 9),
(4, 1, '2025-04-21', 7.0, 7),
(4, 2, '2025-04-22', 6.9, 7),
(4, 3, '2025-04-23', 7.2, 7),
(5, 1, '2025-04-24', 6.5, 5),
(5, 2, '2025-04-25', 6.7, 6),
(5, 3, '2025-04-26', 6.6, 5),
(6, 1, '2025-04-27', 7.0, 8),
(7, 1, '2025-04-28', 7.5, 7),
(7, 2, '2025-04-29', 7.3, 7),
(8, 1, '2025-04-30', 7.8, 8),
(9, 1, '2025-05-01', 7.6, 7),
(10, 1, '2025-05-02', 6.9, 6),
(10, 2, '2025-05-03', 7.0, 6),
(11, 1, '2025-05-04', 7.0, 8),
(12, 1, '2025-05-05', 6.8, 7),
(13, 1, '2025-05-06', 8.0, 9),
(13, 2, '2025-05-07', 7.9, 9),
(14, 1, '2025-05-08', 7.5, 8),
(15, 1, '2025-05-09', 7.0, 7),
(16, 1, '2025-05-10', 6.7, 7),
(17, 1, '2025-05-11', 7.3, 7),
(18, 1, '2025-05-12', 6.9, 7),
(19, 1, '2025-05-13', 7.2, 7),
(20, 1, '2025-05-14', 7.0, 6),
(21, 1, '2025-05-15', 7.5, 8),
(22, 1, '2025-05-16', 6.5, 7),
(23, 1, '2025-05-17', 7.2, 7),
(24, 1, '2025-05-18', 7.0, 7),
(25, 1, '2025-05-19', 6.8, 6),
(26, 1, '2025-05-20', 7.0, 8),
(27, 1, '2025-05-21', 7.4, 8),
(28, 1, '2025-05-22', 7.6, 8),
(29, 1, '2025-05-23', 7.5, 9),
(30, 1, '2025-05-24', 6.7, 7),
(30, 2, '2025-05-25', 7.0, 7),
(1, 6, '2025-05-26', 7.2, 8),
(2, 4, '2025-05-27', 6.8, 7),
(3, 4, '2025-05-28', 8.1, 9),
(4, 4, '2025-05-29', 7.3, 7),
(5, 4, '2025-05-30', 6.9, 6),
(1, 7, '2025-06-01', 7.3, 9),
(2, 5, '2025-06-02', 7.2, 7),
(3, 5, '2025-06-03', 8.0, 8),
(4, 5, '2025-06-04', 7.2, 7),
(5, 5, '2025-06-05', 6.8, 6);
# Insert into MoodLog
INSERT INTO MoodLog (UserID, LogID, Date, Mood)
VALUES
(1, 1, '2025-04-10', 'Happy'),
(1, 2, '2025-04-11', 'Excited'),
(1, 3, '2025-04-12', 'Motivated'),
(1, 4, '2025-04-13', 'Happy'),
(1, 5, '2025-04-14', 'Content'),
(1, 6, '2025-04-15', 'Energetic'),
(1, 7, '2025-04-16', 'Stressed'),
(1, 8, '2025-04-17', 'Tired'),
(1, 9, '2025-04-18', 'Relaxed'),
(1, 10, '2025-04-19', 'Frustrated'),
(2, 1, '2025-04-15', 'Stressed'),
(2, 2, '2025-04-16', 'Anxious'),
(2, 3, '2025-04-17', 'Relaxed'),
(2, 4, '2025-04-23', 'Excited'),
(3, 1, '2025-04-24', 'Content'),
(3, 2, '2025-04-25', 'Motivated'),
(3, 3, '2025-04-26', 'Happy'),
(3, 4, '2025-04-27', 'Energetic'),
(4, 1, '2025-04-28', 'Calm'),
(4, 2, '2025-04-29', 'Motivated'),
(5, 1, '2025-04-30', 'Tired'),
(5, 2, '2025-05-01', 'Energetic'),
(5, 3, '2025-05-02', 'Sleepy'),
(6, 1, '2025-05-03', 'Focused'),
(6, 2, '2025-05-04', 'Stressed'),
(6, 3, '2025-05-05', 'Motivated'),
(6, 4, '2025-05-06', 'Happy'),
(6, 5, '2025-05-07', 'Excited'),
(6, 6, '2025-05-08', 'Calm'),
(7, 1, '2025-05-09', 'Frustrated'),
(7, 2, '2025-05-10', 'Tired'),
(8, 1, '2025-05-11', 'Happy'),
(8, 2, '2025-05-12', 'Relaxed'),
(9, 1, '2025-05-13', 'Content'),
(9, 2, '2025-05-14', 'Excited'),
(10, 1, '2025-05-15', 'Motivated'),
(10, 2, '2025-05-16', 'Tired'),
(11, 1, '2025-05-17', 'Energetic'),
(12, 1, '2025-05-18', 'Stressed'),
(13, 1, '2025-05-19', 'Motivated'),
(14, 1, '2025-05-20', 'Tired'),
(14, 2, '2025-05-21', 'Energetic'),
(15, 1, '2025-05-22', 'Happy'),
(15, 2, '2025-05-23', 'Excited'),
(16, 1, '2025-05-24', 'Frustrated'),
(17, 1, '2025-05-25', 'Tired'),
(18, 1, '2025-05-26', 'Motivated'),
(19, 1, '2025-05-27', 'Content'),
(20, 1, '2025-05-28', 'Sleepy'),
(20, 2, '2025-05-29', 'Relaxed'),
(21, 1, '2025-05-30', 'Happy'),
(22, 1, '2025-06-01', 'Excited'),
(23, 1, '2025-06-02', 'Motivated'),
(24, 1, '2025-06-03', 'Frustrated'),
(25, 1, '2025-06-04', 'Calm'),
(26, 1, '2025-06-05', 'Tired'),
(27, 1, '2025-06-06', 'Energetic'),
(28, 1, '2025-06-07', 'Happy'),
(29, 1, '2025-06-08', 'Relaxed'),
(30, 1, '2025-06-09', 'Motivated'),
(30, 2, '2025-06-10', 'Content');

# Insert into ProgressTracking
INSERT INTO ProgressTracking (ProgressID, UserID, Date, Weight, BMI, BodyFatPercentage, TrainerComments)
VALUES
(1, 1, '2025-04-10', 80.50, 24.9, 18.0, 'Great improvement in strength'),
(2, 2, '2025-04-11', 70.00, 25.6, 20.5, 'Keep pushing for more cardio'),
(3, 3, '2025-04-12', 90.00, 28.5, 16.5, 'Focus more on endurance training'),
(4, 4, '2025-04-13', 65.00, 22.5, 19.0, 'Focus on muscle toning'),
(5, 5, '2025-04-14', 85.00, 27.1, 15.5, 'Great flexibility improvements'),
(6, 1, '2025-04-15', 81.00, 25.0, 17.5, 'Great improvement in squat form'),
(7, 2, '2025-04-16', 69.50, 25.3, 20.0, 'Continue to work on stamina'),
(8, 3, '2025-04-17', 91.00, 28.8, 16.0, 'Incorporate more strength training'),
(9, 4, '2025-04-18', 64.50, 22.0, 18.5, 'Increased muscle definition'),
(10, 5, '2025-04-19', 84.50, 27.0, 15.0, 'Focus on leg strength'),
(11, 1, '2025-04-20', 82.00, 25.2, 16.8, 'Improve upper body strength'),
(12, 2, '2025-04-21', 68.00, 24.9, 19.5, 'Increasing cardio intensity'),
(13, 3, '2025-04-22', 92.00, 29.0, 15.5, 'Keep improving your running time'),
(14, 4, '2025-04-23', 63.00, 21.8, 19.3, 'Body fat reduction continues'),
(15, 5, '2025-04-24', 83.00, 26.8, 14.5, 'Improved flexibility and mobility'),
(16, 1, '2025-04-25', 83.50, 25.5, 17.2, 'Form on deadlifts has improved significantly'),
(17, 2, '2025-04-26', 69.00, 25.1, 19.0, 'Work on pacing during cardio sessions'),
(18, 3, '2025-04-27', 93.00, 29.3, 15.0, 'Excellent progress in endurance activities'),
(19, 4, '2025-04-28', 62.50, 21.5, 18.0, 'Focus on building strength in legs and core'),
(20, 5, '2025-04-29', 82.00, 26.5, 14.0, 'Incorporating yoga for recovery'),
(21, 1, '2025-04-30', 84.00, 26.0, 16.0, 'Increase weight on squats to build muscle'),
(22, 2, '2025-05-01', 68.50, 25.2, 18.5, 'Increase intensity during workouts'),
(23, 3, '2025-05-02', 94.00, 29.5, 14.8, 'Keep improving endurance and stamina'),
(24, 4, '2025-05-03', 61.00, 21.2, 18.7, 'Strength and stability are improving'),
(25, 5, '2025-05-04', 81.50, 26.0, 13.5, 'Focus on overall body conditioning'),
(26, 1, '2025-05-05', 85.00, 26.2, 15.3, 'Excellent strength gains, focus on balance'),
(27, 2, '2025-05-06', 67.00, 24.8, 18.2, 'Keep up the cardio intensity'),
(28, 3, '2025-05-07', 95.00, 29.7, 14.5, 'Endurance has improved significantly'),
(29, 4, '2025-05-08', 60.00, 20.9, 19.2, 'Focus on building more muscle mass'),
(30, 5, '2025-05-09', 80.00, 25.8, 13.0, 'Incorporating flexibility work into routine'),
(31, 1, '2025-05-10', 85.50, 26.3, 16.2, 'Focus on deadlift form and increase weight'),
(32, 2, '2025-05-11', 67.50, 24.9, 17.8, 'Cardio sessions are looking stronger'),
(33, 3, '2025-05-12', 96.00, 30.0, 14.2, 'Running distance is improving'),
(34, 4, '2025-05-13', 59.50, 20.8, 18.8, 'Muscle toning is coming along well'),
(35, 5, '2025-05-14', 79.50, 25.5, 12.8, 'Progressing well with strength training'),
(36, 1, '2025-05-15', 86.00, 26.4, 15.1, 'Focus on flexibility and recovery'),
(37, 2, '2025-05-16', 68.00, 25.0, 18.3, 'Consistency in cardio workouts is key'),
(38, 3, '2025-05-17', 97.00, 30.2, 14.0, 'Improving overall stamina'),
(39, 4, '2025-05-18', 58.50, 20.5, 19.0, 'Build more strength in core and legs'),
(40, 5, '2025-05-19', 78.00, 25.3, 12.5, 'Focus on toning arms and shoulders'),
(41, 1, '2025-05-20', 87.00, 26.5, 15.5, 'Form on squats improving significantly'),
(42, 2, '2025-05-21', 69.00, 25.1, 18.6, 'Cardio intensity is looking good'),
(43, 3, '2025-05-22', 98.00, 30.3, 13.8, 'Focus on pacing during longer runs'),
(44, 4, '2025-05-23', 57.50, 20.3, 19.1, 'Leg and core strength improving steadily'),
(45, 5, '2025-05-24', 77.50, 25.2, 12.2, 'Great flexibility and recovery progress'),
(46, 1, '2025-05-25', 88.00, 26.6, 15.6, 'Increase focus on overall strength and stability'),
(47, 2, '2025-05-26', 70.00, 25.3, 18.7, 'Increase cardio duration slightly'),
(48, 3, '2025-05-27', 99.00, 30.4, 13.6, 'Endurance and pacing are much better'),
(49, 4, '2025-05-28', 56.00, 19.8, 19.2, 'Core and legs need more attention'),
(50, 5, '2025-05-29', 76.00, 25.0, 12.0, 'Muscle definition is improving in upper body');

# Insert into Appointment
INSERT INTO Appointment (AppointmentID, UserID, ClientID, Date, Notes)
VALUES
(1, 1, 2, '2025-04-15', 'Discuss training schedule'),
(2, 2, 3, '2025-04-16', 'Review progress on nutrition'),
(3, 3, 4, '2025-04-17', 'Update workout plan'),
(4, 4, 5, '2025-04-18', 'Yoga session feedback'),
(5, 5, 1, '2025-04-19', 'Discuss weight loss progress'),
(6, 1, 3, '2025-04-20', 'Focus on improving strength and endurance'),
(7, 2, 4, '2025-04-21', 'Review cardio progress and goals'),
(8, 3, 5, '2025-04-22', 'Adjust workout routine for muscle building'),
(9, 4, 1, '2025-04-23', 'Yoga poses and flexibility improvement'),
(10, 5, 2, '2025-04-24', 'Discuss flexibility goals and stretch routines'),
(11, 1, 4, '2025-04-25', 'Assess running form and technique'),
(12, 2, 1, '2025-04-26', 'Focus on upper body strength and toning'),
(13, 3, 2, '2025-04-27', 'Nutritional plan review and adjustments'),
(14, 4, 3, '2025-04-28', 'Improve posture and leg strength'),
(15, 5, 4, '2025-04-29', 'Yoga session for balance and stability'),
(16, 1, 5, '2025-04-30', 'Strength training evaluation'),
(17, 2, 1, '2025-05-01', 'Check on cardio improvements and results'),
(18, 3, 4, '2025-05-02', 'Workout routine adjustments for weight loss'),
(19, 4, 2, '2025-05-03', 'Flexibility and mobility training review'),
(20, 5, 3, '2025-05-04', 'Review protein intake and muscle recovery'),
(21, 1, 2, '2025-05-05', 'Reassess upper body strength gains'),
(22, 2, 3, '2025-05-06', 'Nutritional goals and adjustments for energy'),
(23, 3, 5, '2025-05-07', 'Focus on improving cardio endurance'),
(24, 4, 1, '2025-05-08', 'Work on lower body strength and squat depth'),
(25, 5, 4, '2025-05-09', 'Yoga breathing exercises and relaxation'),
(26, 1, 3, '2025-05-10', 'Full-body strength and conditioning check'),
(27, 2, 5, '2025-05-11', 'Review core strengthening exercises'),
(28, 3, 1, '2025-05-12', 'Discuss running goals and speed improvement'),
(29, 4, 2, '2025-05-13', 'Body toning session and progress update'),
(30, 5, 3, '2025-05-14', 'Assess weight loss and body composition'),
(31, 1, 2, '2025-05-15', 'Focus on improving leg strength and squats'),
(32, 2, 4, '2025-05-16', 'Check on overall flexibility improvement'),
(33, 3, 1, '2025-05-17', 'Running form feedback and breathing tips'),
(34, 4, 5, '2025-05-18', 'Review flexibility and stretching progress'),
(35, 5, 2, '2025-05-19', 'Lower body strength training adjustments'),
(36, 1, 3, '2025-05-20', 'Assess endurance progress and stamina'),
(37, 2, 1, '2025-05-21', 'Core strengthening session and feedback'),
(38, 3, 5, '2025-05-22', 'Nutrition plan check and improvements'),
(39, 4, 2, '2025-05-23', 'Cardio goals and results review'),
(40, 5, 3, '2025-05-24', 'Evaluate progress on weight loss and toning'),
(41, 1, 4, '2025-05-25', 'Yoga session for relaxation and flexibility'),
(42, 2, 3, '2025-05-26', 'Upper body strength and muscle gain review'),
(43, 3, 1, '2025-05-27', 'Review running form and technique'),
(44, 4, 5, '2025-05-28', 'Body toning and strength assessment'),
(45, 5, 2, '2025-05-29', 'Reassess flexibility goals and routines'),
(46, 1, 5, '2025-05-30', 'Lower body toning and leg strength'),
(47, 2, 1, '2025-06-01', 'Core strengthening and abdominal exercises'),
(48, 3, 2, '2025-06-02', 'Cardio fitness assessment and improvements'),
(49, 4, 4, '2025-06-03', 'Flexibility session and stretching exercises'),
(50, 5, 3, '2025-06-04', 'Evaluate weight loss progress and muscle tone');
# Insert into HeartRateLog
INSERT INTO HeartRateLog (UserID, LogID, Date, AvgHeartRate)
VALUES
(1, 1, '2025-04-10', 75),
(1, 2, '2025-04-11', 80),
(1, 3, '2025-04-12', 76),
(1, 4, '2025-04-13', 78),
(2, 1, '2025-04-14', 70),
(2, 2, '2025-04-15', 72),
(2, 3, '2025-04-16', 75),
(3, 1, '2025-04-17', 72),
(3, 2, '2025-04-18', 74),
(3, 3, '2025-04-19', 73),
(4, 1, '2025-04-20', 77),
(4, 2, '2025-04-21', 80),
(5, 1, '2025-04-22', 78),
(5, 2, '2025-04-23', 81),
(6, 1, '2025-04-24', 74),
(6, 2, '2025-04-25', 72),
(7, 1, '2025-04-26', 79),
(8, 1, '2025-04-27', 76),
(9, 1, '2025-04-28', 73),
(10, 1, '2025-04-29', 80),
(10, 2, '2025-04-30', 78),
(11, 1, '2025-05-01', 82),
(11, 2, '2025-05-02', 84),
(12, 1, '2025-05-03', 75),
(13, 1, '2025-05-04', 77),
(13, 2, '2025-05-05', 79),
(14, 1, '2025-05-06', 81),
(14, 2, '2025-05-07', 75),
(15, 1, '2025-05-08', 74),
(16, 1, '2025-05-09', 70),
(17, 1, '2025-05-10', 73),
(18, 1, '2025-05-11', 72),
(19, 1, '2025-05-12', 78),
(19, 2, '2025-05-13', 80),
(20, 1, '2025-05-14', 79),
(21, 1, '2025-05-15', 75),
(22, 1, '2025-05-16', 74),
(23, 1, '2025-05-17', 73),
(24, 1, '2025-05-18', 77),
(25, 1, '2025-05-19', 78),
(26, 1, '2025-05-20', 82),
(27, 1, '2025-05-21', 75),
(28, 1, '2025-05-22', 79),
(29, 1, '2025-05-23', 74),
(30, 1, '2025-05-24', 80);
# Insert into VisualizationData
INSERT INTO VisualizationData (VizID, UserID, MoodLogUserID, MoodLogID, HeartRateUserID, HeartRateID, SleepLogUserID, SleepLogID, WorkoutLogUserID, WorkoutLogID, FoodLogUserID, FoodLogID, Date, DataType, Value)
VALUES
(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-04-10', 'Calories', 500.00),
(2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-04-11', 'Mood', 6.00),
(3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-04-12', 'HeartRate', 72.00),
(4, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-04-13', 'Sleep', 7.00),
(5, 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-04-14', 'Workouts', 60.00),
(6, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-04-15', 'Calories', 600.00),
(7, 7, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-04-16', 'Mood', 5.50),
(8, 8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-04-17', 'HeartRate', 75.00),
(9, 9, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-04-18', 'Sleep', 6.50),
(10, 10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-04-19', 'Workouts', 50.00),
(11, 11, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-04-20', 'Calories', 550.00),
(12, 12, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-04-21', 'Mood', 7.00),
(13, 13, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-04-22', 'HeartRate', 73.00),
(14, 14, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-04-23', 'Sleep', 7.20),
(15, 15, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-04-24', 'Workouts', 65.00),
(16, 16, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-04-25', 'Calories', 620.00),
(17, 17, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-04-26', 'Mood', 6.50),
(18, 18, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-04-27', 'HeartRate', 74.00),
(19, 19, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-04-28', 'Sleep', 6.80),
(20, 20, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-04-29', 'Workouts', 55.00),
(21, 21, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-04-30', 'Calories', 530.00),
(22, 22, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-01', 'Mood', 7.20),
(23, 23, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-02', 'HeartRate', 76.00),
(24, 24, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-03', 'Sleep', 7.10),
(25, 25, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-04', 'Workouts', 58.00),
(26, 26, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-05', 'Calories', 560.00),
(27, 27, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-06', 'Mood', 7.10),
(28, 28, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-07', 'HeartRate', 78.00),
(29, 29, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-08', 'Sleep', 7.30),
(30, 30, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-09', 'Workouts', 60.00),
(31, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-10', 'Calories', 580.00),
(32, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-11', 'Mood', 7.30),
(33, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-12', 'HeartRate', 79.00),
(34, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-13', 'Sleep', 7.40),
(35, 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-14', 'Workouts', 62.00),
(36, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-15', 'Calories', 590.00),
(37, 7, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-16', 'Mood', 7.40),
(38, 8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-17', 'HeartRate', 80.00),
(39, 9, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-18', 'Sleep', 7.50),
(40, 10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-19', 'Workouts', 64.00),
(41, 11, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-20', 'Calories', 600.00),
(42, 12, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-21', 'Mood', 7.50),
(43, 13, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-22', 'HeartRate', 81.00),
(44, 14, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-23', 'Sleep', 7.60),
(45, 15, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-24', 'Workouts', 66.00),
(46, 16, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-25', 'Calories', 610.00),
(47, 17, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-26', 'Mood', 7.60),
(48, 18, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-27', 'HeartRate', 82.00),
(49, 19, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-28', 'Sleep', 7.80),
(50, 20, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2025-05-29', 'Workouts', 68.00);
# Insert into AIInsights
INSERT INTO AIInsights (UserID, TrainerID, Date, PredictedWeight, PredictedMood, PredictedCalories)
VALUES
(1, 1, '2025-04-10', 75.00, 'Happy', 2500),
(2, 2, '2025-04-11', 70.00, 'Stressed', 2400),
(3, 3, '2025-04-12', 85.00, 'Content', 2200),
(4, 4, '2025-04-13', 65.00, 'Motivated', 2300),
(5, 5, '2025-04-14', 80.00, 'Tired', 2100),
(6, 6, '2025-04-15', 77.00, 'Excited', 2550),
(7, 7, '2025-04-16', 72.00, 'Anxious', 2450),
(8, 8, '2025-04-17', 82.00, 'Relaxed', 2350),
(9, 9, '2025-04-18', 68.00, 'Focused', 2250),
(10, 10, '2025-04-19', 78.00, 'Happy', 2500),
(11, 11, '2025-04-20', 74.00, 'Tired', 2400),
(12, 12, '2025-04-21', 71.00, 'Motivated', 2300),
(13, 13, '2025-04-22', 79.00, 'Calm', 2200),
(14, 14, '2025-04-23', 76.00, 'Content', 2400),
(15, 15, '2025-04-24', 69.00, 'Energetic', 2500),
(16, 16, '2025-04-25', 74.00, 'Focused', 2350),
(17, 17, '2025-04-26', 80.00, 'Excited', 2600),
(18, 18, '2025-04-27', 70.00, 'Stressed', 2450),
(19, 19, '2025-04-28', 83.00, 'Motivated', 2550),
(20, 20, '2025-04-29', 68.00, 'Tired', 2400),
(21, 21, '2025-04-30', 81.00, 'Happy', 2500),
(22, 22, '2025-05-01', 75.00, 'Relaxed', 2300),
(23, 23, '2025-05-02', 72.00, 'Anxious', 2200),
(24, 24, '2025-05-03', 76.00, 'Energetic', 2500),
(25, 25, '2025-05-04', 79.00, 'Excited', 2550),
(26, 26, '2025-05-05', 74.00, 'Focused', 2400),
(27, 27, '2025-05-06', 80.00, 'Tired', 2300),
(28, 28, '2025-05-07', 78.00, 'Motivated', 2450),
(29, 29, '2025-05-08', 82.00, 'Happy', 2500),
(30, 30, '2025-05-09', 71.00, 'Calm', 2250),
(1, 1, '2025-05-10', 77.00, 'Excited', 2550),
(2, 2, '2025-05-11', 73.00, 'Anxious', 2450),
(3, 3, '2025-05-12', 80.00, 'Relaxed', 2400),
(4, 4, '2025-05-13', 75.00, 'Motivated', 2350),
(5, 5, '2025-05-14', 82.00, 'Energetic', 2500),
(6, 6, '2025-05-15', 76.00, 'Focused', 2450),
(7, 7, '2025-05-16', 70.00, 'Tired', 2300),
(8, 8, '2025-05-17', 83.00, 'Excited', 2600),
(9, 9, '2025-05-18', 79.00, 'Happy', 2450),
(10, 10, '2025-05-19', 77.00, 'Relaxed', 2350),
(11, 11, '2025-05-20', 75.00, 'Focused', 2400),
(12, 12, '2025-05-21', 72.00, 'Energetic', 2500),
(13, 13, '2025-05-22', 80.00, 'Stressed', 2300),
(14, 14, '2025-05-23', 78.00, 'Excited', 2600),
(15, 15, '2025-05-24', 81.00, 'Motivated', 2450),
(16, 16, '2025-05-25', 76.00, 'Happy', 2350),
(17, 17, '2025-05-26', 74.00, 'Energetic', 2500),
(18, 18, '2025-05-27', 79.00, 'Focused', 2400),
(19, 19, '2025-05-28', 82.00, 'Tired', 2300),
(20, 20, '2025-05-29', 80.00, 'Excited', 2600);

# Insert into DailySchedule
INSERT INTO DailySchedule (SplitID, Date)
VALUES
(1, '2025-04-10'),
(2, '2025-04-11'),
(3, '2025-04-12'),
(4, '2025-04-13'),
(5, '2025-04-14'),
(1, '2025-04-15'),
(2, '2025-04-16'),
(3, '2025-04-17'),
(4, '2025-04-18'),
(5, '2025-04-19'),
(1, '2025-04-20'),
(2, '2025-04-21'),
(3, '2025-04-22'),
(4, '2025-04-23'),
(5, '2025-04-24'),
(1, '2025-04-25'),
(2, '2025-04-26'),
(3, '2025-04-27'),
(4, '2025-04-28'),
(5, '2025-04-29'),
(1, '2025-04-30'),
(2, '2025-05-01'),
(3, '2025-05-02'),
(4, '2025-05-03'),
(5, '2025-05-04'),
(1, '2025-05-05'),
(2, '2025-05-06'),
(3, '2025-05-07'),
(4, '2025-05-08'),
(5, '2025-05-09'),
(1, '2025-05-10'),
(2, '2025-05-11'),
(3, '2025-05-12'),
(4, '2025-05-13'),
(5, '2025-05-14'),
(1, '2025-05-15'),
(2, '2025-05-16'),
(3, '2025-05-17'),
(4, '2025-05-18'),
(5, '2025-05-19'),
(1, '2025-05-20'),
(2, '2025-05-21'),
(3, '2025-05-22'),
(4, '2025-05-23'),
(5, '2025-05-24'),
(1, '2025-05-25'),
(2, '2025-05-26'),
(3, '2025-05-27'),
(4, '2025-05-28'),
(5, '2025-05-29');
# Insert into TicketEmployee
INSERT INTO TicketEmployee (TicketID, EmployeeID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 1),
(12, 2),
(13, 3),
(14, 4),
(15, 5),
(16, 6),
(17, 7),
(18, 8),
(19, 9),
(20, 10),
(21, 1),
(22, 2),
(23, 3),
(24, 4),
(25, 5),
(26, 6),
(27, 7),
(28, 8),
(29, 9),
(30, 10);
# Insert into Exercise
INSERT INTO Exercise (ExerciseID, Name, Description, MuscleGroup, EquipmentRequired, PersonalRecord, SplitID)
VALUES
(1, 'Bench Press', 'Chest press using a barbell', 'Chest', 'Barbell', 100.0, 1),
(2, 'Squat', 'Full body exercise focusing on legs', 'Legs', 'Barbell', 120.0, 2),
(3, 'Deadlift', 'Lift barbell from the ground to the hips', 'Back', 'Barbell', 150.0, 3),
(4, 'Overhead Press', 'Press a barbell overhead', 'Shoulders', 'Barbell', 80.0, 1),
(5, 'Pull-ups', 'Lift body weight using pull-up bar', 'Back', 'Pull-up Bar', 15.0, 2),
(6, 'Leg Press', 'Push weights with legs on a machine', 'Legs', 'Machine', 200.0, 3),
(7, 'Bicep Curl', 'Curl barbell towards chest', 'Arms', 'Barbell', 40.0, 1),
(8, 'Tricep Dips', 'Lower and raise body on a dip bar', 'Arms', 'Dip Bar', 40.0, 2),
(9, 'Lunges', 'Step forward into a lunge position', 'Legs', 'None', 50.0, 3),
(10, 'Chest Fly', 'Chest exercise with dumbbells on a bench', 'Chest', 'Dumbbells', 30.0, 1),
(11, 'Barbell Row', 'Pull barbell to your waist', 'Back', 'Barbell', 100.0, 2),
(12, 'Kettlebell Swing', 'Swing kettlebell from legs to chest', 'Full Body', 'Kettlebell', 40.0, 3),
(13, 'Romanian Deadlift', 'Deadlift with slightly bent knees focusing on hamstrings', 'Legs', 'Barbell', 100.0, 1),
(14, 'Shoulder Press', 'Press dumbbells overhead', 'Shoulders', 'Dumbbells', 45.0, 2),
(15, 'Lat Pulldown', 'Pull weight towards chest from above', 'Back', 'Machine', 120.0, 3),
(16, 'Hack Squat', 'Squat on a machine', 'Legs', 'Machine', 180.0, 1),
(17, 'Incline Dumbbell Press', 'Chest press with dumbbells on an incline bench', 'Chest', 'Dumbbells', 45.0, 2),
(18, 'Face Pulls', 'Pull rope towards face on cable machine', 'Shoulders', 'Cable Machine', 60.0, 3),
(19, 'Tricep Pushdowns', 'Push down cable towards body using tricep rope attachment', 'Arms', 'Cable Machine', 50.0, 1),
(20, 'Seated Row', 'Pull weight towards torso using cable machine', 'Back', 'Cable Machine', 100.0, 2),
(21, 'Calf Raises', 'Raise heels on machine or with weights', 'Legs', 'Machine', 150.0, 3),
(22, 'Ab Crunches', 'Crunch abdomen while lying on floor or machine', 'Core', 'Machine', 50.0, 1),
(23, 'Front Squat', 'Squat with barbell on front of shoulders', 'Legs', 'Barbell', 110.0, 2),
(24, 'Barbell Shrugs', 'Shrug shoulders while holding barbell', 'Traps', 'Barbell', 100.0, 3),
(25, 'Dumbbell Rows', 'Pull dumbbell to your waist', 'Back', 'Dumbbells', 45.0, 1),
(26, 'Lateral Raises', 'Raise dumbbells outward from sides', 'Shoulders', 'Dumbbells', 25.0, 2),
(27, 'Hammer Curl', 'Curl dumbbells with palms facing each other', 'Arms', 'Dumbbells', 40.0, 3),
(28, 'Leg Extensions', 'Extend legs with machine', 'Legs', 'Machine', 120.0, 1),
(29, 'Chest Press Machine', 'Push weight forward on machine targeting chest', 'Chest', 'Machine', 140.0, 2),
(30, 'Incline Dumbbell Curl', 'Curl dumbbells on incline bench', 'Arms', 'Dumbbells', 35.0, 3),
(31, 'Jump Squats', 'Squat with an explosive jump up', 'Legs', 'None', 0.0, 1),
(32, 'Cable Chest Fly', 'Chest fly exercise with cables', 'Chest', 'Cable Machine', 50.0, 2),
(33, 'Dumbbell Lunges', 'Step forward with dumbbells', 'Legs', 'Dumbbells', 40.0, 3),
(34, 'Push-ups', 'Bodyweight exercise to target chest', 'Chest', 'None', 0.0, 1),
(35, 'Sled Push', 'Push sled across gym floor', 'Legs', 'Sled', 200.0, 2),
(36, 'Medicine Ball Slams', 'Throw a medicine ball on the ground with force', 'Full Body', 'Medicine Ball', 20.0, 3),
(37, 'Single-Leg Deadlift', 'Deadlift on one leg focusing on hamstrings', 'Legs', 'Dumbbells', 50.0, 1),
(38, 'T-Bar Row', 'Pull weight from chest on T-Bar machine', 'Back', 'T-Bar Machine', 120.0, 2),
(39, 'Cable Kickbacks', 'Kick cable backward to target glutes', 'Legs', 'Cable Machine', 40.0, 3),
(40, 'Leg Curl Machine', 'Curl legs in machine focusing on hamstrings', 'Legs', 'Machine', 100.0, 1),
(41, 'Cable Tricep Pushdown', 'Push weight down using tricep rope', 'Arms', 'Cable Machine', 50.0, 2),
(42, 'Bicycle Crunches', 'Crunch while alternating legs in bicycle motion', 'Core', 'None', 0.0, 3),
(43, 'Dumbbell Chest Press', 'Press dumbbells up from chest', 'Chest', 'Dumbbells', 45.0, 1),
(44, 'Glute Bridges', 'Push hips upward while lying on back', 'Glutes', 'None', 0.0, 2),
(45, 'Roman Chair Leg Raise', 'Leg raises while supported on Roman chair', 'Core', 'Roman Chair', 30.0, 3),
(46, 'Sumo Deadlift', 'Wide stance deadlift focusing on inner thighs', 'Legs', 'Barbell', 140.0, 1),
(47, 'Cable Rows', 'Pull weight towards torso with cable machine', 'Back', 'Cable Machine', 100.0, 2),
(48, 'Jumping Lunges', 'Explosive lunge jumps', 'Legs', 'None', 0.0, 3),
(49, 'Barbell Thrusters', 'Squat and press barbell overhead in one movement', 'Full Body', 'Barbell', 80.0, 1),
(50, 'Kettlebell Snatch', 'Snatch kettlebell overhead with one hand', 'Full Body', 'Kettlebell', 40.0, 2);

# Insert into ClientExercise
INSERT INTO ClientExercise (UserID, ExerciseID)
VALUES
(1, 5),
(2, 10),
(3, 15),
(4, 20),
(5, 25),
(6, 30),
(7, 35),
(8, 40),
(9, 45),
(10, 50),
(11, 1),
(12, 2),
(13, 3),
(14, 4),
(15, 6),
(16, 7),
(17, 8),
(18, 9),
(19, 11),
(20, 12),
(21, 13),
(22, 14),
(23, 16),
(24, 17),
(25, 18),
(26, 19),
(27, 21),
(28, 22),
(29, 23),
(30, 24),
(1, 26),
(2, 27),
(3, 28),
(4, 29),
(5, 31),
(6, 32),
(7, 33),
(8, 34),
(9, 36),
(10, 37),
(11, 38),
(12, 39),
(13, 41),
(14, 42),
(15, 43),
(16, 44),
(17, 46),
(18, 47),
(19, 48),
(20, 49),
(21, 50),
(22, 5),
(23, 10),
(24, 15),
(25, 20),
(26, 25),
(27, 30),
(28, 35),
(29, 40),
(30, 45);
# Insert into WorkoutPlanExercise
INSERT INTO WorkoutPlanExercise (PlanID, ExerciseID)
VALUES
(1, 5),
(2, 18),
(3, 29),
(4, 12),
(5, 25),
(6, 15),
(7, 8),
(8, 21),
(9, 13),
(10, 30),
(11, 9),
(12, 16),
(13, 3),
(14, 4),
(15, 19),
(16, 10),
(17, 23),
(18, 14),
(19, 20),
(20, 22),
(21, 11),
(22, 6),
(23, 24),
(24, 7),
(25, 17),
(26, 1),
(27, 2),
(28, 28),
(29, 5),
(30, 13),
(1, 23),
(2, 8),
(3, 19),
(4, 25),
(5, 3),
(6, 12),
(7, 16),
(8, 7),
(9, 14),
(10, 20),
(11, 5),
(12, 22),
(13, 4),
(14, 18),
(15, 9),
(16, 27),
(17, 6),
(18, 24),
(19, 15),
(20, 1),
(21, 10),
(22, 28),
(23, 13),
(24, 17),
(25, 30);

# User Story Queries

# 1.1
SELECT Date, ExerciseType, WeightUsed, setCount, repsInSet
FROM WorkoutLog
WHERE UserID = 100
ORDER BY Date ASC;
# 1.2
SELECT Date, SUM(Calories) AS TotalCalories
FROM FoodLog
WHERE UserID = 100
GROUP BY Date
ORDER BY Date DESC;
# 1.3
SELECT ExerciseType, MAX(WeightUsed) AS PersonalRecord
FROM WorkoutLog
WHERE UserID = 100
GROUP BY ExerciseType;

# 1.4
SELECT Date, WeightUsed
FROM WorkoutLog
WHERE UserID = 100 AND ExerciseType = 'Bench Press'
ORDER BY Date ASC;
# 1.5
INSERT INTO Split (SplitName, UserID)
VALUES ('Push Day', 1);
# 1.6
SELECT ROUND(225 / (1 + 8 / 30.0), 2) AS TargetWeightFor8Reps;

# 2.1
SELECT w.Date, w.WeightUsed, w.setCount, w.repsInSet
FROM WorkoutLog w
JOIN User u ON u.UserID = w.UserID
WHERE u.Name = 'Robert' AND w.ExerciseType = 'Bench Press'
ORDER BY w.Date ASC;

# 2.1
SELECT
    m.Date,
    m.Mood,
    f.Calories AS FoodCalories,
    s.SleepDuration,
    w.Duration AS ExerciseDuration
FROM MoodLog m
LEFT JOIN FoodLog f ON m.UserID = f.UserID AND m.Date = f.Date
LEFT JOIN SleepLog s ON m.UserID = s.UserID AND m.Date = s.Date
LEFT JOIN WorkoutLog w ON m.UserID = w.UserID AND m.Date = w.Date
WHERE m.UserID = 100 -- Replace with specific ClientID
ORDER BY m.Date;

#2.2
INSERT INTO AIInsights (UserID, Date, PredictedWeight, PredictedMood, PredictedCalories)
VALUES (1, CURDATE(), 174, 'happy', 3200);

#2.3
SELECT
    m.Mood,
    AVG(f.Calories) AS AvgCalories,
    AVG(s.SleepDuration) AS AvgSleep,
    AVG(w.Duration) AS AvgWorkoutDuration
FROM MoodLog m
LEFT JOIN FoodLog f ON m.UserID = f.UserID AND m.Date = f.Date
LEFT JOIN SleepLog s ON m.UserID = s.UserID AND m.Date = s.Date
LEFT JOIN WorkoutLog w ON m.UserID = w.UserID AND m.Date = w.Date
WHERE m.UserID = 100 -- #Replace with clientID
GROUP BY m.Mood;

#2.4
UPDATE WorkoutPlanExercise
SET ExerciseID = 11 -- New exercise targeting underworked muscle group
WHERE PlanID = 200 AND ExerciseID = 10; -- Replace with underworked muscle

#2.5
INSERT INTO WorkoutPlan (PlanID, UserID, TrainerID, PlanName, Duration, Goal)
VALUES (200, 1, 1, 'AI-Generated Plan', 4, 'Muscle Growth');

#2.6
SELECT wl.Date, AVG(hr.AvgHeartRate) AS AvgHeartRate
FROM WorkoutLog wl
JOIN HeartRateLog hr ON wl.UserID = hr.UserID AND wl.Date = DATE(hr.Date)
WHERE wl.UserID = 100
GROUP BY wl.Date
ORDER BY wl.Date DESC;

#3.1
SELECT m.Date,
       m.Mood,
       s.SleepDuration
FROM MoodLog m
JOIN SleepLog s ON m.UserID = s.UserID AND m.Date = s.Date
WHERE m.UserID = 3;

#3.2
SELECT Food.FoodName,
       f.Calories,
       f.Date
FROM FoodLog f
JOIN Food ON f.FoodID = Food.FoodID
WHERE f.UserID = 3
;

#3.3
SELECT wl.CaloriesBurned,
       wl.Date,
       wl.Duration
FROM WorkoutLog wl
WHERE wl.UserID = 3;

#3.4
INSERT INTO WorkoutLog VALUES(25, -- log id
                              1, -- client id
                              '2025-01-31', -- date
                              200, -- exercise type
                              15, -- duration
                              20, -- cals burned
                              NULL,-- trainer notes
                              2,
                              2,
                              0);

#3.5
SELECT wl.Duration,
       wl.Date,
       wl.ExerciseType
FROM WorkoutLog wl
WHERE wl.Duration = 15;

#3.6
INSERT INTO SleepLog VALUES (21, -- logID
                             1, -- client id
                             '2025-03-31', -- date
                             8, -- sleep duration
                             8 -- sleep quality
                            );

#4.1
INSERT INTO Food (FoodName, Calories)
VALUES ('Greek Yogurt', 120);

#4.2
DELETE FROM User
WHERE UserID = 101;

#4.3
UPDATE User
SET Name = 'Updated Name', Email = 'newemail@example.com'
WHERE UserID = 100;
#4.4
UPDATE FoodLog
SET FoodID = 2
WHERE UserID = 100 AND Date BETWEEN '2025-03-01' AND '2025-03-31';

#4.5
INSERT INTO SupportTicket (UserID, Issue)
VALUES (1, 'Having trouble saving workouts');

#4.6

INSERT INTO Employee (EmployeeID, Name, Email, Role)
VALUES
  (31, 'Markus', 'markus@healthhub.com', 'System Admin'),
  (32, 'Jane Intern', 'jane@healthhub.com', 'Intern');
INSERT INTO TicketEmployee (TicketID, EmployeeID)
VALUES (1, 2);

