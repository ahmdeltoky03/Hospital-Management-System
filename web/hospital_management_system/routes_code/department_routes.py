from hospital_management_system.routes import *
import re
@app.route('/departments', methods=['GET', 'POST'])
def departments():
    if request.method == 'POST':
        department_name = request.form['name']
        department_description = request.form['description']
        department_haed = request.form['head']
        pattern = r'(\d+),\s*(.+)'
        match = re.match(pattern, department_haed)
        head_id = match.group(1)
        head_name = match.group(2)
        
        # Execute stored procedure to add department
        try:
            cursor = conn.cursor()
            cursor.execute('''
                INSERT INTO departments (department_name, department_description, head_of_department)
                VALUES (?, ?, ?)
                ''', (department_name, department_description, head_id))

            conn.commit()
            flash('Department added successfully!', 'success')

        except Exception as e:
            flash(f'Error: {str(e)}', 'danger')
        
        return redirect(url_for('departments'))
    
    elif request.method == 'GET':
        cursor_01 = None  # Initialize to avoid unbound variable error
        search_type = request.args.get('search')
        search_value = request.args.get('value')
        
        if search_type == 'getAll':
            cursor_01 = conn.cursor()
            cursor_01.execute('''
                SELECT 
                    department_id,
                    department_name,
                    department_description,
                    head_of_department,
                    (
                        SELECT CONCAT(first_name, ' ', middle_name, ' ', last_name)
                        FROM employees
                        WHERE employees.employee_id = departments.head_of_department
                    ) AS head_name
                FROM departments;
            ''')
            departments = cursor_01.fetchall()

        elif search_type == 'departmentName':
            cursor_01 = conn.cursor()
            cursor_01.execute('''
                SELECT 
                    department_id,
                    department_name,
                    department_description,
                    head_of_department,
                    (
                        SELECT CONCAT(first_name, ' ', middle_name, ' ', last_name)
                        FROM employees
                        WHERE employees.employee_id = departments.head_of_department
                    ) AS head_name
                FROM departments
                WHERE departments.department_name = ?
            ''', (search_value, ))

            departments = cursor_01.fetchall()
        
        elif search_type == 'headID':
            cursor_01 = conn.cursor()
            cursor_01.execute(f'''
                SELECT 
                    department_id,
                    department_name,
                    department_description,
                    head_of_department,
                    (
                        SELECT CONCAT(first_name, ' ', middle_name, ' ', last_name)
                        FROM employees
                        WHERE employees.employee_id = departments.head_of_department
                    ) AS head_name
                FROM departments
                WHERE departments.head_of_department = ?
            ''', (search_value, ))
            departments = cursor_01.fetchall()

        elif search_type == 'headName':
            cursor_01 = conn.cursor()
            cursor_01.execute('''
                SELECT 
                    department_id,
                    department_name,
                    department_description,
                    head_of_department,
                    CONCAT(first_name, ' ', middle_name, ' ', last_name) AS head_name
                FROM departments
                JOIN employees ON employees.employee_id = departments.head_of_department
                WHERE CONCAT(first_name, ' ', middle_name, ' ', last_name) = ?
            ''', (search_value,))
            departments = cursor_01.fetchall()
        
        else:
            departments = []  # Default to empty if no search_type is provided

    cursor_01 = conn.cursor()
    cursor_01 = conn.execute(
        '''
            SELECT 
                CONCAT(employee_id, ', ', first_name, ' ', middle_name, ' ', last_name) AS head_name
            FROM employees
        '''
    )
    heads = cursor_01.fetchall()

    return render_template('departments.html', departments=departments, heads=heads)

@app.route('/delete_department/<int:id>')
def delete_department(id):
    cursor_01 = conn.cursor()
    cursor_01.execute(
        '''
            delete from departments where department_id = ?
        ''', (id,)
    )
    conn.commit()  # Commit the deletion to the database
    flash('department deleted successfully!', 'success')
    return redirect('/departments')  # Redirect after successful deletion

@app.route('/edit_department/<int:id>', methods=['GET', 'POST'])
def edit_department(id):
    cursor_01 = conn.cursor()

    if request.method == 'GET':
        cursor_01.execute(
            '''
            SELECT
                department_name,
                department_description,
                (
                    SELECT CONCAT(employee_id, ', ', first_name, ' ', middle_name, ' ', last_name) AS head_name
                    FROM employees
                    where employee_id = ?
                ) as department_head
            FROM departments
            WHERE department_id = ?
            ''', (id, id, )
        )
        department = cursor_01.fetchone()

        if not department:
            return "department not found", 404
        
        cursor_01 = conn.cursor()
        cursor_01 = conn.execute(
            '''
                SELECT 
                    CONCAT(employee_id, ', ', first_name, ' ', middle_name, ' ', last_name) AS head_name
                FROM employees
            '''
        )
        heads = cursor_01.fetchall()

        return render_template('edit_department.html', department=department, heads=heads)
    
    elif request.method == 'POST':
        department_name = request.form['name']
        department_description = request.form['description']
        department_haed = request.form['head']
        pattern = r'(\d+),\s*(.+)'
        match = re.match(pattern, department_haed)
        head_id = match.group(1)
        
        # Update department data in the database
        cursor_01.execute(
        '''
        UPDATE departments
        SET department_name = ?, 
            department_description = ?, 
            head_of_department = ?
        WHERE department_id = ?
        ''', (department_name, department_description, head_id, id)
        )

        conn.commit()  # Commit changes to the database

        # Redirect to the departments list or success page
        flash('department edited successfully!', 'success')
        return redirect(url_for('departments'))  # Replace 'departments' with the actual function name that lists all departments