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
    LogID INT PRIMARY KEY,
    UserID INT,
    Date DATE NOT NULL,
    ExerciseType VARCHAR(50),
    Duration INT, # in minutes
    CaloriesBurned INT,
    TrainerNotes TEXT,
    setCount INT,
    repsInSet INT,
    WeightUsed DECIMAL(5,2),
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE
);

CREATE TABLE Food (
    FoodID INT PRIMARY KEY AUTO_INCREMENT,
    FoodName VARCHAR(100) NOT NULL,
    Calories INT
);

CREATE TABLE FoodLog (
    LogID INT PRIMARY KEY,
    UserID INT,
    Date DATE NOT NULL,
    MealType VARCHAR(50), # Breakfast, Lunch, Dinner, Snack
    FoodID INT,
    Calories INT,
    Protein DECIMAL(5,2),
    Carbs DECIMAL(5,2),
    Fats DECIMAL(5,2),
    FOREIGN KEY (FoodID) REFERENCES Food(FoodID) ON DELETE SET NULL,
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE
);

CREATE TABLE SleepLog (
    LogID INT PRIMARY KEY,
    UserID INT,
    Date DATE NOT NULL,
    SleepDuration DECIMAL(4,2), # in hours
    SleepQuality INT CHECK (SleepQuality BETWEEN 1 AND 10),
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE
);


CREATE TABLE MoodLog (
    LogID INT PRIMARY KEY,
    UserID INT,
    Date DATE NOT NULL,
    Mood VARCHAR(50), # Happy, Stressed, Tired, etc.
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
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    Date Date NOT NULL,
    AvgHeartRate INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE
);

CREATE TABLE VisualizationData (
    VizID INT PRIMARY KEY,
    UserID INT,
    MoodLogID INT,
    HeartRateID INT,
    SleepLogID INT,
    WorkoutLogID INT,
    FoodID INT,
    Date DATE NOT NULL,
    DataType VARCHAR(50), # Calories, Workouts, Sleep, Mood, etc.
    Value DECIMAL(10,2),
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE,
    FOREIGN KEY (MoodLogID) REFERENCES MoodLog(LogID) ON DELETE CASCADE,
    FOREIGN KEY (HeartRateID) REFERENCES HeartRateLog(LogID) ON DELETE CASCADE,
    FOREIGN KEY (SleepLogID) REFERENCES SleepLog(LogID) ON DELETE CASCADE,
    FOREIGN KEY (WorkoutLogID) REFERENCES WorkoutLog(LogID) ON DELETE CASCADE,
    FOREIGN KEY (FoodID) REFERENCES FoodLog(LogID) ON DELETE CASCADE
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
VALUES (1, 1, '2025-03-01', 'Weight Training', 45, 350, 'Increase weights gradually', 4, 12, 25.0),
       (2, 2, '2025-03-02', 'Running', 60, 500, 'Focus on pace control', NULL, NULL, NULL);

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
VALUES (1, 1, '2025-03-01', 7.5, 8),
       (2, 2, '2025-03-02', 6.0, 6);

# Insert into MoodLog
INSERT INTO MoodLog (LogID, UserID, Date, Mood)
VALUES (1, 1, '2025-03-01', 'Happy'),
       (2, 2, '2025-03-02', 'Tired');

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
VALUES (1, 1, '2025-03-01', 72),
       (2, 2, '2025-03-02', 80);

# Insert into VisualizationData
INSERT INTO VisualizationData (VizID, UserID, MoodLogID, HeartRateID, SleepLogID, WorkoutLogID, FoodID, Date, DataType, Value)
VALUES (1, 1, 1, 1, 1, 1, 1, '2025-03-01', 'Calories Burned', 350),
       (2, 2, 2, 2, 2, 2, 2, '2025-03-02', 'Sleep Hours', 6.0);

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

INSERT INTO Trainer (TrainerID, Name, Email, Certifications, Specializations)
VALUES
(3, 'Carlos Mendez', 'carlos.mendez@example.com', 'ISSA Certified', 'Weight Loss & Nutrition'),
(4, 'Samantha Lee', 'samantha.lee@example.com', 'NSCA Certified', 'Athletic Performance'),
(5, 'Robert King', 'robert.king@example.com', 'NASM Certified', 'Functional Fitness'),
(6, 'Angela Wu', 'angela.wu@example.com', 'ACE Certified', 'Senior Fitness'),
(7, 'David Patel', 'david.patel@example.com', 'Precision Nutrition L1', 'Nutrition Coaching'),
(8, 'Emily Hart', 'emily.hart@example.com', 'ISSA Certified', 'Strength & Conditioning'),
(9, 'Marcus Bell', 'marcus.bell@example.com', 'NSCA Certified', 'HIIT & Cross Training'),
(10, 'Natalie Cruz', 'natalie.cruz@example.com', 'NASM Certified', 'Yoga & Flexibility'),
(11, 'Jasmine Khan', 'jasmine.khan@example.com', 'ACSM Certified', 'Pre/Postnatal Fitness'),
(12, 'Tyler Brooks', 'tyler.brooks@example.com', 'NASM Certified', 'Bodybuilding'),
(13, 'Hannah Kim', 'hannah.kim@example.com', 'ACE Certified', 'Mind-Body Wellness'),
(14, 'Liam Wright', 'liam.wright@example.com', 'ISSA Certified', 'Endurance Sports'),
(15, 'Olivia Green', 'olivia.green@example.com', 'NASM Certified', 'Mobility & Movement'),
(16, 'Isaac Moore', 'isaac.moore@example.com', 'NSCA Certified', 'Powerlifting'),
(17, 'Rachel Adams', 'rachel.adams@example.com', 'Precision Nutrition L1', 'Healthy Eating Habits'),
(18, 'Noah Clark', 'noah.clark@example.com', 'ACE Certified', 'Group Training'),
(19, 'Chloe Torres', 'chloe.torres@example.com', 'ISSA Certified', 'Rehabilitation Fitness'),
(20, 'Ethan Ross', 'ethan.ross@example.com', 'NASM Certified', 'Athlete Development'),
(21, 'Sophia Lopez', 'sophia.lopez@example.com', 'ACSM Certified', 'Stress Management'),
(22, 'Daniel Scott', 'daniel.scott@example.com', 'NSCA Certified', 'Post-Injury Recovery'),
(23, 'Mia Reed', 'mia.reed@example.com', 'ACE Certified', 'Weight Management'),
(24, 'Lucas Rivera', 'lucas.rivera@example.com', 'ISSA Certified', 'Sports Conditioning'),
(25, 'Zoe Hall', 'zoe.hall@example.com', 'NASM Certified', 'HIIT & Bootcamps'),
(26, 'Aiden Foster', 'aiden.foster@example.com', 'Precision Nutrition L1', 'Meal Planning & Tracking'),
(27, 'Grace Simmons', 'grace.simmons@example.com', 'ACE Certified', 'Lifestyle Coaching'),
(28, 'Elijah Bennett', 'elijah.bennett@example.com', 'NASM Certified', 'Strength & Endurance'),
(29, 'Layla Turner', 'layla.turner@example.com', 'ISSA Certified', 'Holistic Health'),
(30, 'Benjamin Hughes', 'benjamin.hughes@example.com', 'NSCA Certified', 'Speed & Agility');

INSERT INTO Employee (EmployeeID, Name, Email, Role)
VALUES
  (5, 'Nina Patel', 'nina.patel@healthhub.com', 'Support Specialist'),
  (6, 'Carlos Mendes', 'carlos.mendes@healthhub.com', 'System Admin'),
  (7, 'Ava Thompson', 'ava.thompson@healthhub.com', 'Intern'),
  (8, 'Jasper Lee', 'jasper.lee@healthhub.com', 'Senior Developer'),
  (9, 'Zoe Martin', 'zoe.martin@healthhub.com', 'Support Specialist'),
  (10, 'Ethan Wright', 'ethan.wright@healthhub.com', 'Junior Developer'),
  (11, 'Sofia Kim', 'sofia.kim@healthhub.com', 'Nutrition Consultant'),
  (12, 'Noah Becker', 'noah.becker@healthhub.com', 'Junior Developer'),
  (13, 'Layla Moore', 'layla.moore@healthhub.com', 'Intern'),
  (14, 'Milo Scott', 'milo.scott@healthhub.com', 'Senior Developer'),
  (15, 'Isabella Tran', 'isabella.tran@healthhub.com', 'Nutrition Consultant'),
  (16, 'Leo Edwards', 'leo.edwards@healthhub.com', 'Junior Developer'),
  (17, 'Harper Simmons', 'harper.simmons@healthhub.com', 'Support Specialist'),
  (18, 'Caleb Brooks', 'caleb.brooks@healthhub.com', 'System Admin'),
  (19, 'Maya Rivera', 'maya.rivera@healthhub.com', 'Intern'),
  (20, 'Gabriel Yang', 'gabriel.yang@healthhub.com', 'Senior Developer'),
  (21, 'Aria West', 'aria.west@healthhub.com', 'Nutrition Consultant'),
  (22, 'Jackson Hill', 'jackson.hill@healthhub.com', 'Junior Developer'),
  (23, 'Chloe Barnes', 'chloe.barnes@healthhub.com', 'Support Specialist'),
  (24, 'Benjamin Fox', 'benjamin.fox@healthhub.com', 'Support Specialist'),
  (25, 'Luna Murphy', 'luna.murphy@healthhub.com', 'Intern'),
  (26, 'Owen Knight', 'owen.knight@healthhub.com', 'Senior Developer'),
  (27, 'Amelia Rhodes', 'amelia.rhodes@healthhub.com', 'Nutrition Consultant'),
  (28, 'Henry Vega', 'henry.vega@healthhub.com', 'Junior Developer'),
  (29, 'Gianna Foster', 'gianna.foster@healthhub.com', 'Support Specialist'),
  (30, 'Elijah Cruz', 'elijah.cruz@healthhub.com', 'Nutrition Consultant');

INSERT INTO Food (FoodName, Calories) VALUES ('Apple', 95);
INSERT INTO Food (FoodName, Calories) VALUES ('Banana', 105);
INSERT INTO Food (FoodName, Calories) VALUES ('Grilled Chicken Breast', 165);
INSERT INTO Food (FoodName, Calories) VALUES ('Avocado', 240);
INSERT INTO Food (FoodName, Calories) VALUES ('Almonds (1 oz)', 160);
INSERT INTO Food (FoodName, Calories) VALUES ('Oatmeal', 150);
INSERT INTO Food (FoodName, Calories) VALUES ('Scrambled Eggs (2)', 180);
INSERT INTO Food (FoodName, Calories) VALUES ('Steamed Broccoli', 55);
INSERT INTO Food (FoodName, Calories) VALUES ('Brown Rice (1 cup)', 215);
INSERT INTO Food (FoodName, Calories) VALUES ('Whole Wheat Bread (1 slice)', 80);
INSERT INTO Food (FoodName, Calories) VALUES ('Peanut Butter (2 tbsp)', 190);
INSERT INTO Food (FoodName, Calories) VALUES ('Carrots', 50);
INSERT INTO Food (FoodName, Calories) VALUES ('Tuna Salad', 200);
INSERT INTO Food (FoodName, Calories) VALUES ('Protein Shake', 250);
INSERT INTO Food (FoodName, Calories) VALUES ('Orange', 62);
INSERT INTO Food (FoodName, Calories) VALUES ('Granola Bar', 130);
INSERT INTO Food (FoodName, Calories) VALUES ('Cottage Cheese', 100);
INSERT INTO Food (FoodName, Calories) VALUES ('Spaghetti (1 cup)', 220);
INSERT INTO Food (FoodName, Calories) VALUES ('Meatballs (3)', 180);
INSERT INTO Food (FoodName, Calories) VALUES ('Baked Salmon', 230);
INSERT INTO Food (FoodName, Calories) VALUES ('Mixed Nuts (1 oz)', 170);
INSERT INTO Food (FoodName, Calories) VALUES ('Caesar Salad', 330);
INSERT INTO Food (FoodName, Calories) VALUES ('Bacon (2 slices)', 90);
INSERT INTO Food (FoodName, Calories) VALUES ('Pancakes (2 medium)', 180);
INSERT INTO Food (FoodName, Calories) VALUES ('Maple Syrup (2 tbsp)', 100);
INSERT INTO Food (FoodName, Calories) VALUES ('Mashed Potatoes (1 cup)', 210);
INSERT INTO Food (FoodName, Calories) VALUES ('Cheeseburger', 300);
INSERT INTO Food (FoodName, Calories) VALUES ('Fries (medium)', 365);
INSERT INTO Food (FoodName, Calories) VALUES ('Chocolate Chip Cookie', 150);
INSERT INTO Food (FoodName, Calories) VALUES ('Pizza Slice', 285);
INSERT INTO Food (FoodName, Calories) VALUES ('Soda (12 oz)', 140);
INSERT INTO Food (FoodName, Calories) VALUES ('Iced Coffee (with cream and sugar)', 190);
INSERT INTO Food (FoodName, Calories) VALUES ('Tofu Stir Fry', 250);
INSERT INTO Food (FoodName, Calories) VALUES ('Chili (1 cup)', 240);
INSERT INTO Food (FoodName, Calories) VALUES ('Green Smoothie', 180);
INSERT INTO Food (FoodName, Calories) VALUES ('Muffin', 330);
INSERT INTO Food (FoodName, Calories) VALUES ('Chicken Soup (1 cup)', 150);
INSERT INTO Food (FoodName, Calories) VALUES ('Egg Salad', 220);
INSERT INTO Food (FoodName, Calories) VALUES ('Turkey Sandwich', 270);
INSERT INTO Food (FoodName, Calories) VALUES ('Mac and Cheese (1 cup)', 310);
INSERT INTO Food (FoodName, Calories) VALUES ('Quinoa (1 cup)', 222);
INSERT INTO Food (FoodName, Calories) VALUES ('Beef Tacos (2)', 350);
INSERT INTO Food (FoodName, Calories) VALUES ('Rice Cakes (2)', 70);
INSERT INTO Food (FoodName, Calories) VALUES ('Hummus (2 tbsp)', 70);
INSERT INTO Food (FoodName, Calories) VALUES ('Cucumber Slices', 20);
INSERT INTO Food (FoodName, Calories) VALUES ('Chocolate Milk (1 cup)', 208);
INSERT INTO Food (FoodName, Calories) VALUES ('Bagel with Cream Cheese', 300);
INSERT INTO Food (FoodName, Calories) VALUES ('Popcorn (3 cups, air-popped)', 90);

INSERT INTO User (UserID, TrainerID, Name, Email, Age, Gender, Height, Weight, Goals, Goal_Weight, DOB)
VALUES (3, 3, 'Carlos Vega', 'carlos.vega@example.com', 41, 'Male', 175.00, 95.0, 'Lose weight', 78.0, '1983-03-11'),
(4, 2, 'Diana Lee', 'diana.lee@example.com', 24, 'Female', 160.00, 58.0, 'Maintain current weight', 58.0, '2001-06-09'),
(5, 1, 'Ethan Brown', 'ethan.brown@example.com', 29, 'Male', 185.00, 92.0, 'Build muscle mass', 95.0, '1996-08-03'),
(6, 3, 'Fiona Davis', 'fiona.davis@example.com', 32, 'Female', 170.00, 73.0, 'Lose fat and tone up', 65.0, '1993-09-21'),
(7, 2, 'George Harris', 'george.harris@example.com', 38, 'Male', 178.00, 88.0, 'Improve flexibility', 85.0, '1986-02-17'),
(8, 1, 'Hannah Kim', 'hannah.kim@example.com', 26, 'Female', 167.00, 70.0, 'Get stronger', 67.0, '1998-11-25'),
(9, 3, 'Ian Wright', 'ian.wright@example.com', 44, 'Male', 182.00, 90.5, 'Reduce body fat', 82.0, '1980-04-30'),
(10, 2, 'Julia Chen', 'julia.chen@example.com', 30, 'Female', 162.00, 61.0, 'Train for marathon', 60.0, '1994-01-15'),
(11, 1, 'Kevin Moore', 'kevin.moore@example.com', 36, 'Male', 177.00, 84.0, 'Lose belly fat', 78.0, '1988-07-19'),
(12, 3, 'Laura Scott', 'laura.scott@example.com', 27, 'Female', 169.00, 69.5, 'Improve endurance and strength', 65.0, '1997-10-13'),
(13, 2, 'Mark Allen', 'mark.allen@example.com', 50, 'Male', 176.00, 91.0, 'Stay active and healthy', 88.0, '1974-05-07'),
(14, 1, 'Nina Carter', 'nina.carter@example.com', 22, 'Female', 158.00, 54.0, 'Get toned', 52.0, '2003-03-27'),
(15, 2, 'Oscar Lewis', 'oscar.lewis@example.com', 33, 'Male', 183.00, 87.0, 'Bulk up for competition', 92.0, '1991-09-02'),
(16, 3, 'Paula Adams', 'paula.adams@example.com', 40, 'Female', 165.00, 72.0, 'Shed post-pregnancy weight', 65.0, '1984-06-18'),
(17, 1, 'Quincy Brooks', 'quincy.brooks@example.com', 28, 'Male', 180.00, 79.0, 'Improve overall health', 75.0, '1996-12-04'),
(18, 3, 'Rachel Nguyen', 'rachel.nguyen@example.com', 34, 'Female', 164.00, 63.0, 'Run a half marathon', 60.0, '1990-08-26'),
(19, 2, 'Sam Patel', 'sam.patel@example.com', 31, 'Male', 175.00, 83.0, 'Lose fat, keep muscle', 78.0, '1993-11-10'),
(20, 1, 'Tina Ross', 'tina.ross@example.com', 39, 'Female', 172.00, 74.0, 'Get in shape for vacation', 68.0, '1985-04-12'),
(21, 3, 'Ulysses Young', 'ulysses.young@example.com', 45, 'Male', 185.00, 97.0, 'Manage weight and blood pressure', 90.0, '1979-01-28'),
(22, 2, 'Valerie West', 'valerie.west@example.com', 37, 'Female', 160.00, 66.5, 'Maintain fitness', 65.0, '1987-06-30'),
(23, 1, 'William Hall', 'william.hall@example.com', 43, 'Male', 179.00, 86.0, 'Prepare for hiking trip', 82.0, '1981-10-20'),
(24, 3, 'Ximena Torres', 'ximena.torres@example.com', 25, 'Female', 168.00, 62.0, 'Gain lean muscle', 64.0, '1999-07-16'),
(25, 2, 'Yusuf Khan', 'yusuf.khan@example.com', 30, 'Male', 182.00, 89.0, 'Get stronger and leaner', 84.0, '1994-02-09'),
(26, 1, 'Zoey Rivera', 'zoey.rivera@example.com', 29, 'Female', 161.00, 60.0, 'Tone lower body', 57.0, '1995-05-05'),
(27, 3, 'Aaron Miles', 'aaron.miles@example.com', 34, 'Male', 176.00, 81.5, 'Lose fat and tone up', 76.0, '1990-03-01'),
(28, 2, 'Bella Ford', 'bella.ford@example.com', 31, 'Female', 163.00, 67.0, 'Improve core strength', 64.0, '1993-12-17'),
(29, 1, 'Caleb Stone', 'caleb.stone@example.com', 38, 'Male', 180.00, 88.0, 'Better posture and mobility', 85.0, '1986-11-08'),
(30, 3, 'Dana Walsh', 'dana.walsh@example.com', 27, 'Female', 170.00, 65.5, 'Stay fit and active', 65.0, '1997-02-20');

INSERT INTO SupportTicket (UserID, Issue) VALUES (1, 'Having trouble saving workouts');
INSERT INTO SupportTicket (UserID, Issue) VALUES (3, 'My progress isn''t updating after I complete a workout.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (5, 'I can''t find where to change my goal weight.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (2, 'The app keeps logging me out unexpectedly.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (7, 'The food tracker won''t let me add custom meals.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (10, 'I accidentally entered the wrong weight. How do I fix it?');
INSERT INTO SupportTicket (UserID, Issue) VALUES (12, 'The app seems slower than usual today.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (6, 'I completed a challenge but it still shows as incomplete.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (9, 'Can you help me find my trainer''s contact info in the app?');
INSERT INTO SupportTicket (UserID, Issue) VALUES (15, 'My step count isn''t syncing from my fitness tracker.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (8, 'Getting a black screen when I try to open the nutrition tab.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (13, 'I love the app but wish there was a dark mode.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (4, 'The workout videos aren''t playing. Are the servers down?');
INSERT INTO SupportTicket (UserID, Issue) VALUES (11, 'My reminders stopped coming through. I didn''t change any settings.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (14, 'Is there a way to export my progress for my doctor?');
INSERT INTO SupportTicket (UserID, Issue) VALUES (16, 'My calorie intake isn''t calculating correctly after meals.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (18, 'I think the app double-logged my last workout.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (20, 'The new update deleted my saved meal plans.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (19, 'I''d like to change my trainer but can''t find the option.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (17, 'There''s a typo in the Monday workout routine.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (21, 'My app keeps crashing whenever I log food.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (22, 'Please add more vegetarian recipes to the meal planner.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (24, 'I''m not receiving notifications anymore. It was working fine last week.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (23, 'My weight graph suddenly disappeared.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (25, 'I can''t remember my password and the reset link isn''t working.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (26, 'Can you explain how rest days affect my goals?');
INSERT INTO SupportTicket (UserID, Issue) VALUES (28, 'I didn''t receive credit for yesterday''s walk.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (27, 'When will the yoga section be available?');
INSERT INTO SupportTicket (UserID, Issue) VALUES (29, 'I''m confused about how to track water intake properly.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (30, 'App works great but I''d love to see weekly tips.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (3, 'I think my account got merged with someone else''s.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (5, 'It''s not letting me log food past 8 PM.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (7, 'The barcode scanner isn''t recognizing basic grocery items.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (2, 'Can you help me undo a deleted workout log?');
INSERT INTO SupportTicket (UserID, Issue) VALUES (9, 'App says I haven''t moved in days but I''ve walked every day.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (6, 'The challenges tab is just showing a blank screen.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (10, 'Why did my calories jump up after changing my goal?');
INSERT INTO SupportTicket (UserID, Issue) VALUES (12, 'Some foods aren''t showing up in the search results.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (11, 'I can''t scroll past a certain point on the workout list.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (4, 'Would love an easier way to log recurring meals.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (1, 'My profile picture won''t upload.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (13, 'The app forgot all my preferences after I updated.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (14, 'I''m unsure how to connect my smartwatch.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (15, 'Logging water resets randomly during the day.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (16, 'Can I pause my goal tracking while on vacation?');
INSERT INTO SupportTicket (UserID, Issue) VALUES (18, 'There''s a glitch in the weight entry section.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (19, 'My meals are being logged twice.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (20, 'Trainer messages aren''t loading.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (22, 'The new feature suggestions popup keeps reappearing.');
INSERT INTO SupportTicket (UserID, Issue) VALUES (26, 'Sleep tracker isn''t working as expected.');

INSERT INTO TicketEmployee (TicketID, EmployeeID)
VALUES (2, 5),
       (3, 12),
       (4, 8),
       (5, 19),
       (6, 4),
       (7, 27),
       (8, 1),
       (9, 17),
       (10, 22),
       (11, 30),
       (12, 13),
       (13, 6),
       (14, 9),
       (15, 18),
       (16, 23),
       (17, 15),
       (18, 11),
       (19, 3),
       (20, 26),
       (21, 10),
       (22, 7),
       (23, 25),
       (24, 14),
       (25, 28),
       (26, 21),
       (27, 20),
       (28, 16),
       (29, 24),
       (30, 29),
       (31, 2),
       (32, 12),
       (33, 8),
       (34, 19),
       (35, 5),
       (36, 4),
       (37, 13),
       (38, 22),
       (39, 11),
       (40, 30),
       (41, 1),
       (42, 6),
       (43, 9),
       (44, 7),
       (45, 18),
       (46, 10),
       (47, 3),
       (48, 15),
       (49, 17),
       (50, 27);