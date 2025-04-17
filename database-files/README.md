# `database-files` Folder

This is a sql database for this project that contains all of the tables, and sample data we used for the project. Below is the code for rebootstrapping.

## Re-bootstraping

Summary:
Delete tables with DROP statements

Create tables again with CREATE statements

Insert initial data if needed using INSERT

Use Flask-SQLAlchemy to easily reset tables with db.drop_all() and db.create_all()

```bash
docker compose down db -d
docker compose up db -d
```
