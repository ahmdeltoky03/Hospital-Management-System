from hospital_management_system.routes import *
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
        
        if search_type == 'getAll':
            cursor_01 = conn.cursor()
            cursor_01.execute('''
                exec GetAllMachines
            ''')
            machines = cursor_01.fetchall()

        elif search_type == 'machineName':
            cursor_01 = conn.cursor()
            cursor_01.execute(f''' 
                        exec GetMachineByItsName 
                            @machine_name = ? ''', (search_value, ))
            machines = cursor_01.fetchall()

        elif search_type == 'departmentName':
            cursor_01 = conn.cursor()
            cursor_01.execute(f'''
                exec GetMachinesByDepartmentName
                @department_name = ?
                ''', (search_value, ))
            machines = cursor_01.fetchall()

        elif search_type == 'roomNumber':
            cursor_01 = conn.cursor()
            cursor_01.execute(f'''
                exec GetMachinesByRoomNumber @room_number = ?
                ''', (search_value, ))
            machines = cursor_01.fetchall()
        
        elif search_type == 'isWorking':
                cursor_01 = conn.cursor()
                cursor_01.execute('''
                    exec GetMachinesByCaseOfWork @is_working = ?
                    ''', (search_value,))
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

@app.route('/delete_machine/<int:id>')
def delete_machine(id):
    cursor_01 = conn.cursor()
    cursor_01.execute(
        '''
        DELETE FROM machines WHERE machine_id = ?
        ''', (id,)
    )
    conn.commit()  # Commit the deletion to the database
    flash('Machine deleted successfully!', 'success')
    return redirect('/machines')  # Redirect after successful deletion

@app.route('/edit_machine/<int:id>', methods=['GET', 'POST'])
def edit_machine(id):
    cursor_01 = conn.cursor()

    if request.method == 'GET':
        cursor_01.execute(
            '''
            SELECT machine_id,
                machine_name, 
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
            WHERE machine_id = ?
            ''', (id,)
        )
        machine = cursor_01.fetchone()

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

        if not machine:
            return "Machine not found", 404

        return render_template('edit_machine.html', machine=machine, department_names=department_names, room_numbers=room_numbers)
    
    elif request.method == 'POST':
        updated_name = request.form['name']
        updated_time_of_purchase = request.form['purchase_date']
        updated_department = request.form['department']
        updated_room = request.form['room']
        updated_price = request.form['price']
        updated_status = request.form['is_working']
        updated_about = request.form['about']
        
        # Update machine data in the database
        cursor_01.execute(
        '''
        UPDATE machines
        SET machine_name = ?, 
            time_of_purchase = ?, 
            department_id = (SELECT department_id FROM departments WHERE department_name = ?),
            room_id = (SELECT room_id FROM rooms WHERE room_number = ?),
            price = ?, 
            about = ?, 
            is_working = ?
        WHERE machine_id = ?
        ''', (updated_name, updated_time_of_purchase, updated_department, updated_room, updated_price, updated_about, updated_status, id)
        )

        conn.commit()  # Commit changes to the database

        # Redirect to the machines list or success page
        flash('Machine edited successfully!', 'success')
        return redirect(url_for('machines'))  # Replace 'machines' with the actual function name that lists all machines