from hospital_management_system.routes import *
import re
@app.route('/billings', methods=['GET', 'POST'])
def billings():
    if request.method == 'POST':
        patient_name = request.form['patient_name']
        billing_description = request.form['billing_description']
        billing_value = request.form['billing_value']
        billing_date = request.form['billing_date']
        payment_status = request.form['payment_status']
        payment_method = request.form['payment_method']        
        payment_status = (
            1 if payment_status == 'Paid' else 
            -1 if payment_status == 'Overdue' else 
            0
        )
        

        try:
            billing_value = int(billing_value)
            if billing_value <= 0:
                raise ValueError("billing_value must be a positive number.")

        except ValueError:
            flash('Error: Invalid input for billing_value', 'danger')
            return redirect(url_for('billings'))

        except ValueError as e:
            flash(f'Error: {str(e)}', 'danger')
            return redirect(url_for('billings'))
        

        # Execute stored procedure to add billing
        try:
            cursor = conn.cursor()
            cursor.execute('''
                EXEC AddNewBilling
                    @patient_name = ?,
                    @billing_description = ?,
                    @billing_value = ?,
                    @billing_date = ?,
                    @payment_status = ?,
                    @payment_method = ?
                ''', (patient_name, billing_description, billing_value, billing_date, payment_status,payment_method ))

            conn.commit()
            flash('Billing added successfully!', 'success')

        except Exception as e:
            flash(f'Error: {str(e)}', 'danger')
        
        return redirect(url_for('billings'))
    
    elif request.method == 'GET':
        cursor_01 = None  # Initialize to avoid unbound variable error
        search_type = request.args.get('search')
        search_value_text = request.args.get('value_text')
        search_value_bool = request.args.get('value_bool')
        
        if search_type == 'getAll':
            cursor_01 = conn.cursor()
            cursor_01.execute('''
                SELECT billing_id,
                    billing_description,
                    billing_value,           
                    (
                        SELECT CONCAT(first_name, ' ', middle_name, ' ', last_name)
                        FROM Patients 
                        WHERE Patients.patient_id = billings.patient_id
                    ) as patient_name,
                    billing_date,
                    payment_status,
                    payment_method 
                FROM billings
            ''')
            billings = cursor_01.fetchall()


        elif search_type == 'patient_name':
            cursor_01 = conn.cursor()
            cursor_01.execute('''
                SELECT b.billing_id,
                    b.billing_description,
                    b.billing_value,           
                    CONCAT(p.first_name, ' ', p.middle_name, ' ', p.last_name) as patient_name,
                    b.billing_date,
                    b.payment_status,
                    b.payment_method
                FROM billings b
                INNER JOIN Patients p
                ON p.patient_id = b.patient_id
                WHERE CONCAT(p.first_name, ' ', p.middle_name, ' ', p.last_name) = ?
            ''', (search_value_text,))
            billings = cursor_01.fetchall()



        elif search_type == 'payment_status':
            cursor_01 = conn.cursor()
            cursor_01.execute('''
                SELECT billing_id,
                    billing_description,
                    billing_value,           
                    (
                        SELECT CONCAT(first_name, ' ', middle_name, ' ', last_name)
                        FROM Patients 
                        WHERE Patients.patient_id = billings.patient_id
                    ) as patient_name,
                    billing_date,
                    payment_status,
                    payment_method 
                FROM billings
                WHERE billings.payment_status = ?
            ''', (search_value_text,))
            billings = cursor_01.fetchall()

        else:
            billings = []  # Default to empty if no search_type is provided

    cursor_01 = conn.cursor()
    cursor_01.execute(
        '''
            SELECT 
                CONCAT(first_name, ' ', middle_name, ' ', last_name) AS patient_name
            FROM Patients            
        '''
    )
    patient_names = [row[0] for row in cursor_01.fetchall()]


    return render_template('billings.html', billings=billings, patient_names=patient_names)

@app.route('/delete_billing/<int:id>')
def delete_billing(id):
    cursor_01 = conn.cursor()
    cursor_01.execute(
        '''
        DELETE FROM billings WHERE billing_id = ?
        ''', (id,)
    )
    conn.commit()  # Commit the deletion to the database
    flash('Bill deleted successfully!', 'success')
    return redirect('/billings')  # Redirect after successful deletion

@app.route('/edit_billing/<int:id>', methods=['GET', 'POST'])
def edit_billing(id):
    cursor_01 = conn.cursor()

    if request.method == 'GET':
        cursor_01.execute(
            '''
            SELECT billing_id,
                    billing_description,
                    billing_value,           
                    (
                        SELECT CONCAT(first_name, ' ', middle_name, ' ', last_name)
                        FROM Patients 
                        WHERE Patients.patient_id = billings.patient_id
                    ) as patient_name,
                    billing_date,
                    payment_status,
                    payment_method 
                FROM billings
            WHERE billing_id = ?

            ''', (id,)
        )
        billing = cursor_01.fetchone()

        cursor_01 = conn.cursor()
        cursor_01.execute(
            '''
                SELECT 
                    CONCAT(first_name, ' ', middle_name, ' ', last_name) AS patient_name
                FROM Patients  
            '''
        )
        patient_names = [row[0] for row in cursor_01.fetchall()]

        if not billing:
            return "Machine not found", 404


        return render_template('edit_billing.html', billing=billing, patient_names=patient_names)
    
    elif request.method == 'POST':
        updated_name = request.form['Name']
        updated_description= request.form['description']
        updated_Value = request.form['Value']      
        # Update billing data in the database
        cursor_01.execute(
        '''
        UPDATE billings
        SET patient_name = ?, 
            billing_description = ?,
            billing_value = ?, 
        ''', (updated_name, updated_description, updated_Value, id)
        )

        conn.commit()  # Commit changes to the database

        # Redirect to the billings list or success page
        flash('billing edited successfully!', 'success')
        return redirect(url_for('billings'))  # Replace 'billings' with the actual function name that lists all billings