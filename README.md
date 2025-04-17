# Health Hub

Health Hub is a data-driven app that helps users track their health by monitoring food intake, exercise, sleep, and mood. By visualizing personal health data over time, it motivates users to make healthier choices and recognize patterns in their habits.

## Team Members
- **Kevin Kato** - Trainer Persona (Jordan)
- **Sean Tian** - Admin Persona (Markus)
- **Kristen Cho** - User Persona (Jane)
- **Allan Zhen** - User Persona (Robert)

## Project Overview

HealthHub integrates multiple health metrics, allowing users to correlate factors like sleep, diet, and workouts in one place. Key features include dynamic data visualizations, a heatmap calendar, and a comprehensive tracking system. This project consists of three main components that will run in separate Docker containers:

- **Streamlit App** (located in the `./app` directory)
- **Flask REST API** (located in the `./api` directory)
- **MySQL Database** (initialized with SQL script files from the `./database-files` directory)

## Prerequisites

Make sure you have the following installed on your local machine:
- A **GitHub account**
- A terminal-based Git client or GUI Git client (e.g., GitHub Desktop or Git plugin for VSCode)
- **VSCode** with the **Python** plugin
- A distribution of **Python** (Anaconda or Miniconda recommended)

## Setup Instructions

### 1. Clone the Repository
 
```bash
- git clone https://github.com/allanzhen/3200-HealthHub.git
- cd 3200-HealthHub
```

### 2. Setting up .env
```
SECRET_KEY=someCrazyS3cR3T!Key.!
DB_USER=root
DB_HOST=localhost
DB_PORT=3201
DB_NAME=HealthHub
MYSQL_ROOT_PASSWORD=YourSecurePasswordHere
```
### 3. Setting up the Docker Compose -d 
```
version: 28.0.4 

name: HealthHubContainers
services:
  app-test:
    build: ./app
    container_name: web-app
    hostname: web-app
    volumes: ["./app/src:/appcode"]
    ports:
      - 8502:8501

  api-test:
    build: ./api
    container_name: web-api
    hostname: web-api
    volumes: ["./api:/apicode"]
    ports:
      - 4001:4000

  db-test:
    env_file:
      - ./api/.env
    image: mysql:9
    container_name: mysql-db
    hostname: db
    volumes:
      - ./database-files:/docker-entrypoint-initdb.d/:ro
    ports:
      - 3201:3306
```
