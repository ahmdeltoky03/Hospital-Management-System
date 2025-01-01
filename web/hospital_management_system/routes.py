from flask import render_template, request, flash, redirect, url_for
from hospital_management_system import app, conn
import pyodbc
from hospital_management_system.routes_code import machine_routes, department_routes, patient_routes,rooms_routes, visits_routes, billings_routes,operations_routes,absence_routes,employees_routes,chat_routes
@app.route('/')
@app.route('/home')
def home():
    return render_template('index.html')

# @app.route('/chat')
# def home():
#     return render_template('chat.html')
@app.route('/about_us')
def about_us():
    return render_template('about_us.html')



@app.route('/appointments')
def appointments():
    return render_template('appointments.html')

# @app.route('/employees')
# def employees():
#     return render_template('employees.html')

