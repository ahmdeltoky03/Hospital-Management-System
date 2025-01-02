-- ------------- Triggers --------------- --

use HOSPITAL
go
-- I want to make triggers after deleting.#######

-- This trigger to update the number of operations for each doctor
-- and increasing its salary with 10 each 20 operation.
CREATE TRIGGER UpdateDoctorSalaryOnOperations
ON OperationDoctors
AFTER INSERT, DELETE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Update the number_of_operations in Doctors table
    UPDATE d
    SET d.number_of_operations = ISNULL(t.operation_count, 0)
    FROM Doctors d
    LEFT JOIN (
        SELECT doctor_id, COUNT(*) AS operation_count
        FROM OperationDoctors
        GROUP BY doctor_id
    ) t ON d.doctor_id = t.doctor_id;

    -- Increase salary by 10% for doctors who completed another 20 operations
    UPDATE e
    SET e.salary = e.salary * 1.1
    FROM Employees e
    INNER JOIN Doctors d ON e.employee_id = d.doctor_id
    INNER JOIN (
        SELECT doctor_id, COUNT(*) AS operation_count
        FROM OperationDoctors
        GROUP BY doctor_id
    ) t ON d.doctor_id = t.doctor_id
    WHERE t.operation_count % 20 = 0 -- Check if operations are a multiple of 20
    AND t.operation_count > d.number_of_operations; -- Prevent repeated salary updates for the same count
END;



go
-- I made a trigger (DeletingEmployee) for the case of deleting the employee to make it default.

CREATE TRIGGER DeletingEmployee
ON Employees
AFTER DELETE
AS
BEGIN
    -- Update the 'approved_by' column to its default value for rows referencing deleted employees
    UPDATE Absense
    SET approved_by = DEFAULT
    WHERE approved_by IN (SELECT employee_id FROM deleted);

	-- Update the 'manager_id' column to Null value for rows referencing deleted employees
    UPDATE Employees
    SET manager_id = Null
    WHERE manager_id IN (SELECT employee_id FROM deleted);
END;

-- --------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------

go
-- I create this trigger to make the phone number always updated with the patient table.
CREATE TRIGGER UpdatePatientInformation
ON Patients
AFTER UPDATE
AS
BEGIN
	UPDATE Operations
	SET 
		patient_phone_number = i.phone_number,
		patient_name = i.first_name + ' ' + i.middle_name + ' ' + i.last_name -- Update full name
	FROM Operations o
	INNER JOIN inserted i ON o.patient_id = i.patient_id;
END;
	
-- --------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------


go
-- I create this trigger to make the phone number always updated with the employee table.
CREATE TRIGGER UpdatingInformationOfEmployees
	ON Employees
	AFTER UPDATE
	AS
	BEGIN
		UPDATE OperationDoctors
		SET 
			doctor_phone_number = i.phone_number,
			doctor_name = i.first_name + ' ' + i.middle_name + ' ' + i.last_name -- Update full name
		FROM OperationDoctors o
		INNER JOIN inserted i ON o.doctor_id = i.employee_id;

		UPDATE Appointments
		SET 
			doctor_phone_number = i.phone_number,
			doctor_name = i.first_name + ' ' + i.middle_name + ' ' + i.last_name -- Update full name
		FROM Appointments a
		INNER JOIN inserted i ON a.doctor_id = i.employee_id;
	END;



-- --------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------

go
-- Trigger in the case of Deleting Rooms.
CREATE TRIGGER DeletingRooms
	ON Rooms
	AFTER DELETE
	AS
	BEGIN
		UPDATE Patients
		SET
			room_id = Null
		FROM Patients p
		WHERE p.room_id in (select room_id from deleted) 

		UPDATE Doctors
		SET
			appointment_room = Null
		FROM Doctors d
		WHERE d.appointment_room in (select room_id from deleted) 

end


-- --------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------
go
-- Trigger which set the hire_date of a new employee.
CREATE TRIGGER SetHireDateOnInsert
ON Employees
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Update the hire_date column for newly inserted employees
    UPDATE Employees
    SET hire_date = CAST(GETDATE() AS DATE) -- Sets today's date
    WHERE employee_id IN (SELECT employee_id FROM inserted)
    AND hire_date IS NULL; -- Update only if hire_date was not provided
END;



-- --------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------

-- Trigger which set the patient_entry_date of a new patient.
go
CREATE TRIGGER SetHireDateOnInsertForEmployees
ON Patients
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Update the patient_entry_date column for newly inserted patients
    UPDATE Patients
    SET patient_entry_date = CAST(GETDATE() AS DATE) -- Sets today's date
    WHERE patient_id IN (SELECT patient_id FROM inserted)
    AND patient_entry_date IS NULL; -- Update only if patient_entry_date was not provided
END;


-- --------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------



/*
CREATE TRIGGER UpdateEmployeesRelated
ON Employees
AFTER UPDATE
AS
BEGIN
    -- Update the supervisor in the Nursing table to match the new supervisor in Employees
    UPDATE Nursing
    SET supervisor = i.employee_id
    FROM inserted i, Nursing n
    INNER JOIN deleted d ON n.supervisor = d.employee_id;

	-- Update the approving of absense in the Absense table to match the new employee in Employees.
    UPDATE Absense
    SET approved_by = i.employee_id
    FROM Absense a
    INNER JOIN inserted i ON a.approved_by = i.employee_id;

	-- Update the id of the doctor who made the appointment in the Appointment table to match the new employee in Employees.
    UPDATE Appointments
    SET docotr_id = i.employee_id
    FROM Appointments a
    INNER JOIN inserted i ON a.doctor_id = i.employee_id;

	-- Update the doctor_id in OperationsDoctor table to match the new doctor_id in Employees
    UPDATE Operations
    SET doctor_id = i.employee_id
    FROM OperationDoctors o
    INNER JOIN inserted i ON o.doctor_id = i.employee_id;

END;
*/




/*
CREATE TRIGGER UpdateDoctorAndNursingDepartment
ON Departments
AFTER UPDATE
AS
BEGIN
    -- Update the Department_ID in the Doctors table to match the new Department_ID in Departments
    UPDATE Doctors
    SET department_id = i.department_id
    FROM Doctors d
    INNER JOIN inserted i ON d.department_id = i.department_id;

	-- Update the Department_ID in the Nursing table to match the new Department_ID in Departments
    UPDATE Nursing
    SET Department_ID = i.Department_ID
    FROM Nursing n
    INNER JOIN inserted i ON n.department_id = i.department_id;
END;*/


















		



-- Updating Rooms Related.
/*
CREATE TRIGGER UpdateRoomsRelated
ON Rooms
AFTER UPDATE
AS
BEGIN
    -- Update the operation place in the Operations table to match the new room in Rooms
    UPDATE Operations
    SET room_id = i.room_id
    FROM Operations o
    INNER JOIN inserted i ON o.room_id = i.room_id;

	-- Update the appointment place in the Appointment table to match the new room in Rooms
    UPDATE Appointments
    SET room_id = i.room_id
    FROM Appointments a
    INNER JOIN inserted i ON a.room_id = i.room_id;

	-- Update the Machine place in the Machines table to match the new room in Rooms
    UPDATE Machines
    SET room_id = i.room_id
    FROM Machines m
    INNER JOIN inserted i ON m.room_id = i.room_id;

	-- Update the Bed place in the Beds table to match the new room in Rooms
    UPDATE Beds
    SET room_id = i.room_id
    FROM Beds b
    INNER JOIN inserted i ON b.room_id = i.room_id;

END;*/



-- Updating Beds Related.
/*
CREATE TRIGGER UpdateBedsRelated
ON Beds
AFTER UPDATE
AS
BEGIN
    -- Update the operation place in the Patients table to match the new bed in Beds
    UPDATE Patients
    SET bed_id = i.bed_id
    FROM Patients p
    INNER JOIN inserted i ON p.bed_id = i.bed_id;

END;*/




-- Auto Assign Room for New Patients (a room with an empty bed) 

CREATE TRIGGER trg_AssignBedToNewPatient
ON Patients
AFTER INSERT
AS
BEGIN
    DECLARE @patient_id INT, @available_bed INT;

    SELECT @patient_id = patient_id
    FROM Inserted;

    SELECT TOP 1 @available_bed = bed_id
    FROM Beds
    WHERE is_available = 1 ;

    IF @available_bed IS NOT NULL
    BEGIN
        UPDATE Beds SET is_available = 0 WHERE bed_id = @available_bed;
        UPDATE Patients SET room_id = (SELECT room_id FROM Beds WHERE bed_id = @available_bed) WHERE patient_id = @patient_id;
    END
END;

exec AddNewPatient 'John' , 'Smith' , 'Mike' , '2024-01-01' , 'male', '01012345678'



-- check if both beds in a room are occupied, then mark the room as unavailable

CREATE TRIGGER trg_CheckRoomAvailability
ON Beds
AFTER UPDATE , INSERT
AS
BEGIN
    DECLARE @room_id INT, @occupied_count INT;

    SELECT @room_id = room_id
    FROM Inserted;

    SELECT @occupied_count = COUNT(*)
    FROM Beds
    WHERE room_id = @room_id AND is_available = 0;

    IF @occupied_count = 2
    BEGIN
        UPDATE Rooms
        SET is_available = 0
        WHERE room_id = @room_id;
    END

	IF @occupied_count = 0 or @occupied_count = 1
    BEGIN
        UPDATE Rooms
        SET is_available = 1
        WHERE room_id = @room_id;
    END
END;


-- discharge the patient when their beds have been available
CREATE TRIGGER trg_AutoDischargePatient
ON Beds
AFTER UPDATE
AS
BEGIN
    -- Check if at least one bed in the room is available
    IF EXISTS (
        SELECT 1
        FROM Inserted
        WHERE is_available = 1
    )
    BEGIN
        -- Update the patient status to 'Discharged' for the available bed(s)
        UPDATE Patients
        SET patient_status = 'Discharged'
        WHERE room_id IN (
            SELECT room_id
            FROM Inserted
            WHERE is_available = 1
        );
    END
END;

-- prevent negative salaries 

CREATE TRIGGER trg_PreventNegativeSalary
ON Employees
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Inserted WHERE salary < 0)
    BEGIN
        RAISERROR ('Salary cannot be negative.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;


-- prevent repeated email addresses for doctors

CREATE TRIGGER trg_PreventDuplicateEmail
ON Doctors
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Doctors WHERE email_address IN (SELECT email_address FROM Inserted))
    BEGIN
        RAISERROR ('Email already exists for another doctor.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

