from flask import render_template, request, flash, redirect, url_for
from hospital_management_system import app, conn
import pyodbc
from hospital_management_system.routes_code import machine_routes

@app.route('/')
@app.route('/home')
def home():
    return render_template('index.html')

@app.route('/about_us')
def about_us():
    return render_template('about_us.html')

@app.route('/absence')
def absence():
    return render_template('absence.html')

@app.route('/appointments')
def appointments():
    return render_template('appointments.html')

@app.route('/bills')
def bills():
    return render_template('bills.html')

@app.route('/departments')
def departments():
    return render_template('departments.html')

@app.route('/employees')
def employees():
    return render_template('employees.html')

@app.route('/operations')
def operations():
    return render_template('operations.html')

@app.route('/patients')
def patients():
    return render_template('patients.html')

@app.route('/rooms')
def rooms():
    return render_template('rooms.html')

@app.route('/visits')
def visits():
    return render_template('visits.html')

@app.route('/test')
def test():
    return render_template('test.html')