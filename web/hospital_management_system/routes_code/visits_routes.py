from hospital_management_system.routes import *
@app.route('/visits', methods=['GET', 'POST'])
def visits():
    if request.method == 'POST':
        patient_name = request.form['patient_name']
        visit_date = request.form['visit_date']
        visitors_number = request.form['visitors_number']

        # Execute stored procedure to add visit
        try:
            cursor = conn.cursor()
            cursor.execute('''
                INSERT INTO Visits (patient_id, visit_date, visitors_number)
                VALUES ((select patient_id from Patients where concat(first_name, ' ', middle_name, ' ', last_name) = ?), ?, ?);
                ''', (patient_name, visit_date, visitors_number))

            conn.commit()
            flash('Visit added successfully!', 'success')

        except Exception as e:
            flash(f'Error: {str(e)}', 'danger')
        
        return redirect(url_for('visits'))
    
    elif request.method == 'GET':
        cursor_01 = None  # Initialize to avoid unbound variable error
        search_type = request.args.get('search')
        search_value_text = request.args.get('value_text')
        
        if search_type == 'getAll':
            cursor_01 = conn.cursor()
            cursor_01.execute('''
                select
                    visit_id,
                    CONCAT(P.first_name, ' ', P.middle_name, ' ', P.last_name) AS patient_name,
                    V.visit_date,
                    V.visitors_number
                from Visits V
                join Patients P ON V.patient_id = P.patient_id;
            ''')
            visits = cursor_01.fetchall()

        elif search_type == 'visitDate':
            cursor_01 = conn.cursor()
            cursor_01.execute(f'''
                select
                    visit_id,
                    (select concat(first_name, ' ', middle_name, ' ', last_name) from Patients) as patient_name,
                    visit_date,
                    visitors_number
                from Visits
                where visit_date = ?
            ''', (search_value_text, ))
            visits = cursor_01.fetchall()

        else:
            visits = []  # Default to empty if no search_type is provided

    return render_template('visits.html', visits=visits)

@app.route('/delete_visit/<int:id>')
def delete_visit(id):
    cursor_01 = conn.cursor()
    cursor_01.execute(
        '''
            DELETE FROM Visits WHERE visit_id = ?
        ''', (id,)
    )
    conn.commit()  # Commit the deletion to the database
    flash('visit deleted successfully!', 'success')
    return redirect('/visits')  # Redirect after successful deletion

@app.route('/edit_visit/<int:id>', methods=['GET', 'POST'])
def edit_visit(id):
    cursor_01 = conn.cursor()

    if request.method == 'GET':
        cursor_01.execute(
            '''
            select (select concat(first_name, ' ', middle_name, ' ', last_name) from Patients where patient_id = ?) as patient_name,
                    visit_date,
                    visitors_number
            from Visits
            WHERE visit_id = ?
            ''', (id, id, )
        )
        visit = cursor_01.fetchone()

        cursor_01.execute(
            '''
            select concat(first_name, ' ', middle_name, ' ', last_name) as patient_name
            from Patients
            '''
        )
        patients_name = [row[0] for row in cursor_01]

        if not visit:
            return "visit not found", 404

        return render_template('edit_visit.html', visit=visit, patients_name = patients_name)
    
    elif request.method == 'POST':
        patient_name = request.form['patient_name']
        visit_date = request.form['visit_date']
        visitors_number = request.form['visitors_number']

        cursor_01 = conn.cursor()
        cursor_01.execute(
            '''
                select patient_id from Patients where concat(first_name, ' ', middle_name, ' ', last_name) = ?
            ''', (patient_name, )
        )
        patient_id = cursor_01.fetchone()
        
        # Update visit data in the database
        cursor_01.execute(
        '''
            UPDATE Visits
            SET 
                patient_id = ?,
                visit_date = ?,
                visitors_number = ?
            WHERE visit_id = ?;
        ''', (patient_id, visit_date, visitors_number, id)
        )

        conn.commit()  # Commit changes to the database

        # Redirect to the visits list or success page
        flash('visit edited successfully!', 'success')
        return redirect(url_for('visits'))  # Replace 'visits' with the actual function name that lists all visits