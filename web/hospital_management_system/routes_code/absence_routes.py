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
            cursor.execute(''' exec AddNewAbsence ?, ?, ?, ?, ?; ''', (absence_name, absence_date, absence_reason, absence_status, supervisor_name))

            # # Get employee_id for the absence_name
            
            # # general case
            # cursor.execute('''
            #     SELECT employee_id FROM employees 
            #     WHERE CONCAT(first_name, ' ', middle_name, ' ', last_name) = ?;
            # ''', (absence_name,))
            # employee_id = cursor.fetchone()[0]
            
            # ## special case for my own database
            # # cursor.execute('''
            # #     SELECT employee_id FROM employees 
            # #     WHERE CONCAT(first_name,' ', last_name) = ?;
            # # ''', (absence_name,))
            # # employee_id = cursor.fetchone()[0]
            
            # # general case
            # # Get employee_id for the supervisor_name
            # cursor.execute('''
            #     SELECT employee_id FROM employees 
            #     WHERE CONCAT(first_name, ' ', middle_name, ' ', last_name) = ?;
            # ''', (supervisor_name,))
            # supervisor_id = cursor.fetchone()[0]
            
            # ## special case for my own database
            # # cursor.execute('''
            # #     SELECT employee_id FROM employees 
            # #     WHERE CONCAT(first_name, ' ', last_name) = ?;
            # # ''', (supervisor_name,))
            # # supervisor_id = cursor.fetchone()[0]

            # # Execute stored procedure to add absence
            # cursor.execute('''
            #     INSERT INTO Absense (employee_id, absense_date, reason, absense_status, approved_by)
            #     VALUES (?, ?, ?, ?, ?);
            # ''', (employee_id, absence_date, absence_reason, absence_status, supervisor_id))

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

        elif search_type == 'absenceName':
            cursor_01 = conn.cursor()
            cursor_01.execute(f'''
                SELECT 
                    CONCAT(E.first_name, ' ', E.middle_name, ' ', E.last_name) AS absence_name,
                    A.reason AS absence_reason,
                    CONCAT(S.first_name, ' ', S.middle_name, ' ', S.last_name) AS supervisor_name
                FROM Absense A
                JOIN Employees E ON A.employee_id = E.employee_id
                LEFT JOIN Employees S ON A.approved_by = S.employee_id
                WHERE CONCAT(E.first_name, ' ', E.middle_name, ' ', E.last_name) like ?;
            ''', ('%'+search_value_text+'%', ))
            absences = cursor_01.fetchall()
          
        elif search_type == 'absenceDate':
            cursor_01 = conn.cursor()
            cursor_01.execute(f'''
                SELECT 
                    CONCAT(E.first_name, ' ', E.middle_name, ' ', E.last_name) AS absence_name,
                    A.reason AS absence_reason,
                    Coalesce( CONCAT(S.first_name, ' ', S.middle_name, ' ', S.last_name),'N/A') AS supervisor_name
                FROM Absense A
                JOIN Employees E ON A.employee_id = E.employee_id
                LEFT JOIN Employees S ON A.approved_by = S.employee_id
                WHERE A.absense_date = ?;
            ''', (search_value_text, ))
            absences = cursor_01.fetchall()
        
        elif search_type == 'absenceReason':
            cursor_01 = conn.cursor()
            cursor_01.execute(f'''
                SELECT 
                    CONCAT(E.first_name, ' ', E.middle_name, ' ', E.last_name) AS absence_name,
                    A.reason AS absence_reason,
                    CONCAT(S.first_name, ' ', S.middle_name, ' ', S.last_name) AS supervisor_name
                FROM Absense A
                JOIN Employees E ON A.employee_id = E.employee_id
                LEFT JOIN Employees S ON A.approved_by = S.employee_id
                WHERE A.reason = ?;
            ''', (search_value_text, ))
            absences = cursor_01.fetchall()
            
            
        elif search_type == 'absenceStatus':
            cursor_01 = conn.cursor()
            cursor_01.execute(f'''
                SELECT 
                    CONCAT(E.first_name, ' ', E.middle_name, ' ', E.last_name) AS absence_name,
                    A.reason AS absence_reason,
                    CONCAT(S.first_name, ' ', S.middle_name, ' ', S.last_name) AS supervisor_name
                FROM Absense A
                JOIN Employees E ON A.employee_id = E.employee_id
                LEFT JOIN Employees S ON A.approved_by = S.employee_id
                WHERE A.absense_status = ?;
            ''', (search_value_text, ))
            absences = cursor_01.fetchall()
        else:
            absences = []  # Default to empty if no search_type is provided

    return render_template('absence.html', absences=absences)



@app.route('/edit_absence/<int:absense_id>', methods=['GET', 'POST'])
def edit_absence(absense_id):
    if request.method == 'POST':
        # Get updated form data
        absence_name = request.form['absence_name']
        reason = request.form['reason']
        absence_status = request.form['absence_status']
        approved_by = request.form['approved_by']

        try:
            # Update the database record
            cursor = conn.cursor()
            cursor.execute('''
                UPDATE Absense
                SET reason = ?, absense_status = ?, approved_by = ?
                WHERE absense_id = ?
            ''', (reason, absence_status, approved_by, absense_id))
            conn.commit()
            flash('Absence updated successfully!', 'success')
        except Exception as e:
            flash(f'Error: {str(e)}', 'danger')

        return redirect(url_for('absence'))

    elif request.method == 'GET':
        # Fetch the absence details for the given absense_id
        cursor = conn.cursor()
        cursor.execute('''
            SELECT A.*, 
                   CONCAT(E.first_name, ' ', E.middle_name, ' ', E.last_name) AS employee_name,
                   COALESCE(CONCAT(S.first_name, ' ', S.middle_name, ' ', S.last_name), 'N/A') AS supervisor_name
            FROM Absense A
            JOIN Employees E ON A.employee_id = E.employee_id
            LEFT JOIN Employees S ON A.approved_by = S.employee_id
            WHERE A.absense_id = ?;
        ''', (absense_id,))
        absence = cursor.fetchone()

        if not absence:
            return "Absence not found", 404

        return render_template('edit_absence.html', absence=absence)

# @app.route('/edit_absence/<int:absence_id>', methods=['GET', 'POST'])
# def edit_absence(absence_id):
#     if request.method == 'POST':
#         absence_name = request.form['absence_name']
#         reason = request.form['reason']
#         approved_by = request.form['approved_by']
        
#         cursor = conn.cursor()
#         cursor.execute('''
#             UPDATE Absense
#             SET absence_name = ?, reason = ?, approved_by = ?
#             WHERE absence_id = ?
#         ''', (absence_name, reason, approved_by, absence_id))
#         conn.commit()
#         flash('Absence updated successfully!', 'success')
#         return redirect(url_for('absence'))
    
#         cursor = conn.cursor()
#         cursor.execute('''
#             SELECT 
#                 absence_id,
#                 CONCAT(E.first_name, ' ', E.middle_name, ' ', E.last_name) AS absence_name,
#                 A.reason AS absence_reason,
#                 CONCAT(S.first_name, ' ', S.middle_name, ' ', S.last_name) AS supervisor_name
#             FROM Absense A
#             JOIN Employees E ON A.employee_id = E.employee_id
#             LEFT JOIN Employees S ON A.approved_by = S.employee_id
#             WHERE A.absense_id = ?;
#         ''', (absence_id, ))
#         absences = cursor.fetchone()
    
#         return redirect(url_for('absence.html'))
  
#     elif request.method == 'GET':
#         cursor  = conn.cursor()
#         cursor.execute('''
#             SELECT A.*, E.first_name, E.middle_name, E.last_name, 
#                         CONCAT(S.first_name, ' ', S.middle_name, ' ', S.last_name) AS supervisor_name
#             FROM Absense A
#             JOIN Employees E ON A.employee_id = E.employee_id
#             LEFT JOIN Employees S ON A.approved_by = S.employee_id
#             WHERE A.absense_id = ?;
#         ''', (absence_id,))
#         absence = cursor.fetchone()

#         if not absence:
#           return "Absence not found", 404

#         return render_template('edit_absence.html', absence=absence)

@app.route('/delete_absence/<int:absence_id>', methods=['GET'])
def delete_absence(absense_id):
    cursor = conn.cursor()
    cursor.execute('''DELETE FROM Absense WHERE absense_id = ?''', (absense_id, ))
    conn.commit()
    flash('Absence deleted successfully!', 'success')
    return redirect(url_for('absence'))