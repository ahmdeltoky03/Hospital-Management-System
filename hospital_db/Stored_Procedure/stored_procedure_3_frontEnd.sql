use HOSPITAL

go


---------- These Procedures for Machines which are find in the Front End --------------------------

-- get all machines.

create procedure GetAllMachines
	as
	begin
	SET NOCOUNT ON;
		SELECT machine_id,
					machine_name, 
					time_of_purchase, 
					(
						SELECT department_name 
						FROM Departments 
						WHERE Departments.department_id = Machines.department_id
					) as department_name,
					(
						select room_number
						from Rooms
						where Rooms.room_id = Machines.room_id
					) as room_number,
					price, 
					about, 
					is_working 
				FROM Machines
	end
--------------------------------------------------------------------------------

-- get machine by its id
go
create procedure GetMachineByItsID
	@machine_id int
as
begin 
set nocount on;
	SELECT machine_id,
            machine_name, 
            time_of_purchase, 
            (
                SELECT department_name 
                FROM Departments 
                WHERE Departments.department_id = Machines.department_id
            ) as department_name,
            (
                select room_number
                from Rooms
                where Rooms.room_id = Machines.room_id
            ) as room_number,
            price, 
            about, 
            is_working 
        FROM Machines
        WHERE machine_id = @machine_id

end
--------------------------------------------------------------------------------

-- get machine by its name
go
create procedure GetMachineByItsName
	@machine_name varchar(50)
as
begin 
set nocount on;
	SELECT machine_id,
		machine_name, 
		time_of_purchase, 
		(
			SELECT department_name 
			FROM Departments 
			WHERE Departments.department_id = Machines.department_id
		) AS department_name,
		(
			SELECT room_number
			FROM Rooms
			WHERE Rooms.room_id = Machines.room_id
		) AS room_number,
		price, 
		about, 
		is_working 
	FROM Machines
	where machine_name = @machine_name

end


--------------------------------------------------------------------------------

-- get machines by department name.
go
create procedure GetMachinesByDepartmentName
@department_name varchar(60)

as
begin
set nocount on;
	SELECT machine_id,
            machine_name, 
            time_of_purchase, 
            (
                SELECT department_name 
                FROM Departments 
                WHERE Departments.department_id = Machines.department_id
            ) AS department_name,
            (
                SELECT room_number
                FROM Rooms
                WHERE Rooms.room_id = Machines.room_id
            ) AS room_number,
            price, 
            about, 
            is_working 
        FROM Machines
        where department_id = (select department_id from Departments where Departments.department_name = @department_name)
            
end



--------------------------------------------------------------------------------

-- get machines by roomNumber.
go
create procedure GetMachinesByRoomNumber
@room_number varchar(10)

as 
begin
set nocount on;
	SELECT machine_id,
            machine_name, 
            time_of_purchase, 
            (
                SELECT department_name 
                FROM Departments 
                WHERE Departments.department_id = Machines.department_id
            ) AS department_name,
            (
                SELECT room_number
                FROM Rooms
                WHERE Rooms.room_id = Machines.room_id
            ) AS room_number,
            price, 
            about, 
            is_working 
        FROM Machines
        where room_id = (select room_id from Rooms where Rooms.room_number = @room_number)

end
     


--------------------------------------------------------------------------------

-- get machines by Case Of Working.

go
create procedure GetMachinesByCaseOfWork
@is_working bit

as 
begin
set nocount on;
	SELECT machine_id,
            machine_name, 
            time_of_purchase, 
            (
                SELECT department_name 
                FROM Departments 
                WHERE Departments.department_id = Machines.department_id
            ) AS department_name,
            (
                SELECT room_number
                FROM Rooms
                WHERE Rooms.room_id = Machines.room_id
            ) AS room_number,
            price, 
            about, 
            is_working 
        FROM Machines
        WHERE is_working = @is_working
end
       
-----------------------------------------------------------
-- Upadate Machines
go
create procedure UpdateMachines
@machine_id int,
@updated_name varchar(50),
@time_of_purchase date,
@department_name int,
@room_number int,
@price int,
@about varchar(255),
@is_working bit
as
begin
set nocount on
	UPDATE machines
        SET machine_name = @updated_name, 
            time_of_purchase = @time_of_purchase, 
            department_id = (SELECT department_id FROM departments WHERE department_name = @department_name),
            room_id = (SELECT room_id FROM rooms WHERE room_number = @room_number),
            price = @price, 
            about = @about, 
            is_working = @is_working
        WHERE machine_id = @machine_id
end

---------- These Procedures for Departments which are find in the Front End --------------------------  

-- Inserting a new department.
go
create Procedure NewDepartment
@department_name varchar(60),
@department_description varchar(100),
@head_of_deaprtment int

as 
begin
set nocount on;
	INSERT INTO Departments (department_name, department_description, head_of_department)
          VALUES (@department_name, @department_description, @head_of_deaprtment)

end
        
-------------------------------------------
-- Getting all departments
go
create procedure GetAllDepartments 

as 
begin
set nocount on;
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
    FROM Departments;
end


 -------------------------------------------
-- Getting all departments

go
create procedure GetDepartmentByItsName
@department_name varchar(60)

as 
begin 
set nocount on
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
	WHERE departments.department_name = @department_name     
end


 -------------------------------------------
-- Getting Department by Head ID

go
create procedure GetDepartmentByHeadID
@head_id int
as
begin
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
    WHERE departments.head_of_department = @head_id
end


 -------------------------------------------
-- Get Department by Head Name

go
create procedure GetDepartmentByHeadName
@head_name varchar(60)
as
begin
	SELECT 
        department_id,
        department_name,
        department_description,
        head_of_department,
        CONCAT(first_name, ' ', middle_name, ' ', last_name) AS head_name
    FROM departments
    JOIN employees ON employees.employee_id = departments.head_of_department
    WHERE CONCAT(first_name, ' ', middle_name, ' ', last_name) = @head_name
            
end


---------- These Procedures related to patients which are find in the Front End --------------------------  

-- Getting all patients.
go
create procedure GetAllPatients
as 
begin
set nocount on;
	select patient_id,
            first_name,
            middle_name,
            last_name,
            date_of_birth,
            gender,
            patient_entry_date,
            phone_number,
            (select room_number from rooms where rooms.room_id = patients.room_id) as room_number,
            (select bed_number from beds where beds.bed_id = patients.bed_id) as bed_number,
            patient_status
        from patients
end



----------------------------------------------------------------
-- Get Patients with id.
go
create procedure GetPatientsWithID
@patient_id int
as
begin
set nocount on
	select patient_id,
            first_name,
            middle_name,
            last_name,
            date_of_birth,
            gender,
            patient_entry_date,
            phone_number,
            (select room_number from rooms where rooms.room_id = patients.room_id) as room_number,
            (select bed_number from beds where beds.bed_id = patients.bed_id) as bed_number,
            patient_status
        from patients
        where patient_id = @patient_id
end

----------------------------------------------------------------
-- Get Patients with first name.
go
create procedure GetPatientsWithFirstName
@first_name varchar(20)
as
begin
set nocount on
	select patient_id,
        first_name,
        middle_name,
        last_name,
        date_of_birth,
        gender,
        patient_entry_date,
        phone_number,
        (select room_number from rooms where rooms.room_id = patients.room_id) as room_number,
        (select bed_number from beds where beds.bed_id = patients.bed_id) as bed_number,
        patient_status
    from patients
    where patients.first_name = @first_name
end


----------------------------------------------------------------
-- Get Patients with full name.
go
create procedure GetPatientsWithFullName
@full_name varchar(60)
as
begin
set nocount on
	select patient_id,
        first_name,
        middle_name,
        last_name,
        date_of_birth,
        gender,
        patient_entry_date,
        phone_number,
        (select room_number from rooms where rooms.room_id = patients.room_id) as room_number,
        (select bed_number from beds where beds.bed_id = patients.bed_id) as bed_number,
        patient_status
    from patients
    where concat(first_name, ' ', middle_name, ' ', last_name) = @full_name
           
end


----------------------------------------------------------------
-- Get Patients with date of birth.
go
create procedure GetPatientsWithDateOfBirth
@date_of_birth date
as
begin
set nocount on
	select patient_id,
        first_name,
        middle_name,
        last_name,
        date_of_birth,
        gender,
        patient_entry_date,
        phone_number,
        (select room_number from rooms where rooms.room_id = patients.room_id) as room_number,
        (select bed_number from beds where beds.bed_id = patients.bed_id) as bed_number,
        patient_status
    from patients
    where date_of_birth = @date_of_birth
end



----------------------------------------------------------------
-- Get Patients with gender
go
create procedure GetPatientsWithGender
@gender varchar(6)
as
begin
set nocount on
	select patient_id,
        first_name,
        middle_name,
        last_name,
        date_of_birth,
        gender,
        patient_entry_date,
        phone_number,
        (select room_number from rooms where rooms.room_id = patients.room_id) as room_number,
        (select bed_number from beds where beds.bed_id = patients.bed_id) as bed_number,
        patient_status
    from patients
    where gender = @gender
end


----------------------------------------------------------------
-- Get Patients with phone number.
go
create procedure GetPatientsWithPhoneNumber
@phone_number varchar(11)
as
begin
set nocount on
	select patient_id,
            first_name,
            middle_name,
            last_name,
            date_of_birth,
            gender,
            patient_entry_date,
            phone_number,
            (select room_number from rooms where rooms.room_id = patients.room_id) as room_number,
            (select bed_number from beds where beds.bed_id = patients.bed_id) as bed_number,
            patient_status
        from patients
        where phone_number = @phone_number
end


----------------------------------------------------------------
-- Get Patients with ROOM number.
go
create procedure GetPatientsWithRoomNumber
@room_number varchar(10)
as
begin
set nocount on
	select patient_id,
		first_name,
		middle_name,
		last_name,
		date_of_birth,
		gender,
		patient_entry_date,
		phone_number,
		(select room_number from rooms where rooms.room_id = patients.room_id) as room_number,
		(select bed_number from beds where beds.bed_id = patients.bed_id) as bed_number,
		patient_status
	from patients
	where room_id = (select room_id from Rooms where Rooms.room_number = @room_number)
end



----------------------------------------------------------------
-- Get Patients with bed number.
go
create procedure GetPatientsWithBedNumber
@bed_number varchar(10)
as
begin
set nocount on
	select patient_id,
			first_name,
			middle_name,
			last_name,
			date_of_birth,
			gender,
			patient_entry_date,
			phone_number,
			(select room_number from rooms where rooms.room_id = patients.room_id) as room_number,
			(select bed_number from beds where beds.bed_id = patients.bed_id) as bed_number,
			patient_status
		from patients
		where bed_id = (select bed_id from Beds where Beds.bed_number = @bed_number)
end

---------------------------------------------
-- Update Patients
go
create procedure UpdatePatients
@patient_id int,
@first_name varchar(20),
@middle_name varchar(20),
@last_name varchar(20),
@date_of_birth date,
@gender varchar(6),
@patient_entry_date date,
@phone_number varchar(11),
@room_number int,
@bed_number int,
@patient_status varchar(200)

as 
begin
set nocount on
	UPDATE patients
        SET first_name = @first_name, 
            middle_name = @middle_name, 
            last_name = @last_name,
            date_of_birth = @date_of_birth,
            gender = @gender, 
            patient_entry_date = @patient_entry_date, 
            phone_number = @phone_number,
            room_id = (select room_id from Rooms where Rooms.room_number = @room_number),
            bed_id = (select bed_id from Beds where Beds.bed_number = @bed_number),
            patient_status = @patient_entry_date
        WHERE patient_id = @patient_id
end

---------- These Procedures related to Rooms which are find in the Front End --------------------------  
-- Getting All Rooms

go
create procedure GetAllRooms
as
begin
set nocount on
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
end



--------------------------------------------------
-- Getting room by its id

go
create procedure GetRoomByID
@room_id int
as
begin
set nocount on
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
    WHERE room_id = @room_id
end


--------------------------------------------------
-- Getting room by its number

go
create procedure GetRoomByNumber
@room_number varchar(10)
as
begin
set nocount on
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
        WHERE room_number = @room_number
end


--------------------------------------------------
-- Getting room by department

go
create procedure GetRoomByDepartment
@department_name varchar(100)
as
begin
set nocount on
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
            WHERE department_name = @department_name)
end

--------------------------------------------------
-- Getting room by Availability

go
create procedure GetRoomByAvailability
@is_available bit
as
begin
set nocount on
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
            WHERE is_available = @is_available
end


------------------------------------------------
-- Update Rooms
go
create procedure UpdateRooms
@room_number varchar(10),
@room_length decimal(5, 2),
@room_width decimal(5, 2),
@department_name varchar(50),
@is_available bit,
@room_id int

as
begin
set nocount on
	UPDATE rooms
    SET room_number = @room_number, 
        room_length = @room_length,
        room_width = @room_length, 
        department_id = (SELECT department_id FROM departments WHERE department_name = @department_name),
        is_available = @is_available
    WHERE room_id = @room_id
end

---------- These Procedures related to Visits which are find in the Front End --------------------------
-- Get All Visits
go
create procedure GetAllVisits
as
begin
set nocount on
	select
        visit_id,
        CONCAT(P.first_name, ' ', P.middle_name, ' ', P.last_name) AS patient_name,
        V.visit_date,
        V.visitors_number
    from Visits V
    join Patients P ON V.patient_id = P.patient_id;  
end

exec GetAllVisits
----------------------------------------------------------
-- Get Visits Date
go
alter procedure GetVisitsByDate
@visit_date date
as
begin
set nocount on
	select
        visit_id,
        CONCAT(P.first_name, ' ', P.middle_name, ' ', P.last_name) AS patient_name,
        V.visit_date,
        V.visitors_number
    from Visits V
    join Patients P ON V.patient_id = P.patient_id and V.visit_date = @visit_date;
end
exec GetVisitsByDate '2024-12-01'

select * from Visits where visit_date = '2024-12-01'

----------------------------------------------------------
-- Update Visits
go
alter procedure UpdateVisits
@visit_id int,
@patient_name varchar(100),
@visit_date date,
@visitors_number int

as 
begin
set nocount on
	declare @pat_id int
	select @pat_id = patient_id
	from Patients P
	where p.first_name+' '+p.middle_name+' '+p.last_name = @patient_name


	
    update Visits
	set patient_id = @pat_id,
		visit_date = @visit_date,
		visitors_number = @visitors_number
	where visit_id = @visit_id
end

----------------------------------------------------------
-- AddNewBilling

alter procedure AddNewBilling
@patient_name varchar(60),
@billing_description  varchar(200),
@billing_value  decimal(8, 2),
@billing_date date,
@payment_status varchar(10),
@payment_method varchar(20)

as
begin
declare @pat_id int
select @pat_id = patient_id
from Patients P
where CONCAT(p.first_name + ' '+p.middle_name+' ',p.last_name) = @patient_name

insert into Billings values (
	@pat_id,@billing_description,@billing_value,@payment_status,@billing_date,@payment_method)
end

------------------------------------------------------------------------

select * from Visits

create procedure AddNewVisit
@patient_name varchar(50),
@visit_date date,
@visitors_number int
as
begin
declare @pat_id int
select @pat_id = patient_id
from Patients p
where p.first_name+' '+p.middle_name+' '+p.last_name = @patient_name

insert into Visits values
(@pat_id,@visit_date,@visitors_number)

end



------------------------------------------------------------------------

alter procedure AddNewAbsence
@absense_name varchar(200),
@absense_date date,
@reason varchar(30),
@absense_status varchar(10),
@approved_by varchar(200)

as 
begin
declare @emp_id int
select @emp_id = employee_id
from Employees E
where E.first_name+' '+E.middle_name+' '+E.last_name = @absense_name

declare @approved_by_id int
select @approved_by_id = employee_id 
from Employees E
where E.first_name+' '+E.middle_name+' '+E.last_name = @approved_by


insert into Absense values (@emp_id,@absense_date,@reason,@absense_status,@approved_by_id)
end

exec AddNewAbsence 'Fatima Mohamed Hassan','12-12-2024','Sick Leave','approved','Ahmed Ali Al-Sayed'

------------------------------------------------------------------------

alter procedure UpdateAbsence
@absense_id int,
@absence_reason varchar(100)
as
begin

update Absense
set reason = @absence_reason
where absense_id = @absense_id

end
select * from Absense



exec UpdateAbsence 100,'Personal Reasons'


------------------------------------------------------------------------
alter procedure AddNewOperation
@about varchar(200),
@patient_name varchar(50),
@pat_pnum varchar(11),
@dept_name varchar(20),
@room_num varchar(20),
@oper_start time(7),
@oper_end time(7),
@success bit
as 
begin

declare @pat_id int
select @pat_id = patient_id
from Patients p
where p.first_name+' '+p.middle_name+' '+p.last_name=@patient_name

declare @dept_id int
select @dept_id = d.department_id
from Departments d
where d.department_name = @dept_name

declare @room_id int
select @room_id = r.room_id
from Rooms r
where r.room_number = @room_num

declare @oper_date date
set @oper_date = CAST(GETDATE() as Date)

insert into Operations (operation_about,patient_id,patient_name,patient_phone_number,
						department_id,room_id,operation_date,operation_start_time,operation_end_time,success)
values (
@about,@pat_id,@patient_name,@pat_pnum,@dept_id,@room_id,@oper_date,@oper_start,@oper_end,@success
)
end

select * from Operations
select * from Patients 
select * from Rooms
exec AddNewOperation 'Heart Surgery','Ahmed Mohamed Ali','1122334455','Oncology','R108','08:30:00.0000000','10:30:00.0000000',1

------------------------------------------------------------------------
create procedure GetAllOperations
as
begin

select 
    o.patient_name as patient_name,
	o.operation_about as operation_about,
    o.patient_phone_number as patient_phone_number,
    d.department_name as department_name,
    r.room_number as room_number,
    o.success as success
FROM operations o join Departments d
on o.department_id = d.department_id
join patients p
on p.patient_id = o.patient_id
join rooms r
on r.room_id = o.room_id
end

exec GetAllOperations
------------------------------------------------------------------------
alter procedure GetOperationsByPatientName
@patient_name varchar(200)
as
begin

select 
    o.patient_name as patient_name,
	o.operation_about as operation_about,
    o.patient_phone_number as patient_phone_number,
    d.department_name as department_name,
    r.room_number as room_number,
    o.success as success
FROM operations o join Departments d
on o.department_id = d.department_id
join patients p
on p.patient_id = o.patient_id
join rooms r
on r.room_id = o.room_id
WHERE o.patient_name = @patient_name
end

exec GetOperationsByPatientName 'Ahmed Mohamed Ali'
----------------------------------------------------------------------------

alter procedure GetOperationsByDepartment
@Department_name varchar(200)
as
begin

select 
    o.patient_name as patient_name,
	o.operation_about as operation_about,
    o.patient_phone_number as patient_phone_number,
    d.department_name as department_name,
    r.room_number as room_number,
    o.success as success
FROM operations o join Departments d
on o.department_id = d.department_id
join patients p
on p.patient_id = o.patient_id
join rooms r
on r.room_id = o.room_id
WHERE d.department_name = @Department_name
end

exec GetOperationsByDepartment 'Oncology'

----------------------------------------------------------------------------

alter procedure GetOperationsByRoomNum
@room_num varchar(200)
as
begin

select 
    o.patient_name as patient_name,
	o.operation_about as operation_about,
    o.patient_phone_number as patient_phone_number,
    d.department_name as department_name,
    r.room_number as room_number,
    o.success as success
FROM operations o join Departments d
on o.department_id = d.department_id
join patients p
on p.patient_id = o.patient_id
join rooms r
on r.room_id = o.room_id
WHERE r.room_number = @room_num
end

exec GetOperationsByRoomNum 'R101'

----------------------------------------------------------------------------


alter procedure GetOperationsByOperationAbout
@about varchar(200)
as
begin

select 
	o.patient_name as patient_name,
	o.operation_about as operation_about,
    o.patient_phone_number as patient_phone_number,
    d.department_name as department_name,
    r.room_number as room_number,
    o.success as success
FROM operations o join Departments d
on o.department_id = d.department_id
join patients p
on p.patient_id = o.patient_id
join rooms r
on r.room_id = o.room_id
WHERE o.operation_about = @about
end

exec GetOperationsByOperationAbout 'Heart Surgery'

----------------------------------------------------------------------------

alter procedure GetOperationsBySuccess
@val int -- 0 or 1
as
begin

select 
	o.patient_name as patient_name,
	o.operation_about as operation_about,
    o.patient_phone_number as patient_phone_number,
    d.department_name as department_name,
    r.room_number as room_number,
    o.success as success
FROM operations o join Departments d
on o.department_id = d.department_id
join patients p
on p.patient_id = o.patient_id
join rooms r
on r.room_id = o.room_id
WHERE o.success = @val
end

exec GetOperationsBySuccess 0

----------------------------------------------------------------------------

create procedure GetOperationsByPatientPhoneNumber
@phone_num varchar(11)
as
begin

select 
	o.patient_name as patient_name,
	o.operation_about as operation_about,
    o.patient_phone_number as patient_phone_number,
    d.department_name as department_name,
    r.room_number as room_number,
    o.success as success
FROM operations o join Departments d
on o.department_id = d.department_id
join patients p
on p.patient_id = o.patient_id
join rooms r
on r.room_id = o.room_id
WHERE o.patient_phone_number = @phone_num
end 

exec GetOperationsByPatientPhoneNumber '1122334455'


select * from Operations

----------------------------------------------------------------------------

create procedure AddNewRoom
@room_num varchar(10),
@room_length float,
@room_width float,
@dept_name varchar(30),
@is_available bit 
as
begin
declare @dept_id int
select @dept_id = D.department_id
from Departments D
where D.department_name = @dept_name

insert into Rooms (room_number,room_length,room_width,department_id,is_available)
           values (@room_num,@room_length,@room_width,@dept_id,@is_available)
end

exec AddNewRoom 'R108',5.00,5.00,'Cardiology',1
select * from Rooms

----------------------------------------------------------------------------

alter procedure AddNewDepartment
@department_name varchar(40),
@department_description varchar(200),
@head_of_department varchar(50)
as
begin
declare @head_id int
select @head_id = E.employee_id
from Employees E
where E.first_name+' '+E.middle_name+' '+E.last_name = @head_of_department 

insert into Departments (department_name,department_description,head_of_department)
				values   (@department_name,@department_description,@head_id)
end



exec AddNewDepartment 'Histology','Tissue examination and microscopic analysis for diagnosing diseases.','Ahmed Ali Al-Sayed'


----------------------------------------------------------------------------


create procedure GetPatientsWithStatus
@patient_status varchar(20)
as
begin
set nocount on
	select patient_id,
            first_name,
            middle_name,
            last_name,
            date_of_birth,
            gender,
            patient_entry_date,
            phone_number,
            (select room_number from rooms where rooms.room_id = patients.room_id) as room_number,
            (select bed_number from beds where beds.bed_id = patients.bed_id) as bed_number,
            patient_status
        from patients
        where patient_status = @patient_status
end

exec GetPatientsWithStatus 'Under Observation' 
select * from Patients
----------------------------------------------------------------

create procedure GetAllEmployees
as
begin
select  M.first_name as first_name,
		M.middle_name as middle_name,
		M.last_name as last_name,
		M.date_of_birth as date_of_birth,
		M.gender as gender,
		M.salary as salary,
		M.hire_date as hire_date,
		M.weekly_hours as weekly_hours,
		M.employee_address as address,
		M.phone_number as phone_number,
		CONCAT(M.first_name, ' ', M.middle_name, ' ', M.last_name) AS manager_name,
		M.performance_rating as performance_rate  
		FROM Employees E
		INNER JOIN 
        Employees M ON E.manager_id = M.employee_id;
end

exec GetAllEmployees

select * from Employees

/*
first_name
full name
date_of_birth
gender -- filteration
hire_date
weekly_hours
address using like 
phone_number

*/

----------------------------------------------------------------

alter procedure GetEmployeesWithFirstName
@first_name varchar(20)
as
begin
select distinct * from
(select  M.first_name as first_name,
		M.middle_name as middle_name,
		M.last_name as last_name,
		M.date_of_birth as date_of_birth,
		M.gender as gender,
		M.salary as salary,
		M.hire_date as hire_date,
		M.weekly_hours as weekly_hours,
		M.employee_address as address,
		M.phone_number as phone_number,
		CONCAT(M.first_name, ' ', M.middle_name, ' ', M.last_name) AS manager_name,
		M.performance_rating as performance_rate  
		FROM Employees E
		INNER JOIN 
        Employees M ON E.manager_id = M.employee_id and M.first_name = @first_name ) as F
end

exec GetEmployeesWithFirstName 'Rami'
----------------------------------------------------------------
alter procedure GetEmployeesWithFullName
@full_name varchar(100)
as
begin
select distinct * from
(select  
		M.first_name as first_name,
		M.middle_name as middle_name,
		M.last_name as last_name,
		M.date_of_birth as date_of_birth,
		M.gender as gender,
		M.salary as salary,
		M.hire_date as hire_date,
		M.weekly_hours as weekly_hours,
		M.employee_address as address,
		M.phone_number as phone_number,
		CONCAT(M.first_name, ' ', M.middle_name, ' ', M.last_name) AS manager_name,
		M.performance_rating as performance_rate  
		FROM Employees E
		INNER JOIN 
        Employees M ON E.manager_id = M.employee_id and (M.first_name+' '+M.middle_name+' '+M.last_name) = @full_name ) as F
end
----------------------------------------------------------------
alter procedure GetEmployeesWithDateOfBirth
@datee date
as
begin

select  Distinct
		M.first_name as first_name,
		M.middle_name as middle_name,
		M.last_name as last_name,
		M.date_of_birth as date_of_birth,
		M.gender as gender,
		M.salary as salary,
		M.hire_date as hire_date,
		M.weekly_hours as weekly_hours,
		M.employee_address as address,
		M.phone_number as phone_number,
		CONCAT(M.first_name, ' ', M.middle_name, ' ', M.last_name) AS manager_name,
		M.performance_rating as performance_rate  
		FROM Employees E
		INNER JOIN 
        Employees M ON E.manager_id = M.employee_id 
		where M.date_of_birth = @datee 
end
----------------------------------------------------------------
create procedure GetEmployeesWithGender
@gender varchar(6)
as
begin

select  Distinct
		M.first_name as first_name,
		M.middle_name as middle_name,
		M.last_name as last_name,
		M.date_of_birth as date_of_birth,
		M.gender as gender,
		M.salary as salary,
		M.hire_date as hire_date,
		M.weekly_hours as weekly_hours,
		M.employee_address as address,
		M.phone_number as phone_number,
		CONCAT(M.first_name, ' ', M.middle_name, ' ', M.last_name) AS manager_name,
		M.performance_rating as performance_rate  
		FROM Employees E
		INNER JOIN 
        Employees M ON E.manager_id = M.employee_id 
		where M.gender = @gender 
end
----------------------------------------------------------------
create procedure GetEmployeesWithWeeklyHours
@weekly_hours int
as
begin

select  Distinct
		M.first_name as first_name,
		M.middle_name as middle_name,
		M.last_name as last_name,
		M.date_of_birth as date_of_birth,
		M.gender as gender,
		M.salary as salary,
		M.hire_date as hire_date,
		M.weekly_hours as weekly_hours,
		M.employee_address as address,
		M.phone_number as phone_number,
		CONCAT(M.first_name, ' ', M.middle_name, ' ', M.last_name) AS manager_name,
		M.performance_rating as performance_rate  
		FROM Employees E
		INNER JOIN 
        Employees M ON E.manager_id = M.employee_id 
		where M.weekly_hours = @weekly_hours
end
----------------------------------------------------------------
create procedure GetEmployeesWithAddress
@address varchar(225)
as
begin

select  Distinct
		M.first_name as first_name,
		M.middle_name as middle_name,
		M.last_name as last_name,
		M.date_of_birth as date_of_birth,
		M.gender as gender,
		M.salary as salary,
		M.hire_date as hire_date,
		M.weekly_hours as weekly_hours,
		M.employee_address as address,
		M.phone_number as phone_number,
		CONCAT(M.first_name, ' ', M.middle_name, ' ', M.last_name) AS manager_name,
		M.performance_rating as performance_rate  
		FROM Employees E
		INNER JOIN 
        Employees M ON E.manager_id = M.employee_id 
		where M.employee_address Like '%' + @address + '%'
end
----------------------------------------------------------------
alter procedure GetEmployeesWithRate
@rate float
as
begin

select  
		M.first_name as first_name,
		M.middle_name as middle_name,
		M.last_name as last_name,
		M.date_of_birth as date_of_birth,
		M.gender as gender,
		M.salary as salary,
		M.hire_date as hire_date,
		M.weekly_hours as weekly_hours,
		M.employee_address as address,
		M.phone_number as phone_number,
		CONCAT(M.first_name, ' ', M.middle_name, ' ', M.last_name) AS manager_name,
		M.performance_rating as performance_rate  
		FROM Employees E
		INNER JOIN 
        Employees M ON E.manager_id = M.employee_id 
		where
		M.performance_rating >= @rate
end
----------------------------------------------------------------

/*
getAll
first_name
full_name
gender
weekly_hours
address
rate
*/
exec GetAllEmployees
exec GetEmployeesWithFirstName 'Ahmed'
exec GetEmployeesWithGender 'male'
exec GetEmployeesWithWeeklyHours 40
exec GetEmployeesWithAddress 'cairo'
exec GetEmployeesWithRate 2

select * from Employees
where performance_rating > 2


---------------------------------------------------------------------------

alter procedure AddNewEmployee
                @first_name varchar(20),
                @middle_name varchar(20),
                @last_name varchar(20),
                @date_of_birth date,
                @gender varchar(6),
				@salary float,
                @hire_date date,
				@weekly_hours int,
                @employee_address varchar(100),
                @phone_number varchar(11),
				@manager_name varchar(60),
				@performance_rate float

as
begin
	declare @mag_id int
	select @mag_id=employee_id
	from Employees E
	where E.first_name+' '+E.middle_name+' '+E.last_name = @manager_name 

insert into Employees (first_name,middle_name,last_name,date_of_birth,gender,salary,hire_date,weekly_hours,
						employee_address,phone_number,manager_id,performance_rating)
				values(@first_name,@middle_name,@last_name,@date_of_birth,@gender,@salary,@hire_date,
					   @weekly_hours,@employee_address,@phone_number,@mag_id,@performance_rate)

end

--------------------------------------------------------------------------
alter PROCEDURE UpdateEmployees
    @first_name VARCHAR(20),
    @middle_name VARCHAR(20),
    @last_name VARCHAR(20),
    @date_of_birth DATE,
    @gender VARCHAR(6),
    @salary FLOAT,
    @hire_date DATE,
    @weekly_hours INT,
    @employee_address VARCHAR(100),
    @phone_number VARCHAR(15),
    @manager_name VARCHAR(60),
    @performance_rate FLOAT,
    @id INT
AS
BEGIN
    
   
        -- Update employee details
		
		declare @mag_id int
		select @mag_id = E.employee_id
		from Employees E
		where E.first_name+' '+E.middle_name+' '+E.last_name=@manager_name
        UPDATE Employees
        SET 
            first_name = @first_name,
            middle_name = @middle_name,
            last_name = @last_name,
            date_of_birth = @date_of_birth,
            gender = @gender,
            salary = @salary,
            hire_date = @hire_date,
            weekly_hours = @weekly_hours,
            employee_address = @employee_address,
            phone_number = @phone_number,
            manager_id = @mag_id,
            performance_rating = @performance_rate
        WHERE employee_id = @id;

END;


