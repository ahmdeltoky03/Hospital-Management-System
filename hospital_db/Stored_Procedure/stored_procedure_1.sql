-- --------------- Stored Procedures -------------------- --

use HOSPITAL


-- ADD A NEW DOCTOR.
/*
 To add a new doctor I want {first_name, middle_name, last_name, date_of_birth, gender, 
 salary 'Initially --> salary he wants to take', hire_date 'we can take it from (GETDATE()) funcion',
 weekly_hours 'Initially --> hours he want to work per week', employee_address, phone_number, 
 department 'department he wants to work in " I can show him all the available department to take from "',
 experience, specialization, medical_license_number, email_address (must be gmail or yahoo). 
*/

go

CREATE PROCEDURE EmploymentOperationForDoctors
	@first_name varchar(20),
	@middle_name varchar(20),
	@last_name varchar(20),
	@date_of_birth date,
	@gender varchar(6),
	@salary decimal(10, 2),
	@weekly_hours int,
	@employee_address varchar(255),
	@phone_number varchar(20),
	@department varchar(100),
	@experience int,
	@specialization varchar(50),
	@medical_license_number varchar(50),
	@email_address varchar(100),

	@id_for_doctor int output

AS
	BEGIN
	SET NOCOUNT ON;

		insert into Employees (first_name, middle_name, last_name, date_of_birth, gender, salary, 
		weekly_hours, employee_address, phone_number)
		values (@first_name, @middle_name, @last_name, @date_of_birth, @gender, @salary, 
		@weekly_hours, @employee_address, @phone_number)

		-- Get the ID of the newly inserted employee.
		-- SCOPE_IDENTITY() returns the last identity value inserted into an identity column in the same scope.
		declare @new_doctor_id int;
		set @new_doctor_id = SCOPE_IDENTITY();

		declare @department_id int;
		select @department_id = department_id 
		from Departments 
		where department_name = @department
		
		insert into Doctors (doctor_id, department_id, experience, specialization, medical_license_number,
		email_address)
		values (@new_doctor_id, @department_id, @experience, @specialization, @medical_license_number, @email_address)
	
		set @id_for_doctor = @new_doctor_id
	END;


-- --------------------------------------------------------------------------------------------------------
-- ADD A NEW NURSE.
go

CREATE PROCEDURE EmploymentOperationForNurses
	@first_name varchar(20),
	@middle_name varchar(20),
	@last_name varchar(20),
	@date_of_birth date,
	@gender varchar(6),
	@salary decimal(10, 2),
	@weekly_hours int,
	@employee_address varchar(255),
	@phone_number varchar(20),
	@department varchar(100),
	@experience int,

	@id_for_nurse int output

AS
	BEGIN
	SET NOCOUNT ON;

		insert into Employees (first_name, middle_name, last_name, date_of_birth, gender, salary, 
		weekly_hours, employee_address, phone_number)
		values (@first_name, @middle_name, @last_name, @date_of_birth, @gender, @salary, 
		@weekly_hours, @employee_address, @phone_number)

		-- Get the ID of the newly inserted employee.
		-- SCOPE_IDENTITY() returns the last identity value inserted into an identity column in the same scope.
		declare @new_nurse_id int;
		set @new_nurse_id = SCOPE_IDENTITY();

		declare @department_id int;
		select @department_id = department_id 
		from Departments 
		where department_name = @department
		
		insert into Nursing (nurse_id, department_id, experience)
		values (@new_nurse_id, @department_id, @experience)

		set @id_for_nurse = @new_nurse_id
	END;




--------------------------------------------------------------------------------------------------------
-- ADD A NEW WORKER.
go

CREATE PROCEDURE EmploymentOperationForWorkers
	@first_name varchar(20),
	@middle_name varchar(20),
	@last_name varchar(20),
	@date_of_birth date,
	@gender varchar(6),
	@salary decimal(10, 2),
	@weekly_hours int,
	@employee_address varchar(255),
	@phone_number varchar(20),
	@worker_role varchar(100),

	@id_for_worker int output

AS
	BEGIN
	SET NOCOUNT ON;

		insert into Employees (first_name, middle_name, last_name, date_of_birth, gender, salary, 
		weekly_hours, employee_address, phone_number)
		values (@first_name, @middle_name, @last_name, @date_of_birth, @gender, @salary, 
		@weekly_hours, @employee_address, @phone_number)

		-- Get the ID of the newly inserted employee.
		-- SCOPE_IDENTITY() returns the last identity value inserted into an identity column in the same scope.
		declare @new_worker_id int;
		set @new_worker_id = SCOPE_IDENTITY();
		
		insert into Workers (worker_id, worker_role)
		values (@new_worker_id, @worker_role)

		set @id_for_worker = @new_worker_id
	END;




--------------------------------------------------------------------------------------------------------
-- Showing the details of an employee using his id.
go
CREATE PROCEDURE GetEmployeeDetails
@employee_id INT
AS
BEGIN
SET NOCOUNT ON;
	
	BEGIN TRY 
		IF @employee_id in (select employee_id from Employees)
		BEGIN
			SELECT * 
			FROM Employees
			WHERE employee_id = @employee_id;
			RETURN 0
		END
		ELSE
		BEGIN
			return 1
		END
	END TRY
	BEGIN CATCH
		RETURN 2
	END CATCH
END;
		
--------------------------------------------------------------------------------------------------------
-- Track employee absense
go
CREATE PROCEDURE TrackEmplyeeAbsense
@employee_id int,

@number_of_absense int output
AS
BEGIN
SET NOCOUNT ON;
	select @number_of_absense = count(employee_id) 
	from Absense 
	where employee_id = @employee_id

end
-- --------------------------------------------------------------------------------------------------------
go 
-- Add New Patient  --> Internal Procedure.

CREATE PROCEDURE AddNewPatient
    @first_name VARCHAR(20),
    @middle_name VARCHAR(20),
    @last_name VARCHAR(20),
    @date_of_birth DATE,
    @gender VARCHAR(6),
    @phone_number VARCHAR(11)
AS
BEGIN
    INSERT INTO Patients (first_name, middle_name, last_name, date_of_birth, gender, phone_number)
    VALUES (@first_name, @middle_name, @last_name, @date_of_birth, @gender, @phone_number);
END;

-- --------------------------------------------------------------------------------------------------------
-- Creating Appointment for a new patient.

go 

create PROCEDURE AddNewAppointmentForNewPatient
	@first_name VARCHAR(20),
    @middle_name VARCHAR(20),
    @last_name VARCHAR(20),
    @date_of_birth DATE,
    @gender VARCHAR(6),
    @phone_number VARCHAR(11),
	@doctor_name VARCHAR(60),
	@appointment_date date, 
	@appointment_time time,
	
	@id_returning_to_patient int output

AS
	BEGIN
	SET NOCOUNT ON;

		INSERT INTO Patients (first_name, middle_name, last_name, date_of_birth, gender, phone_number)
		VALUES (@first_name, @middle_name, @last_name, @date_of_birth, @gender, @phone_number);

		-- exec AddNewPatient  @first_name,  @middle_name, @last_name, @date_of_birth , @gender, @phone_number


		declare @patient_id int;
		set @patient_id = SCOPE_IDENTITY();

		declare @doctor_id int;
		select @doctor_id = employee_id 
		from Employees d 
		where d.first_name + ' ' + d.middle_name + ' ' + d.last_name = @doctor_name

		declare @doctor_phone int;
		select @doctor_phone = phone_number 
		from Employees
		where employee_id = @doctor_id

		declare @patient_name varchar(60);
		set @patient_name = @first_name + ' ' + @middle_name + ' ' + @last_name

		declare @room_id int;
		select @room_id = appointment_room
		from Doctors 
		where doctor_id = @doctor_id


		insert into Appointments (patient_id, patient_name, patient_phone_number,doctor_id, doctor_name,
		doctor_phone_number, room_id, appointment_date, appointment_time)
		values (@patient_id, @patient_name, @phone_number, @doctor_id, @doctor_name, @doctor_phone, @room_id,
		@appointment_date, @appointment_time)


		set @id_returning_to_patient = @patient_id
	END;



--------------------------------------------------------------------------------------------------------
-- Creating Appointment for an old patient.

go
CREATE PROCEDURE AddNewAppointmentForOldPatient  -- Inner Procedure
@id_from_patient int, 
@doctor_name VARCHAR(60),
@appointment_date date, 
@appointment_time time

AS
	BEGIN
	SET NOCOUNT ON;
		
		declare @patient_name varchar(60);
		set @patient_name = (select first_name + ' ' + middle_name + ' ' + last_name 
							from Patients where patient_id = @id_from_patient)

		declare @patient_phone_number int
		set @patient_phone_number = (select phone_number 
									from Patients where patient_id = @id_from_patient)

		declare @doctor_id int;
		select @doctor_id = employee_id 
		from Employees d 
		where d.first_name + ' ' + d.middle_name + ' ' + d.last_name = @doctor_name


		declare @doctor_phone int;
		select @doctor_phone = phone_number 
		from Employees
		where employee_id = @doctor_id


		declare @room_id int;
		select @room_id = appointment_room
		from Doctors 
		where doctor_id = @doctor_id

		insert into Appointments(patient_id, patient_name, patient_phone_number,
		doctor_id, doctor_name, doctor_phone_number, room_id, appointment_date, appointment_time)
		values 
		(@id_from_patient, @patient_name, @patient_phone_number, @doctor_id, @doctor_name,
		@doctor_phone, @room_id, @appointment_date, @appointment_time)
	END;

-- Checking if the id from the old patient is found in the database or not.
go 
CREATE PROCEDURE CheckingIdFromPatientDoingAppointment
@id_from_patient int,
@doctor_name VARCHAR(60),
@appointment_date date, 
@appointment_time time

AS
	BEGIN
	SET NOCOUNT ON;
		if @id_from_patient in (select patient_id from Patients)
		begin
			EXEC AddNewAppointmentForOldPatient @id_from_patient, @doctor_name, @appointment_date, @appointment_time
			return 0  
		end
		else
		begin
			return 1
		end
	END;


-- --------------------------------------------------------------------------------------------------------
-- TODO --> Trigger to take each new insertion for operation and show all the details about the 
--          operation then saving it in a csv file such that I complete the other information
--          of it later.

-- Creating Appointment for a new patient.
go 

create PROCEDURE AddNewOperationForNewPatient
	@first_name VARCHAR(20),
    @middle_name VARCHAR(20),
    @last_name VARCHAR(20),
    @date_of_birth DATE,
    @gender VARCHAR(6),
    @phone_number VARCHAR(11),
	@operation_about varchar(100),

	@id_returning_to_patient int output

AS
	BEGIN
	SET NOCOUNT ON;
		
		INSERT INTO Patients (first_name, middle_name, last_name, date_of_birth, gender, phone_number)
		VALUES (@first_name, @middle_name, @last_name, @date_of_birth, @gender, @phone_number);

		-- exec AddNewPatient  @first_name,  @middle_name, @last_name, @date_of_birth , @gender, @phone_number


		declare @patient_id int;
		set @patient_id = SCOPE_IDENTITY();

		declare @patient_name varchar(60);
		set @patient_name = @first_name + ' ' + @middle_name + ' ' +@last_name

		insert into Operations (operation_about, patient_id, patient_name, patient_phone_number, success)
		values (@operation_about, @patient_id, @patient_name, @phone_number, null)

		set @id_returning_to_patient = @patient_id

	END;


--------------------------------------------------------------------------------------------------------
-- Creating Operation for an old patient.
go

create PROCEDURE AddNewOperationForOldPatient  -- Inner Procedure
@id_from_patient int,
@operation_about varchar(100)
AS
	BEGIN
	SET NOCOUNT ON;

		declare @patient_name varchar(60);
		set @patient_name = (select first_name + ' ' + middle_name + ' ' + last_name 
							from Patients where patient_id = @id_from_patient)

		declare @patient_phone_number int
		set @patient_phone_number = (select phone_number 
									from Patients where patient_id = @id_from_patient)

		insert into Operations (operation_about, patient_id, patient_name, patient_phone_number, success)
		values (@operation_about, @id_from_patient, @patient_name, @patient_phone_number, null)
END;

-- Checking if the id from the old patient is found in the database or not.	

go 
create PROCEDURE CheckingIdFromPatientDoingOperation
@id_from_patient int,
@operation_about varchar (100)

AS
BEGIN
SET NOCOUNT ON;
	if @id_from_patient in (select patient_id from Patients)
	begin
		EXEC AddNewOperationForOldPatient @id_from_patient, @operation_about
		return 0  
	end
	else
	begin
		return 1
	end
END;


--------------------------------------------------------------------------------------------------------
-- Showing the details of a patient using his id.
go
CREATE PROCEDURE GetPatientDetails
@patient_id INT
AS
BEGIN
SET NOCOUNT ON;
	
	BEGIN TRY 
		IF @patient_id in (select patient_id from Patients)
		BEGIN
			SELECT * 
			FROM Patients
			WHERE patient_id = @patient_id;
			RETURN 0
		END
		ELSE
		BEGIN
			return 1
		END
	END TRY
	BEGIN CATCH
		RETURN 2
	END CATCH
END;
		
--------------------------------------------------------------------------------------------------------
-- Creating a procedure to visit a patient.
go
CREATE PROCEDURE VisitingPatient
@patient_id int,
@number_of_visitors int,
@visit_date date,

@id_of_visit int output

AS
BEGIN
SET NOCOUNT ON;
	if @patient_id in (select patient_id from Patients)
	begin
		insert into Visits(patient_id, visit_date, visitors_number)
		values(@patient_id, @visit_date, @number_of_visitors)

		declare @visit_id int;
		set @visit_id = SCOPE_IDENTITY();

		set @id_of_visit = @visit_id
		return 0
	end
	else
	begin
		return 1
	end
end



--------------------------------------------------------------------------------------------------------
-- Knowing the billing on the patient
go
CREATE PROCEDURE BillingOnPatient
@patient_id int

AS
BEGIN
SET NOCOUNT ON;
	select * from Billings
	where patient_id = @patient_id
	order by billing_date DESC

end

--------------------------------------------------------------------------------------------------------
-- --------- Pages -----------
/*
1) Appointments And Operations (AddNewOperationForOldPatient, AddNewOperationForNewPatient,
								AddNewAppointmentForOldPatient, AddNewAppointmentForNewPatient)

2)Patients Helper (BillingOnPatient, VisitingPatient, GetPatientDetails)

3) Employment (EmploymentOperationForWorkers, EmploymentOperationForNurses,
				 EmploymentOperationForDoctors)

*/


-- New 
-- 1 ) GetVisitorNumber for each patiwnt
-- 2 ) GetVisitorsPerDay (all visitors per day)
-- 3 ) GetNumberOfRoomsForEachDepartment
-- 4 ) GetNumberOfWorkingMachineForEachDepartment
-- 5 ) GetDoctorAndNursingForEachDepartment
-- 6 ) GetTotalBillForEachDepartment
-- 7 ) GetDocNameAndNumOfOperations
-- 8 ) GetNumOfAppForEachdept
-- 9 ) GetAvailableBedsForEachDept
-- 10 ) GetInfoAboutDepartments
-- 11 ) CalculateAvgWeeklyHoursForEachDept
-- 12 ) CalculateAvgSalaryForEachDept
-- 13 ) CalculateMaxPRForEachDept
--------------------------------------------------------------------------------------------------------
-- know number of visitors for each patient
go
create procedure GetVisitorNumber
@patient_id int

AS
BEGIN
	if not exists (
		select 1 
		from Visits
		where patient_id = @patient_id
	
	)
	Begin
		-- patient is not exist
		print('Patient is not found.')
	End

	else
	    -- patient is exist
	Begin
	select visitors_number
	from Visits
	where patient_id = @patient_id
	End
End;

exec GetVisitorNumber 105 
exec GetVisitorNumber 300 /*Patient is not found.*/
--------------------------------------------------------------------------------------------------------
-- know number of vistors for each day
go
create procedure GetVisitorsPerDay
As
Begin
	select visit_date,sum(visitors_number) as NumberOfVisitors from Visits
	group by visit_date
	order by visit_date
End

exec GetVisitorsPerDay

--------------------------------------------------------------------------------------------------------
-- Know number of rooms for each Department
go
create procedure GetNumberOfRoomsForEachDepartment
As
Begin
	select department_id,COUNT(*) as NumberOfRooms
	from Rooms
	group by department_id
	order by NumberOfRooms Desc
End

exec GetNumberOfRoomsForEachDepartment
--------------------------------------------------------------------------------------------------------

/* The procedure retrieve the number of working machines for each department. */
go
create procedure GetNumberOfWorkingMachineForEachDepartment
As
Begin
	select M.department_id,count(M.is_working) as NumberOfWorkingMachine
	from Machines M 
	inner join Departments D
	on M.department_id = D.department_id
	where is_working = 1
	group by M.department_id
End

exec GetNumberOfWorkingMachineForEachDepartment

--------------------------------------------------------------------------------------------------------
/* The procedure show  number of available beds for each department. */
go
create procedure GetAvailableBedsForEachDept
As
Begin
	select R.department_id,COUNT(B.bed_id) AvailableBeds
	from Beds B 
	inner join Rooms R
	on B.room_id = R.room_id
	where B.is_available = 1
	group by R.department_id
	order By AvailableBeds Desc
End

exec GetAvailableBedsForEachDept

--------------------------------------------------------------------------------------------------------
go
-- procedure to know Number Of Doctors And Nurses For Each Department
create procedure GetDoctorAndNursingForEachDepartment
As
Begin
	SELECT D.department_id,
		   COUNT(DISTINCT Dr.doctor_id) AS NumberOfDoctors,
           COUNT(DISTINCT N.nurse_id) AS NumberOfNurses
    FROM Departments D
    LEFT JOIN Doctors Dr ON D.department_id = Dr.department_id
    LEFT JOIN Nursing N ON D.department_id = N.department_id
    GROUP BY D.department_id;
End

exec GetDoctorAndNursingForEachDepartment

--------------------------------------------------------------------------------------------------------
-- This procedure retrieve the total bill amount for each department.
go
create procedure GetTotalBillForEachDepartment
As
Begin
	select D.department_id,sum(B.billing_value) as TotalBillForDepartment 
	from Billings B 
	inner join Patients P 
	on B.patient_id = P.patient_id
	inner join Rooms R
	on P.room_id = R.room_id
	inner join Departments D
	on D.department_id = R.department_id
	group by D.department_id
End

exec GetTotalBillForEachDepartment

--------------------------------------------------------------------------------------------------------

-- this prodcedure retrieve number of appointments for each department 
go
create Procedure GetNumOfAppForEachdept
As
Begin
	select department_id,count(*) NumberOfAppointment from Appointments
	group by department_id
	order by NumberOfAppointment Desc
End

exec GetNumOfAppForEachdept

--------------------------------------------------------------------------------------------------------

/*
this procedure retrieve department name,
doctor's name and number of operations (not total number) for each doctor.
there exist another procedure to knpw total number of operations for each doctor -->> GetDocNameAndNumOfOperations
*/
/*
create Procedure GetInfoAboutDepartments
As 
Begin
	SELECT 
		Dept.department_name,
		(E.first_name + ' ' + E.middle_name + ' ' + E.last_name) as doctor_name,
		COUNT(OD.operation_id) as NumberOfOperations
	FROM Doctors D
	inner join Employees E
		on D.doctor_id = E.employee_id
	inner join OperationDoctors OD 
		on OD.doctor_id = E.employee_id
	inner join Departments Dept 
		on D.department_id = Dept.department_id
	group by
		Dept.department_id, 
		Dept.department_name,
		E.first_name,
		E.middle_name,
		E.last_name
	order by
		Dept.department_id, 
		NumberOfOperations desc
End
select * from Doctors

exec GetInfoAboutDepartments
*/

--------------------------------------------------------------------------------------------------------
/*
this procedure calculates average weekly hours for doctors in each department.

*/
go
create procedure CalculateAvgWeeklyHoursForEachDept
As 
Begin
	select Dept.department_name,Avg(E.weekly_hours) as Avg_Weekly_Hours
	from Employees E
	inner join Doctors D
	on D.doctor_id = E.employee_id
	inner join Departments Dept
	on Dept.department_id = D.department_id
	group by Dept.department_name
	order by Avg_Weekly_Hours Desc
End

exec CalculateAvgWeeklyHoursForEachDept

--------------------------------------------------------------------------------------------------------

/*
this procedure calculate Average doctor's salaries for each department.

*/
create procedure CalculateAvgSalaryForEachDept
As 
Begin
	select Dept.department_name,Avg(E.salary) as Avg_Salary
	from Employees E
	inner join Doctors D
	on D.doctor_id = E.employee_id
	inner join Departments Dept
	on Dept.department_id = D.department_id
	group by Dept.department_name
	order by Avg_Salary Desc
End

exec CalculateAvgSalaryForEachDept

select * from Employees
select * from Departments
select * from Doctors

--------------------------------------------------------------------------------------------------------

/*
this procedure calculate maximum doctors performance rate in each department.
Performance Rate -->> PR
*/
create procedure CalculateMaxPRForEachDept
As 
Begin
	select Dept.department_name,max(E.performance_rating) as Max_Performance_Rate
	from Employees E
	inner join Doctors D
	on D.doctor_id = E.employee_id
	inner join Departments Dept
	on Dept.department_id = D.department_id
	group by Dept.department_name
	order by Max_Performance_Rate Desc
End

exec CalculateMaxPRForEachDept


