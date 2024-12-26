from hospital_management_system.routes import *
import re
@app.route('/rooms', methods=['GET', 'POST'])
def rooms():
    if request.method == 'POST':
        room_number = request.form['room_number']
        room_length = request.form['room_length']
        room_width = request.form['room_width']
        department_name = request.form['department_name']
        is_available = request.form['is_available']
        
        is_available = 1 if is_available == 'Free' else 0

        try:
            # Check if the room number is a string or numeric and ensure it's greater than 0
            if not isinstance(room_number, str) or not room_number.strip():
                raise ValueError("room_number must be a non-empty string.")

            # Extract numeric part from the room_number
            numeric_part = ''.join(filter(str.isdigit, room_number))

            # Ensure the numeric part is greater than 0
            if not numeric_part or int(numeric_part) <= 0:
                raise ValueError("room_number must contain a positive numeric part greater than zero.")

        except ValueError as e:
            flash(f'Error: {str(e)}', 'danger')
            return redirect(url_for('rooms'))
        

        # Execute stored procedure to add room
        try:
            cursor = conn.cursor()
            cursor.execute('''
                EXEC AddNewRoom
                    @room_number = ?,
                    @room_length = ?,
                    @room_width = ?,
                    @department_name = ?,
                    @is_available = ?
                ''', (room_number, room_length, room_width, department_name, is_available))

            conn.commit()
            flash('Room added successfully!', 'success')

        except Exception as e:
            flash(f'Error: {str(e)}', 'danger')
        
        return redirect(url_for('rooms'))
    
    elif request.method == 'GET':
        cursor_01 = None  # Initialize to avoid unbound variable error
        search_type = request.args.get('search')
        search_value_text = request.args.get('value_text')
        search_value_bool = request.args.get('value_bool')
        
        if search_type == 'getAll':
            cursor_01 = conn.cursor()
            cursor_01.execute('''
                SELECT room_id,
                    room_number, 
                    room_length,
                    room_width,           
                    (
                        SELECT department_name 
                        FROM Departments 
                        WHERE Departments.department_id = rooms.department_id
                    ) as department_name, 
                    is_available 
                FROM rooms
            ''')
            rooms = cursor_01.fetchall()


        elif search_type == 'roomNumber':
            cursor_01 = conn.cursor()
            cursor_01.execute(f'''
                SELECT room_id,
                    room_number, 
                    room_length,
                    room_width,           
                    (
                        SELECT department_name 
                        FROM Departments 
                        WHERE Departments.department_id = rooms.department_id
                    ) as department_name, 
                    is_available 
                FROM rooms
                WHERE room_number = ?
            ''', (search_value_text,))
            rooms = cursor_01.fetchall()


        elif search_type == 'departmentName':
            cursor_01 = conn.cursor()
            cursor_01.execute('''
                SELECT room_id,
                    room_number, 
                    room_length,
                    room_width,           
                    (
                        SELECT department_name 
                        FROM Departments 
                        WHERE Departments.department_id = rooms.department_id
                    ) as department_name, 
                    is_available 
                FROM rooms
                WHERE department_id = (
                    SELECT department_id 
                    FROM Departments 
                    WHERE department_name = ?
                )
            ''', (search_value_text,))
            rooms = cursor_01.fetchall()


        
        elif search_type == 'IsAvailable':
                cursor_01 = conn.cursor()
                cursor_01.execute('''
                    SELECT room_id,
                    room_number, 
                    room_length,
                    room_width,           
                    (
                        SELECT department_name 
                        FROM Departments 
                        WHERE Departments.department_id = rooms.department_id
                    ) as department_name, 
                    is_available 
                FROM rooms
                    WHERE is_available = ?
                ''', (search_value_bool,))
                rooms = cursor_01.fetchall()

        else:
            rooms = []  # Default to empty if no search_type is provided

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

    return render_template('rooms.html', rooms=rooms, department_names=department_names, room_numbers=room_numbers)

@app.route('/delete_room/<int:id>')
def delete_room(id):
    cursor_01 = conn.cursor()
    cursor_01.execute(
        '''
        DELETE FROM rooms WHERE room_id = ?
        ''', (id,)
    )
    conn.commit()  # Commit the deletion to the database
    flash('Room deleted successfully!', 'success')
    return redirect('/rooms')  # Redirect after successful deletion

@app.route('/edit_room/<int:id>', methods=['GET', 'POST'])
def edit_room(id):
    cursor_01 = conn.cursor()

    if request.method == 'GET':
        cursor_01.execute(
            '''
            SELECT room_id,
                    room_number, 
                    room_length,
                    room_width,           
                    (
                        SELECT department_name 
                        FROM Departments 
                        WHERE Departments.department_id = rooms.department_id
                    ) as department_name, 
                    is_available 
                FROM rooms
            WHERE room_id = ?
            ''', (id,)
        )
        room = cursor_01.fetchone()

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

        if not room:
            return "Machine not found", 404


        return render_template('edit_room.html', room=room, department_names=department_names, room_numbers=room_numbers)
    
    elif request.method == 'POST':
        updated_number = request.form['number']
        updated_length = request.form['length']
        updated_width = request.form['width']
        updated_department_name = request.form['department']
        updated_status = request.form['is_available']        
        # Update room data in the database
        cursor_01.execute(
        '''
        UPDATE rooms
        SET room_number = ?, 
            room_length = ?,
            room_width = ?, 
            department_id = (SELECT department_id FROM departments WHERE department_name = ?),
            is_available = ?
        WHERE room_id = ?
        ''', (updated_number, updated_length, updated_width, updated_department_name, updated_status, id)
        )

        conn.commit()  # Commit changes to the database

        # Redirect to the rooms list or success page
        flash('Room edited successfully!', 'success')
        return redirect(url_for('rooms'))  # Replace 'rooms' with the actual function name that lists all rooms