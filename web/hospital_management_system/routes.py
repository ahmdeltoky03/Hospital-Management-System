from flask import render_template, request, flash, redirect, url_for
from hospital_management_system import app, conn
import pyodbc

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

@app.route('/machines', methods=['GET', 'POST'])
def machines():
    if request.method == 'POST':
        machine_name = request.form['name']
        purchase_date = request.form['purchase_date']
        department_name = request.form['department']
        room_number = request.form['room']
        price = request.form['price']
        about = request.form['about']
        is_working = request.form['is_working']
        
        is_working = 1 if is_working == 'Busy' else 0

        try:
            price = int(price)
            if price <= 0:
                raise ValueError("Price must be a positive number.")

        except ValueError:
            flash('Error: Invalid input for price', 'danger')
            return redirect(url_for('machines'))

        # Execute stored procedure to add machine
        try:
            cursor = conn.cursor()
            cursor.execute('''
                EXEC AddNewMachine
                    @machine_name = ?,
                    @time_of_purchase = ?,
                    @department_name = ?,
                    @room_number = ?,
                    @price = ?,
                    @about = ?,
                    @is_working = ?
                ''', (machine_name, purchase_date, department_name, room_number, price, about, is_working))

            conn.commit()
            flash('Machine added successfully!', 'success')

        except Exception as e:
            flash(f'Error: {str(e)}', 'danger')
        
        return redirect(url_for('machines'))
    
    elif request.method == 'GET':
        cursor_01 = None  # Initialize to avoid unbound variable error
        search_type = request.args.get('search')
        search_value = request.args.get('value')
        print(search_type, ' ', search_value)
        
        if search_type == 'Get All':
            cursor_01 = conn.cursor()
            cursor_01.execute('''
                SELECT machine_name, 
                    time_of_purchase, 
                    (
                        SELECT department_name 
                        FROM Departments 
                        WHERE Departments.department_id = Machines.department_id
                    ) as department_name,
                    (
                        select room_number
                        from Rooms
                        where Rooms.room_id = Machines.room_id
                    ) as room_number,
                    price, 
                    about, 
                    is_working 
                FROM Machines
            ''')
            machines = cursor_01.fetchall()

        elif search_type == '1':
            cursor_01 = conn.cursor()
            cursor_01.execute(f'''
                SELECT machine_name, 
                    time_of_purchase, 
                    (
                        SELECT department_name 
                        FROM Departments 
                        WHERE Departments.department_id = Machines.department_id
                    ) AS department_name,
                    (
                        SELECT room_number
                        FROM Rooms
                        WHERE Rooms.room_id = Machines.room_id
                    ) AS room_number,
                    price, 
                    about, 
                    is_working 
                FROM Machines
                where machine_name = ?
            ''', (search_value, ))
            machines = cursor_01.fetchall()

        elif search_type == '2':
            cursor_01 = conn.cursor()
            cursor_01.execute(f'''
                SELECT machine_name, 
                    time_of_purchase, 
                    (
                        SELECT department_name 
                        FROM Departments 
                        WHERE Departments.department_id = Machines.department_id
                    ) AS department_name,
                    (
                        SELECT room_number
                        FROM Rooms
                        WHERE Rooms.room_id = Machines.room_id
                    ) AS room_number,
                    price, 
                    about, 
                    is_working 
                FROM Machines
                where department_id = (select department_id from Departments where Departments.department_name = ?)
            ''', (search_value, ))
            machines = cursor_01.fetchall()

        elif search_type == '3':
            cursor_01 = conn.cursor()
            cursor_01.execute(f'''
                SELECT machine_name, 
                    time_of_purchase, 
                    (
                        SELECT department_name 
                        FROM Departments 
                        WHERE Departments.department_id = Machines.department_id
                    ) AS department_name,
                    (
                        SELECT room_number
                        FROM Rooms
                        WHERE Rooms.room_id = Machines.room_id
                    ) AS room_number,
                    price, 
                    about, 
                    is_working 
                FROM Machines
                where room_id = (select room_id from Rooms where Rooms.room_number = ?)
            ''', (search_value, ))
            machines = cursor_01.fetchall()
        
        elif search_type == '4':
            cursor_01 = conn.cursor()
            cursor_01.execute(f'''
                SELECT machine_name, 
                    time_of_purchase, 
                    (
                        SELECT department_name 
                        FROM Departments 
                        WHERE Departments.department_id = Machines.department_id
                    ) AS department_name,
                    (
                        SELECT room_number
                        FROM Rooms
                        WHERE Rooms.room_id = Machines.room_id
                    ) AS room_number,
                    price, 
                    about, 
                    is_working 
                FROM Machines
                where is_working = ?
            ''', (search_value, ))
            machines = cursor_01.fetchall()

        else:
            machines = []  # Default to empty if no search_type is provided

    cursor_01 = conn.cursor()
    cursor_01.execute(
        '''
            select department_name from Departments
        '''
    )
    department_names = [row[0] for row in cursor_01.fetchall()]

    cursor_01 = conn.cursor()
    cursor_01.execute(
        '''
            select room_number from Rooms
        '''
    )
    room_numbers = [row[0] for row in cursor_01.fetchall()]

    return render_template('machines.html', machines=machines, department_names=department_names, room_numbers=room_numbers)

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