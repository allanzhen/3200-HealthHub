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
VALUES (1, 'John Doe', 'john.doe@example.com', 'NASM Certified', 'Strength Training'),
       (2, 'Jane Smith', 'jane.smith@example.com', 'ACE Certified', 'Cardio & Endurance');

# Insert into Employee
INSERT INTO Employee (EmployeeID, Name, Email, Role)
VALUES (1, 'Michael Johnson', 'michael.johnson@example.com', 'Support Specialist'),
       (2, 'Sarah Brown', 'sarah.brown@example.com', 'Nutrition Consultant');

# Insert into User
INSERT INTO User (UserID, TrainerID, Name, Email, Age, Gender, Height, Weight, Goals, Goal_Weight, DOB)
VALUES (1, 1, 'Alice Green', 'alice.green@example.com', 28, 'Female', 165.00, 68.5, 'Lose weight and gain muscle', 60.0, '1997-05-14'),
       (2, 2, 'Bob White', 'bob.white@example.com', 35, 'Male', 180.00, 85.0, 'Increase endurance', 80.0, '1990-12-22');

# Insert into SupportTicket
INSERT INTO SupportTicket (UserID, Issue)
VALUES (1, 'App not syncing workouts properly'),
       (2, 'Unable to update personal details');

# Insert into WorkoutPlan
INSERT INTO WorkoutPlan (PlanID, UserID, TrainerID, PlanName, Duration, Goal)
VALUES (1, 1, 1, 'Fat Loss Plan', 12, 'Lose 8 kg in 3 months'),
       (2, 2, 2, 'Marathon Training', 16, 'Build endurance for marathon');

# Insert into Split
INSERT INTO Split (SplitID, SplitName, UserID)
VALUES (1, 'Upper Body Strength', 1),
       (2, 'Leg Day', 2);

# Insert into WorkoutLog
INSERT INTO WorkoutLog (LogID, UserID, Date, ExerciseType, Duration, CaloriesBurned, TrainerNotes, setCount, repsInSet, WeightUsed)
VALUES
(1, 1, '2025-03-01', 'Weight Training', 45, 350, 'Increase weights gradually', 4, 12, 25.0),
(1, 2, '2025-03-02', 'Running', 60, 500, 'Focus on pace control', NULL, NULL, NULL);

# Insert into Food
INSERT INTO Food (FoodID, FoodName, Calories)
VALUES (1, 'Chicken Breast', 165),
       (2, 'Brown Rice', 215);

# Insert into FoodLog
INSERT INTO FoodLog (LogID, UserID, Date, MealType, FoodID, Calories, Protein, Carbs, Fats)
VALUES (1, 1, '2025-03-01', 'Lunch', 1, 165, 31.0, 0.0, 3.6),
       (2, 2, '2025-03-02', 'Dinner', 2, 215, 5.0, 45.0, 1.5);

# Insert into SleepLog
INSERT INTO SleepLog (LogID, UserID, Date, SleepDuration, SleepQuality)
VALUES
(1, 1, '2025-03-01', 7.5, 8),
(1, 2, '2025-03-02', 6.0, 6);

# Insert into MoodLog
INSERT INTO MoodLog (LogID, UserID, Date, Mood)
VALUES
(1, 1, '2025-03-01', 'Happy'),
(1, 2, '2025-03-02', 'Tired');

# Insert into ProgressTracking
INSERT INTO ProgressTracking (ProgressID, UserID, Date, Weight, BMI, BodyFatPercentage, TrainerComments)
VALUES (1, 1, '2025-03-01', 67.5, 24.8, 22.0, 'Good progress, keep up the consistency!'),
       (2, 2, '2025-03-02', 84.0, 26.0, 18.5, 'Increase protein intake.');

# Insert into Appointment
INSERT INTO Appointment (AppointmentID, UserID, ClientID, Date, Notes)
VALUES (1, 1, 1, '2025-03-05', 'Monthly check-in session'),
       (2, 2, 2, '2025-03-06', 'Workout technique assessment');

# Insert into HeartRateLog
INSERT INTO HeartRateLog (LogID, UserID, Date, AvgHeartRate)
VALUES
(1, 1, '2025-03-01', 72),
(1, 2, '2025-03-02', 80);

# Insert into VisualizationData
INSERT INTO VisualizationData (
    VizID, UserID, MoodLogID, HeartRateID, SleepLogID, WorkoutLogID,
    FoodLogUserID, FoodLogID, Date, DataType, Value
)
VALUES (
    1, 2, 2, 2, 2, 2, 2, 2, '2025-04-15', 'Calories', 650.00
);
# Insert into AIInsights
INSERT INTO AIInsights (InsightID, UserID, TrainerID, Date, PredictedWeight, PredictedMood, PredictedCalories)
VALUES (1, 1, 1, '2025-03-08', 67.0, 'Happy', 2200),
       (2, 2, 2, '2025-03-09', 83.5, 'Tired', 2500);

# Insert into DailySchedule
INSERT INTO DailySchedule (ScheduleID, SplitID, Date)
VALUES (1, 1, '2025-03-01'),
       (2, 2, '2025-03-02');

# Insert into TicketEmployee
INSERT INTO TicketEmployee (TicketID, EmployeeID)
VALUES (1, 1),
       (2, 2);

# Insert into Exercise
INSERT INTO Exercise (ExerciseID, Name, Description, MuscleGroup, EquipmentRequired, PersonalRecord, SplitID)
VALUES (1, 'Bench Press', 'Chest press using a barbell', 'Chest', 'Barbell', 100.0, 1),
       (2, 'Squat', 'Full body exercise focusing on legs', 'Legs', 'Barbell', 120.0, 2);

# Insert into ClientExercise
INSERT INTO ClientExercise (UserID, ExerciseID)
VALUES (1, 1),
       (2, 2);

# Insert into WorkoutPlanExercise
INSERT INTO WorkoutPlanExercise (PlanID, ExerciseID)
VALUES (1, 1),
       (2, 2);

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
  (3, 'Markus', 'markus@healthhub.com', 'System Admin'),
  (4, 'Jane Intern', 'jane@healthhub.com', 'Intern');
INSERT INTO TicketEmployee (TicketID, EmployeeID)
VALUES (1, 2);

