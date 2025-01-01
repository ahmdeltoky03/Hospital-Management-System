from hospital_management_system.routes import *
@app.route('/employees', methods=['GET', 'POST'])
def employees():
    if request.method == 'POST':
        first_name = request.form['first_name']
        middle_name = request.form['middle_name']
        last_name = request.form['last_name']
        date_of_birth = request.form['date_of_birth']
        gender = request.form['gender']
        salary = request.form['salary']
        hire_date = request.form['hire_date']
        weekly_hours = request.form['weekly_hours']
        address = request.form['employee_address']
        phone_number = request.form['phone_number']
        manager_name = request.form['manager_name']
        rate = request.form['performance_rate']
        
        cursor = conn.cursor()
        # Insert the data into the employees table
        try:
            cursor.execute('''
                exec AddNewEmployee
                @first_name = ?,
                @middle_name = ?,
                @last_name = ?,
                @date_of_birth = ?,
                @gender = ?,
                @salary = ?,
                @hire_date = ?,
				        @weekly_hours = ?,
                @employee_address  = ?,
                @phone_number = ?,
				        @manager_name = ?,
				        @performance_rate = ?
            ''', (first_name, middle_name, last_name, date_of_birth,gender,
                  salary,hire_date, weekly_hours, address, phone_number, manager_name, rate))
            conn.commit()
            flash('Employee added successfully!', 'success')

        except Exception as e:
            flash(f'Error: {str(e)}', 'danger')
        finally:
            cursor.close()
            
        return redirect(url_for('employees'))

    elif request.method == 'GET':
        cursor_01 = None  # Initialize to avoid unbound variable error
        search_type = request.args.get('search')
        search_value_text = request.args.get('value_text')
        search_value_bool = request.args.get('value_bool')

        
        if search_type == 'getAll':
            cursor_01 = conn.cursor()
            cursor_01.execute('''
                exec GetAllEmployees
            ''')
            employees = cursor_01.fetchall()
            cursor_01.close()
            return render_template('employees.html', employees=employees)

            

        elif search_type == 'first_name':
            cursor_01 = conn.cursor()
            cursor_01.execute(f'''
            exec GetEmployeesWithFirstName @first_name = ?
            ''', (search_value_text, ))
            
            employees = cursor_01.fetchall()
            cursor_01.close()
            return render_template('employees.html', employees=employees)
            
            
        elif search_type == 'full_name':
            cursor_01 = conn.cursor()
            cursor_01.execute(f'''
                exec GetEmployeesWithFullName @full_name = ?
            ''', (search_value_text,))
            
            employees = cursor_01.fetchall()
            cursor_01.close()
            return render_template('employees.html', employees=employees)
            


        elif search_type == 'gender':
            cursor_01 = conn.cursor()
            cursor_01.execute(f'''
            exec GetEmployeesWithGender @gender = ?
              
            ''', (search_value_text, ))
            employees = cursor_01.fetchall()
            cursor_01.close()
            return render_template('employees.html', employees=employees)

        elif search_type == 'weekly_hours':
            cursor_01 = conn.cursor()
            cursor_01.execute(f'''
                exec GetEmployeesWithWeeklyHours @weekly_hours = ?
            ''', (search_value_text, ))
            employees = cursor_01.fetchall()
            cursor_01.close()
            return render_template('employees.html', employees=employees)


        elif search_type == 'address':
            cursor_01 = conn.cursor()
            cursor_01.execute(f'''
                exec GetEmployeesWithAddress @address = ?
            ''', (search_value_text, ))
            employees = cursor_01.fetchall()
            cursor_01.close()
            return render_template('employees.html', employees=employees)
            
            
        elif search_type == 'performance_rate':
            cursor_01 = conn.cursor()
            cursor_01.execute(f'''
                exec GetEmployeesWithRate @rate = ?
            ''', (search_value_text, ))
            employees = cursor_01.fetchall()
            cursor_01.close()
            return render_template('employees.html', employees=employees)


        else:
            cursor_01 = conn.cursor()
            cursor_01.execute('''
                exec GetAllEmployees
            ''')
            employees = cursor_01.fetchall()
            cursor_01.close()
            return render_template('employees.html', employees=employees)
    return render_template('employees.html', employees=[])


@app.route('/delete_employee/<int:id>')
def delete_employee(id):
    cursor_01 = conn.cursor()
    cursor_01.execute(
        '''
        DELETE FROM Employees WHERE employee_id = ?
        ''', (id,))
    conn.commit()  # Commit the deletion to the database
    flash('Employee deleted successfully!', 'success')
    
    
    return redirect('/employees')  # Redirect after successful deletion

@app.route('/edit_employee/<int:id>', methods=['GET','POST'])
def edit_employee(id):
  
    
    if request.method == 'POST':
        first_name = request.form['first_name']
        middle_name = request.form['middle_name']
        last_name = request.form['last_name']
        date_of_birth = request.form['date_of_birth']
        gender = request.form['gender']
        salary = request.form['salary']
        hire_date = request.form['hire_date']
        weekly_hours = request.form['weekly_hours']
        address = request.form['employee_address']
        phone_number = request.form['phone_number']
        manager_name = request.form['manager_name']
        rate = request.form['performance_rate']
        
        # Update employee data in the database
        cursor_05 = conn.cursor()
        cursor_05.execute(
        '''
        exec UpdateEmployees 
        @first_name = ?,
        @middle_name = ?,
        @last_name = ?,
        @date_of_birth = ?,
        @gender = ?,
        @salary = ?,
        @hire_date ?,
				@weekly_hours ?,
        @employee_address ?,
        @phone_number ?,
				@manager_name ?,
				@performance_rate ? 
        ''', (first_name, middle_name, last_name, date_of_birth, gender,salary, hire_date, weekly_hours, address, phone_number, manager_name,rate,id)
        )

        conn.commit()  # Commit changes to the database

        # Redirect to the employees list or success page
        flash('Employee edited successfully!', 'success')
        return redirect(url_for('employees'))  # Redirect after successful edit