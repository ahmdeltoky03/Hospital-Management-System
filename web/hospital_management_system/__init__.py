# use Flask instance imported from flask package
from flask import Flask
import pyodbc

server = 'DESKTOP-SOG9J7V'       # e.g., localhost or SERVER_NAME
database = 'HOSPITAL'   # e.g., TestDB
driver = "ODBC Driver 17 for SQL Server"  # Use an available ODBC driver

app = Flask(__name__) # to create an instance of the web application
conn = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};'
    f'SERVER={server};'
    f'DATABASE={database};'
    'Trusted_Connection=yes;'
)
app.config['SECRET_KEY'] = 'cf1d1f01439c7cc8a809dcc6'

from hospital_management_system import routes