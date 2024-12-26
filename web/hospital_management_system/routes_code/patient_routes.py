from hospital_management_system.routes import *
@app.route('/patients', methods=['GET', 'POST'])
def patients():
    if request.method == 'POST':
        first_name = request.form['first_name']
        middle_name = request.form['middle_name']
        last_name = request.form['last_name']
        date_of_birth = request.form['date_of_birth']
        gender = request.form['gender']
        patient_entry_date = request.form['patient_entry_date']
        phone_number = request.form['phone_number']
        room_number = request.form['room_number']
        bed_number = request.form['bed_number']
        patient_status = request.form['patient_status']
        
        # Get room_id from Rooms table
        cursor = conn.cursor()
        cursor.execute('SELECT room_id FROM Rooms WHERE room_number = ?', (room_number,))
        room_id = cursor.fetchone()  # Fetch one result
        if not room_id:
            flash('Invalid room number', 'danger')
            return redirect(url_for('patients'))
        room_id = room_id[0]  # Extract room_id from the tuple
        
        # Get bed_id from Beds table
        cursor.execute('SELECT bed_id FROM Beds WHERE bed_number = ?', (bed_number,))
        bed_id = cursor.fetchone()  # Fetch one result
        if not bed_id:
            flash('Invalid bed number', 'danger')
            return redirect(url_for('patients'))
        bed_id = bed_id[0]  # Extract bed_id from the tuple

        # Insert the data into the employees table
        try:
            cursor.execute('''
                INSERT INTO Patients (first_name, middle_name, last_name, date_of_birth, gender, patient_entry_date, phone_number, room_id, bed_id, patient_status)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
            ''', (first_name, middle_name, last_name, date_of_birth, gender, patient_entry_date, phone_number, room_id, bed_id, patient_status))

            conn.commit()
            flash('Patient added successfully!', 'success')

        except Exception as e:
            flash(f'Error: {str(e)}', 'danger')
        
        return redirect(url_for('patients'))

    elif request.method == 'GET':
        cursor_01 = None  # Initialize to avoid unbound variable error
        search_type = request.args.get('search')
        search_value = request.args.get('value')
        search_value1 = request.args.get('value1')
        search_value2 = request.args.get('value2')
        search_value3 = request.args.get('value3')
        search_value_room = request.args.get('value_room')
        search_value_bed = request.args.get('value_bed')
        search_value_gender = request.args.get('value_gender')
        if search_value1 != None and search_value2 != None and search_value3 != None:
            dob = search_value3 + '-' + search_value2 + '-' + search_value1
        
        if search_type == 'getAll':
            cursor_01 = conn.cursor()
            cursor_01.execute('''
                select patient_id,
                    first_name,
                    middle_name,
                    last_name,
                    date_of_birth,
                    gender,
                    patient_entry_date,
                    phone_number,
                    (select room_number from rooms where rooms.room_id = patients.room_id) as room_number,
                    (select bed_number from beds where beds.bed_id = patients.bed_id) as bed_number,
                    patient_status
                from patients
            ''')
            patients = cursor_01.fetchall()

        elif search_type == 'First Name':
            cursor_01 = conn.cursor()
            cursor_01.execute(f'''
                select patient_id,
                    first_name,
                    middle_name,
                    last_name,
                    date_of_birth,
                    gender,
                    patient_entry_date,
                    phone_number,
                    (select room_number from rooms where rooms.room_id = patients.room_id) as room_number,
                    (select bed_number from beds where beds.bed_id = patients.bed_id) as bed_number,
                    patient_status
                from patients
                where patients.first_name = ?
            ''', (search_value, ))
            patients = cursor_01.fetchall()

        elif search_type == 'Full Name':
            cursor_01 = conn.cursor()
            cursor_01.execute(f'''
                select patient_id,
                    first_name,
                    middle_name,
                    last_name,
                    date_of_birth,
                    gender,
                    patient_entry_date,
                    phone_number,
                    (select room_number from rooms where rooms.room_id = patients.room_id) as room_number,
                    (select bed_number from beds where beds.bed_id = patients.bed_id) as bed_number,
                    patient_status
                from patients
                where concat(first_name, ' ', middle_name, ' ', last_name) = ?
            ''', (search_value,))
            patients = cursor_01.fetchall()

        elif search_type == 'Date Of Birth':
            cursor_01 = conn.cursor()
            cursor_01.execute(f'''
                select patient_id,
                    first_name,
                    middle_name,
                    last_name,
                    date_of_birth,
                    gender,
                    patient_entry_date,
                    phone_number,
                    (select room_number from rooms where rooms.room_id = patients.room_id) as room_number,
                    (select bed_number from beds where beds.bed_id = patients.bed_id) as bed_number,
                    patient_status
                from patients
                where date_of_birth = ?
            ''', (dob, ))
            patients = cursor_01.fetchall()

        elif search_type == 'Gender':
            cursor_01 = conn.cursor()
            cursor_01.execute(f'''
                select patient_id,
                    first_name,
                    middle_name,
                    last_name,
                    date_of_birth,
                    gender,
                    patient_entry_date,
                    phone_number,
                    (select room_number from rooms where rooms.room_id = patients.room_id) as room_number,
                    (select bed_number from beds where beds.bed_id = patients.bed_id) as bed_number,
                    patient_status
                from patients
                where gender = ?
            ''', (search_value_gender, ))
            patients = cursor_01.fetchall()
        
        elif search_type == 'Phone Number':
                if len(search_value) != 11:
                    flash('Phone Number length should be 11 digits', 'danger')
                if search_value[0:3] not in ('010', '011', '012', '015'):
                    flash('Phone Number shoud start with 010 or 011 or 012 or 015', 'danger')
                cursor_01 = conn.cursor()
                cursor_01.execute('''
                    select patient_id,
                        first_name,
                        middle_name,
                        last_name,
                        date_of_birth,
                        gender,
                        patient_entry_date,
                        phone_number,
                        (select room_number from rooms where rooms.room_id = patients.room_id) as room_number,
                        (select bed_number from beds where beds.bed_id = patients.bed_id) as bed_number,
                        patient_status
                    from patients
                    where phone_number = ?
                ''', (search_value,))
                patients = cursor_01.fetchall()

        elif search_type == 'Room Number':
            cursor_01 = conn.cursor()
            cursor_01.execute(f'''
                select patient_id,
                    first_name,
                    middle_name,
                    last_name,
                    date_of_birth,
                    gender,
                    patient_entry_date,
                    phone_number,
                    (select room_number from rooms where rooms.room_id = patients.room_id) as room_number,
                    (select bed_number from beds where beds.bed_id = patients.bed_id) as bed_number,
                    patient_status
                from patients
                where room_id = (select room_id from Rooms where Rooms.room_number = ?)
            ''', (search_value_room, ))
            patients = cursor_01.fetchall()

        elif search_type == 'Bed Number':
            cursor_01 = conn.cursor()
            cursor_01.execute(f'''
                select patient_id,
                    first_name,
                    middle_name,
                    last_name,
                    date_of_birth,
                    gender,
                    patient_entry_date,
                    phone_number,
                    (select room_number from rooms where rooms.room_id = patients.room_id) as room_number,
                    (select bed_number from beds where beds.bed_id = patients.bed_id) as bed_number,
                    patient_status
                from patients
                where bed_id = (select bed_id from Beds where Beds.bed_number = ?)
            ''', (search_value_bed, ))
            patients = cursor_01.fetchall()

        else:
            patients = []  # Default to empty if no search_type is provided

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
    rooms = [row[0] for row in cursor_01.fetchall()]

    cursor_01 = conn.cursor()
    cursor_01.execute(
        '''
            select bed_number from beds
        '''
    )
    beds = [row[0] for row in cursor_01.fetchall()]

    return render_template('patients.html', patients=patients, department_names=department_names, rooms=rooms, beds=beds)

@app.route('/delete_patient/<int:id>')
def delete_patient(id):
    cursor_01 = conn.cursor()
    cursor_01.execute(
        '''
        DELETE FROM patients WHERE patient_id = ?
        ''', (id,)
    )
    conn.commit()  # Commit the deletion to the database
    flash('patient deleted successfully!', 'success')
    return redirect('/patients')  # Redirect after successful deletion

@app.route('/edit_patient/<int:id>', methods=['GET', 'POST'])
def edit_patient(id):
    cursor_01 = conn.cursor()

    if request.method == 'GET':
        cursor_01.execute(
            '''
            select patient_id,
                first_name,
                middle_name,
                last_name,
                date_of_birth,
                gender,
                patient_entry_date,
                phone_number,
                (select room_number from rooms where rooms.room_id = patients.room_id) as room_number,
                (select bed_number from beds where beds.bed_id = patients.bed_id) as bed_number,
                patient_status
            from patients
            where patient_id = ?
            ''', (id,)
        )
        patient = cursor_01.fetchone()

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
        rooms = [row[0] for row in cursor_01.fetchall()]

        cursor_01 = conn.cursor()
        cursor_01.execute(
            '''
                select bed_number from beds
            '''
        )
        beds = [row[0] for row in cursor_01.fetchall()]

        if not patient:
            return "patient not found", 404

        return render_template('edit_patient.html', patient=patient, department_names=department_names, rooms=rooms, beds=beds)
    
    elif request.method == 'POST':
        first_name = request.form['first_name']
        middle_name = request.form['middle_name']
        last_name = request.form['last_name']
        date_of_birth = request.form['date_of_birth']
        gender = request.form['gender']
        patient_entry_date = request.form['patient_entry_date']
        phone_number = request.form['phone_number']
        room_number = request.form['room_number']
        bed_number = request.form['bed_number']
        patient_status = request.form['patient_status']
        
        # Update patient data in the database
        cursor_01.execute(
        '''
        UPDATE patients
        SET first_name = ?, 
            middle_name = ?, 
            last_name = ?,
            date_of_birth = ?,
            gender = ?, 
            patient_entry_date = ?, 
            phone_number = ?,
            room_id = (select room_id from Rooms where Rooms.room_number = ?),
            bed_id = (select bed_id from Beds where Beds.bed_number = ?),
            patient_status = ?
        WHERE patient_id = ?
        ''', (first_name, middle_name, last_name, date_of_birth, gender, patient_entry_date, phone_number, room_number, bed_number, patient_status, id)
        )

        conn.commit()  # Commit changes to the database

        # Redirect to the patients list or success page
        flash('patient edited successfully!', 'success')
        return redirect(url_for('patients'))  # Replace 'patients' with the actual function name that lists all patients