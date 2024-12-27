from hospital_management_system.routes import *

@app.route('/absence', methods=['GET', 'POST'])
def absence():
    if request.method == 'POST':
        absence_name = request.form['absence_name']
        absence_date = request.form['absence_date']
        absence_reason = request.form['reason']
        absence_status = request.form['absence_status']
        supervisor_name = request.form['approved_by']

        # Get employee_id from employees table
        try:
            cursor = conn.cursor()

            # Get employee_id for the absence_name
            
            ## general case
            # cursor.execute('''
            #     SELECT employee_id FROM employees 
            #     WHERE CONCAT(first_name, ' ', middle_name, ' ', last_name) = ?;
            # ''', (absence_name,))
            # employee_id = cursor.fetchone()[0]
            
            ## special case for my own database
            cursor.execute('''
                SELECT employee_id FROM employees 
                WHERE CONCAT(first_name,' ', last_name) = ?;
            ''', (absence_name,))
            employee_id = cursor.fetchone()[0]
            
            ## general case
            # Get employee_id for the supervisor_name
            # cursor.execute('''
            #     SELECT employee_id FROM employees 
            #     WHERE CONCAT(first_name, ' ', middle_name, ' ', last_name) = ?;
            # ''', (supervisor_name,))
            # supervisor_id = cursor.fetchone()[0]
            
            ## special case for my own database
            cursor.execute('''
                SELECT employee_id FROM employees 
                WHERE CONCAT(first_name, ' ', last_name) = ?;
            ''', (supervisor_name,))
            supervisor_id = cursor.fetchone()[0]

            # Execute stored procedure to add absence
            cursor.execute('''
                INSERT INTO Absense (employee_id, absense_date, reason, absense_status, approved_by)
                VALUES (?, ?, ?, ?, ?);
            ''', (employee_id, absence_date, absence_reason, absence_status, supervisor_id))

            conn.commit()
            flash('Absence reported successfully!', 'success')

        except Exception as e:
            flash(f'Error: {str(e)}', 'danger')
        
        return redirect(url_for('absence'))
    
    elif request.method == 'GET':
        cursor_01 = None  # Initialize to avoid unbound variable error
        search_type = request.args.get('search')
        search_value_text = request.args.get('value_text')
        
        if search_type == 'getAll':
            cursor_01 = conn.cursor()
            cursor_01.execute('''
                SELECT 
                    CONCAT(E.first_name, ' ', E.middle_name, ' ', E.last_name) AS absence_name,
                    A.reason AS absence_reason,
                    CONCAT(S.first_name, ' ', S.middle_name, ' ', S.last_name) AS supervisor_name
                FROM Absense A
                JOIN Employees E ON A.employee_id = E.employee_id
                LEFT JOIN Employees S ON A.approved_by = S.employee_id;
            ''')
            absences = cursor_01.fetchall()
        
        elif search_type == 'absenceDate':
            cursor_01 = conn.cursor()
            cursor_01.execute(f'''
                SELECT 
                    CONCAT(E.first_name, ' ', E.middle_name, ' ', E.last_name) AS absence_name,
                    A.reason AS absence_reason,
                    CONCAT(S.first_name, ' ', S.middle_name, ' ', S.last_name) AS supervisor_name
                FROM Absense A
                JOIN Employees E ON A.employee_id = E.employee_id
                LEFT JOIN Employees S ON A.approved_by = S.employee_id
                WHERE absense_date = ?;
            ''', (search_value_text, ))
            absences = cursor_01.fetchall()
        else:
            absences = []  # Default to empty if no search_type is provided

    return render_template('absence.html', absences=absences)


