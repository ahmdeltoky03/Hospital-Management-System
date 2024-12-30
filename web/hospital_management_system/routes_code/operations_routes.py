from hospital_management_system.routes import *
@app.route('/operations',  methods=['GET', 'POST'])
def operations():
    if request.method == 'POST':
        operation_about = request.form['operation_about']
        patient_name = request.form['patient_name']
        patient_phone_number = request.form['patient_phone_number']
        department_name = request.form['department_name']
        room_number = request.form['room_number']
        operation_start_time = request.form['operation_start_time']
        operation_end_time = request.form['operation_end_time']
        success = int(request.form['success'])

        
        # Execute stored procedure to add visit
        try:
            cursor = conn.cursor()
            cursor.execute('''
                          exec AddNewOperation ?, ?, ?, ?, ?, ?, ?, ?;
                          ''',(operation_about, patient_name, patient_phone_number, department_name,
                              room_number, operation_start_time, operation_end_time, success))
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
                exec GetAllOperations
            ''')
            operations = cursor_01.fetchall()
            
            
        elif search_type == 'patient_name':
            cursor_01 = conn.cursor()
            cursor_01.execute('''
                              exec GetOperationsByPatientName ?;
                              ''', (search_value_text,))
            operations = cursor_01.fetchall()
            
            
        elif search_type == 'department_name':
          cursor_01 = conn.cursor()
          cursor_01.execute('''
                            exec GetOperationsByDepartment ?;
                            ''', (search_value_text,))
          operations = cursor_01.fetchall()
          
          
        
        elif search_type == 'room_number':
          cursor_01 = conn.cursor()
          cursor_01.execute('''
                            exec GetOperationsByRoomNum ?;
                            ''', (search_value_text,))
          operations = cursor_01.fetchall()
          
          
        elif search_type == 'operation_about':
          cursor_01 = conn.cursor()
          cursor_01.execute('''
                            exec GetOperationsByOperationAbout ?;
                            ''', (search_value_text,))
          operations = cursor_01.fetchall()
        
        
        
        elif search_type == 'success':
          cursor_01 = conn.cursor()
          cursor_01.execute('''
                            exec GetOperationsBySuccess ?;
                            ''', (search_value_text,))
          operations = cursor_01.fetchall()
          
          
        elif search_type == 'patient_phone_number':
          cursor_01 = conn.cursor()
          if success == 1:
            search_value_text = 1
          else:
            search_value_text = 0
          cursor_01.execute('''
                            exec GetOperationsByPatientPhoneNumber ?;
                            ''', (search_value_text,))
          operations = cursor_01.fetchall()
          
        else:
            operations = []  # Default to empty if no search_type is provided

    return render_template('operations.html', operations=operations)


