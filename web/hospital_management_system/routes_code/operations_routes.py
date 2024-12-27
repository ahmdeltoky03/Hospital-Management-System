from hospital_management_system.routes import *
@app.route('/operations',  methods=['GET', 'POST'])
def operations():
    if request.method == 'POST':
        operation_about = request.form['operation_about']
        patient_name = request.form['patient_name']
        patient_phone_number = request.form['patient_phone_number']
        department_name = request.form['department_name']
        room_number = request.form['room_number']
        operation_date = request.form['operation_date']
        # operation_start_time = request.form['operation_start_time']
        # operation_end_time = request.form['operation_end_time']
        success = request.form['success']

        
        # Execute stored procedure to add visit
        try:
            cursor = conn.cursor()
            
            ## general case
            cursor.execute('''
                SELECT patient_id FROM patients 
                WHERE CONCAT(first_name, ' ', middle_name, ' ', last_name) = ?;
            ''', (patient_name,))
            
            # special case for my own database
            # cursor.execute('''
            #     SELECT patient_id FROM patients 
            #     WHERE CONCAT(first_name,'  ', last_name) = ?;
            # ''', (patient_name,))
            
            patient = cursor.fetchone()
            if patient is None:
                flash('Patient not found!', 'danger')
                return redirect(url_for('operations'))
            patient_id = patient[0]
            
            cursor.execute('''
                SELECT department_id FROM Departments 
                WHERE department_name  = ?;
            ''', (department_name,))
            department = cursor.fetchone()
            
            if department is None:
                flash('Department not found!', 'danger')
                return redirect(url_for('operations'))
            department_id = department[0]

            cursor.execute('''
                SELECT room_id FROM Rooms 
                WHERE room_number  = ?;
            ''', (room_number,))
            room = cursor.fetchone()
            if room is None:
                flash('Room not found!', 'danger')
                return redirect(url_for('operations'))
            room_id = room[0]        

            # Set operation_start_time to the current date and time
            operation_start_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

            # Set operation_end_time to two hours after the current date and time
            operation_end_time = (datetime.now() + timedelta(hours=2)).strftime('%Y-%m-%d %H:%M:%S')
            
            cursor.execute('''
                INSERT INTO Operations (operation_about,patient_id,patient_name,patient_phone_number,
                                        department_id,room_id,operation_date,operation_start_time,
                                        operation_end_time,success)
                VALUES ( ?, ?, ? ,? , ?, ?, ?, ?, ?, ?);
                ''', (operation_about,patient_id,patient_name,patient_phone_number,
                      department_id,room_id,operation_date,operation_start_time,
                      operation_end_time,success))

            conn.commit()
            flash('Operation added successfully!', 'success')

        except Exception as e:
            flash(f'Error: {str(e)}', 'danger')
        
        return redirect(url_for('operations'))
    
    elif request.method == 'GET':
        cursor_01 = None  # Initialize to avoid unbound variable error
        search_type = request.args.get('search')
        search_value_text = request.args.get('value_text')
        
        if search_type == 'getAll':
            cursor_01 = conn.cursor()
            cursor_01.execute('''
                select 
                  o.operation_about as operation_about,
                  o.patient_name as patient_name,
                  o.patient_phone_number as patient_phone_number,
                  d.department_name as department_name,
                  r.room_number as room_number,
                  o.success as success
                  from operations o join Departments d
                  on o.department_id = d.department_id
                  join patients p 
                  on p.patient_id = o.patient_id
                  join rooms r 
                  on r.room_id = o.room_id ;
            ''')
            operations = cursor_01.fetchall()

        else:
            operations = []  # Default to empty if no search_type is provided

    return render_template('operations.html', operations=operations)

