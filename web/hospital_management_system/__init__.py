# use Flask instance imported from flask package
from flask import Flask
import pyodbc

DRIVER_NAME = "SQL Server Native Client 11.0"  # Use "SQL Server" if needed
SERVER_NAME = "AHMEDPC"
DATABASE_NAME = "Hospital"

app = Flask(__name__) # to create an instance of the web application
conn = pyodbc.connect(f"""DRIVER={{{DRIVER_NAME}}};
SERVER={SERVER_NAME};
DATABASE={DATABASE_NAME};
Trusted_Connection=yes;"""
)
# app.config['SECRET_KEY'] = 'cf1d1f01439c7cc8a809dcc6'

from hospital_management_system import routes