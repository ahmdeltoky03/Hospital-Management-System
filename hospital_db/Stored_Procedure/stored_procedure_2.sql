-- --------- This file will not appear on the website, but it belongs to the HR of the hospital.

use HOSPITAL

--------------------------------------------------------------------------------------------------------
------------------------ Machine and Equipment Management ------------------------

-- a) Add New Machine
go 
CREATE PROCEDURE AddNewMachine
    @machine_name VARCHAR(50),
    @time_of_purchase DATE,
    @department_id INT = NULL,
    @room_id INT = NULL,
    @price INT,
    @about VARCHAR(255),
    @is_working BIT = 1
AS
BEGIN
    INSERT INTO Machines (machine_name, time_of_purchase, department_id, room_id, price, about, is_working)
    VALUES (@machine_name, @time_of_purchase, @department_id, @room_id, @price, @about, @is_working);
END;

--------------------------------------------------------------------------------------------------------


--b) Update Machine Status
go
CREATE PROCEDURE UpdateMachineStatus
    @machine_id INT,
    @is_working BIT -- 1 for operational, 0 for under maintenance
AS
BEGIN
    UPDATE Machines
    SET is_working = @is_working
    WHERE machine_id = @machine_id;
END;

--------------------------------------------------------------------------------------------------------

--c) Get Machines by Department

go
CREATE PROCEDURE GetMachinesByDepartment
    @department_id INT
AS
BEGIN
    SELECT machine_id, machine_name, time_of_purchase, price, about, is_working, room_id
    FROM Machines
    WHERE department_id = @department_id
    ORDER BY machine_name ASC;
END;

--------------------------------------------------------------------------------------------------------
------------------------ Billing and Payments --------------------------

-- a) Create New Bill
go
create PROCEDURE CreateNewBill
    @patient_id INT, 
    @billing_description VARCHAR(100) = NULL, 
    @billing_value DECIMAL(8, 2), 
    @payment_status VARCHAR(10) = 'pending', 
    @billing_date DATE, 
    @payment_method VARCHAR(20) 
AS
BEGIN
    -- Step 1: Validate ENUM-like constraints for `payment_status`.
    IF LOWER(@payment_status) NOT IN ('paid', 'pending', 'overdue')
    BEGIN
        RAISERROR ('Invalid payment_status. Must be "paid", "pending", or "overdue".', 16, 1);
        RETURN;
    END;

    -- Step 2: Validate ENUM-like constraints for `payment_method`.
    IF LOWER(@payment_method) NOT IN ('cash', 'credit', 'insurance', 'other')
    BEGIN
        RAISERROR ('Invalid payment_method. Must be "cash", "credit", "insurance", or "other".', 16, 1);
        RETURN;
    END;

    -- Step 3: Insert the new billing entry into the Billings table.
    INSERT INTO Billings ( patient_id, billing_description, billing_value, 
        payment_status, billing_date, payment_method
    )
    VALUES ( @patient_id, @billing_description, @billing_value, 
        @payment_status, @billing_date, @payment_method
    );

    -- Step 4: Provide a success message.
    PRINT 'New billing entry created successfully.';
END;


--------------------------------------------------------------------------------------------------------
--b) Get Patient Billing History
go

CREATE PROCEDURE GetPatientBillingHistory
    @patient_id INT
AS
BEGIN
    SELECT billing_id, billing_description, billing_value, payment_status, billing_date, payment_method
    FROM Billings
    WHERE patient_id = @patient_id
    ORDER BY billing_date DESC;
END;

--------------------------------------------------------------------------------------------------------

--c) Update Bill Payment Status
go

CREATE PROCEDURE UpdateBillPaymentStatus
    @billing_id INT,
    @payment_status VARCHAR(10) -- 'paid', 'pending', 'overdue'
AS
BEGIN
    UPDATE Billings
    SET payment_status = @payment_status
    WHERE billing_id = @billing_id;
END;


--------------------------------------------------------------------------------------------------------
----------------------- Room and Bed Management----------------------

-- a) Assign Room to Patient
go
CREATE PROCEDURE AssignRoomToPatient
    @patient_id INT,
    @room_id INT,
    @bed_id INT
AS
BEGIN
    UPDATE Patients
    SET room_id = @room_id, bed_id = @bed_id
    WHERE patient_id = @patient_id;

    UPDATE Beds
    SET is_available = 0
    WHERE bed_id = @bed_id;
END;


--------------------------------------------------------------------------------------------------------
--b) Release Room after Discharge
go

CREATE PROCEDURE ReleaseRoomAfterDischarge
    @patient_id INT
AS
BEGIN
    DECLARE @bed_id INT;

    SELECT @bed_id = bed_id
    FROM Patients
    WHERE patient_id = @patient_id;

    UPDATE Beds
    SET is_available = 1
    WHERE bed_id = @bed_id;

    UPDATE Patients
    SET room_id = NULL, bed_id = NULL
    WHERE patient_id = @patient_id;
END;



--------------------------------------------------------------------------------------------------------
go
-- Get Appointments By Date and Doctor
CREATE PROCEDURE GetAllAppoinmentsForDoctor
	@doctor_name varchar(60)
AS
	BEGIN
	SET NOCOUNT ON;
		
		select appointment_date as 'Dates', appointment_time as 'Times'
		from Appointments a
		where doctor_name = @doctor_name

	END;

