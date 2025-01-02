-- ----------- Some Conventions --------------- --
-- Name of the database is all CAPITAL letters (HOSPITAL)
-- Names of tables starts with Capital letter (Patients)
-- Names of Constraints, each word start with Captital letter either FK (FK_Head_Of_Department)
--                       in the shape of 'FK_ReferencingAttribute_FeferencedAttribute'



-- ----------- Notes --------------- --
-- 1) Tables are {Patients, Employees, Departments, Doctors, Nursing, Workers, Absense, Rooms, Beds, Operations, OperationDoctors, Appointments, Visits, Billings, Machines}
-- 2) Any person wants an appointment or an operation must be saved in the 'Patients' table first.
-- 3) The patient is not removed from the 'Patients' table untill he pays his billings.



create Database HOSPITAL

use Hospital

-- Disable Foreign Key Constraints Temporarily
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT ALL";

go

create table Patients (
	patient_id int primary key identity(100, 1),   -- identity(100, 1), it is auto incrementing in the shapr of 'identity(start, step)'.
	first_name varchar(20) not null,
	middle_name varchar(20),
	last_name varchar(20) not null,
	date_of_birth date not null,
	gender varchar(6) not null 
		check (lower(gender) in ('male', 'female')),
	patient_entry_date date default null,
	phone_number varchar(11) 
		check (phone_number like '010%' or 
		phone_number like '011%' or 
		phone_number like '012%' or 
		phone_number like '015%' and 
		len(phone_number) = 11),  -- The patient can enter only number of an egyptien portable phone not anything else.
	room_id int default null,
	bed_id int default null,
	patient_status varchar(200),


	/*constraint FK_Patient_Bed
		foreign key (bed_id)
		references Beds(bed_id),
		-- I made a trigger (UpdateBedsRelated) for the case of updating the beds.

	constraint FK_Patient_Room
		foreign key (room_id)
		references Rooms(room_id)
		-- I made a trigger (DeletingRooms) for the case of updating the beds.*/

	-- TODO: Adding patient Case, Adding entry date.
)

/*
alter table Employees
alter column hire_date date
*/
create table Employees (
	employee_id int primary key identity(100, 1),
	first_name varchar(20) not null,
	middle_name varchar(20) not null,
	last_name varchar(20) not null,
	date_of_birth date not null,
	gender varchar(6)  
		check (lower(gender) in ('male', 'female')),
	salary decimal(10, 2) ,     -- decimal(p, s)  p --> is the total digits including digits on the right and on the left, s --> the digits on the right , p - s --> digits on the right.
	hire_date date ,
	weekly_hours int check(weekly_hours > 0 and weekly_hours <= 168),
	employee_address varchar(255) not null, 
	phone_number varchar(20) ,
	manager_id int default null,
	performance_rating float check(performance_rating >= 0.0 and performance_rating <= 5.0)

	constraint FK_Employee_Manager
		foreign key (manager_id)
		references Employees (employee_id)
		-- I made a trigger (DeletingEmployee) for the case of deleting the employee to make it Null.

)
-- Changing the name of a column.
--  exec sp_rename 'Employees.address', 'employee_address', 'COLUMN';

create table Departments(
	department_id int primary key identity(11, 1),
	department_name varchar(100) ,
	department_description text default null,
	head_of_department int,
		
	constraint FK_Head_Of_Department
		foreign key (head_of_department)
		references Employees (employee_id)
		on delete set null
		on update cascade
)


create table Doctors(
	doctor_id int primary key,
	department_id int,
	experience int check(experience >= 0),
	specialization varchar(50),
	appointment_room int,
	medical_license_number varchar(50),
	email_address varchar(100) check(
		email_address like '%@gmail.com' or 
		email_address like '%@yahoo.com'),
	number_of_operations int check (number_of_operations >= 0),

	constraint FK_Doctor_Employee
		foreign key (doctor_id)
		references Employees(employee_id)
		on delete cascade
		on update cascade,

	constraint FK_Doctor_Department
		foreign key (department_id)
		references Departments(department_id)
		on delete no action,
		-- I made a trigger (UpdateDoctorAndNursingDepartment) for the case of updating the department.

	/*constraint FK_Doctor_Room
		foreign key (appointment_room)
		references Rooms(room_id)
		-- I made a trigger (DeletingRooms) for the case of deleting the room.*/


)




create table Nursing(
	nurse_id int primary key,
	department_id int,
	experience int check (experience > 0),
	supervisor int default null,
	shift_schedule varchar(20)

	constraint FK_Nurse_Employee
		foreign key (nurse_id)
		references Employees(employee_id)
		on delete cascade
		on update cascade,

	constraint FK_Nurse_Department
		foreign key (department_id)
		references Departments(department_id)
		on delete set null,
		-- I made a trigger (UpdateDoctorAndNursingDepartment) for the case of updating the department.

	constraint FK_Nurse_Supervisor
		foreign key (supervisor)
		references Employees(employee_id)
		on delete no action  -- This must be set null (TODO) 📌📌
		-- I made a trigger (UpdateEmployeesRelated) for the case of updating the supervisor.
)



create table Workers(
	worker_id int primary key,
	worker_role varchar (100) not null,
	shift_schedule varchar(20),
	department_id int

	constraint FK_Worker_Employee
		foreign key (worker_id)
		references Employees(employee_id)
		on delete cascade
		on update cascade,

	constraint FK_Worker_Department
		foreign key (department_id)
		references Departments(department_id)
		on delete no action,
		-- I made a trigger (UpdateDoctorAndNursingDepartment) for the case of updating the department.

)




create table Absense(
	absense_id int primary key identity (100, 1),
	employee_id int ,
	absense_date date ,
	reason varchar(50) ,
	absense_status varchar(8) check (
		lower(absense_status) in ('pending', 'approved', 'rejected')),
	approved_by int default 0,  -- Assuming 0 represents the employee leaved.

	constraint FK_Absense_Employee
		foreign key (employee_id)
		references Employees(employee_id)
		on delete cascade
		on update cascade,

	constraint FK_Absense_ApprovedBy
		foreign key (approved_by)
		references Employees(employee_id)
		-- I made a trigger (DeletingEmployee) for the case of deleting the employee to make it default.
		-- I made a trigger (UpdateEmployeesRelated) for the case of updating the employee.

)




create table Rooms(
	room_id int primary key identity(100, 1),  -- I started from 100 in anticipation of any special rooms with special numbers from 0 to 99.
	room_number varchar(10) ,
	room_length decimal(5, 2),
	room_width decimal(5, 2),
	department_id int default null,
	is_available bit default 1   -- It is 'True' if available else 'False'. The default is True.

	constraint FK_Room_Department
		foreign key (department_id)
		references Departments (department_id)
		on delete set null
		on update cascade
)


create table Beds(
	bed_id int primary key identity(100, 1),  -- I started from 100 in anticipation of any special beds with special numbers from 0 to 99.
	bed_number varchar(20) unique ,
	room_id int,
	is_available bit default 1   -- It is 'True' if available else 'False'. The default is True.

	constraint FK_Bed_Room
		foreign key (room_id)
		references Rooms(room_id)
		on delete set null
		-- I made a trigger (UpdateRoomsRelated) for the case of updating the Rooms.
)

alter table Doctors 
add constraint FK_Doctor_Room
		foreign key (appointment_room)
		references Rooms(room_id)
		-- I made a trigger (DeletingRooms) for the case of deleting the room.


alter table Patients
add constraint FK_Patient_Bed
		foreign key (bed_id)
		references Beds(bed_id),
		-- I made a trigger (UpdateBedsRelated) for the case of updating the beds.

	constraint FK_Patient_Room
		foreign key (room_id)
		references Rooms(room_id)
		-- I made a trigger (DeletingRooms) for the case of updating the beds.


create table Operations(
	operation_id int primary key identity(100, 1),
	operation_about varchar(100),
	patient_id int,
	patient_name varchar(60) ,
	patient_phone_number int ,
	department_id int,
	room_id int,
	operation_date date,
	operation_start_time time,
	operation_end_time time,
	success bit Null,

	constraint FK_Operation_Patient
		foreign key (patient_id)
		references Patients(patient_id)
		on delete set null   -- I made this set null such that I don't lose the information of the operation after the record of the patient is deleted.
		on update cascade,

	-- I create this trigger(UpdatePatientInformation) to make the phone number always updated with the patient table.

	constraint FK_Operation_Department
		foreign key (department_id)
		references Departments(department_id)
		on delete set null
		on update cascade,

	constraint FK_Operation_Room
		foreign key (room_id)
		references Rooms(room_id)
		on delete set null
		-- I made a trigger (UpdateRoomsRelated) for the case of updating the Rooms.
)



create table OperationDoctors(
	operation_id int ,
	doctor_id int,
	doctor_name varchar(60) ,
	doctor_phone_number int ,

	primary key (operation_id, doctor_id),

	constraint FK_OperationDoctor_Operation
		foreign key (operation_id)
		references Operations(operation_id)
		on delete cascade
		on update cascade,

	constraint FK_OperationDoctor_Doctor
		foreign key (doctor_id)
		references Employees(employee_id)
		on delete no action
		-- I made a trigger (UpdateDoctorsRelated) for the case of updating the doctor information.

	-- I create this trigger (UpdatingInformationOfEmployees) to make the phone number always updated with the employee table.
)


create table Appointments(
	appointment_id int primary key identity(100, 1),
	patient_id int,
	patient_name varchar(60),   -- ## Creating trigger for updating
	patient_phone_number int,
	department_id int default null,  -- maybe modified after that.
	doctor_id int ,
	doctor_name varchar(60) ,
	doctor_phone_number int ,
	room_id int,
	appointment_date date ,
	appointment_time time ,
	notes varchar(200)

	constraint FK_Appointment_Patient
		foreign key (patient_id)
		references Patients(patient_id)
		on delete set null
		on update cascade,

	constraint FK_Appointment_Department
		foreign key (department_id)
		references Departments(department_id)
		on delete set null
		on update cascade,

	constraint FK_Appointment_Employee
		foreign key (doctor_id)
		references Employees(employee_id)
		on delete no action,
		-- I made a trigger (UpdateEmployeesRelated) for the case of updating the doctor information.


	constraint FK_Appointment_Room
		foreign key (room_id)
		references Rooms(room_id)
		on delete no action
		-- I made a trigger (UpdateRoomsRelated) for the case of updating the room information.


-- I create this trigger to make the phone number always updated with the employee table.
/*	CREATE TRIGGER UpdateDoctorDonigAppointmentInformation
		ON Employees
		AFTER UPDATE
		AS
		BEGIN
			UPDATE Appointment
			SET 
				doctor_phone_number = i.phone_number
				doctor_name = i.first_name + ' ' + i.middle_name + ' ' + i.last_name -- Update full name
			FROM Appointments a
			INNER JOIN Employees i ON a.employee_id = i.doctor_id;
		END;
		*/
)




create table Visits(
	visit_id int primary key identity(100, 1),
	patient_id int ,
	visit_date date,
	visitors_number int check (len(visitors_number) >= 1),

	constraint FK_Visit_Patient
		foreign key (patient_id)
		references Patients(patient_id)
		on delete cascade
		on update cascade
)



create table Billings(
	billing_id int primary key identity(100, 1),
	patient_id int ,
	billing_description varchar(100),
	billing_value decimal(8, 2) check (billing_value > 0),
	payment_status varchar (10) check (lower(payment_status) in ('paid', 'pending', 'overdue')),
	billing_date date ,
	payment_method varchar(20) check (lower(payment_method) in ('cash', 'credit', 'insurance', 'other')),

	constraint FK_Billing_Patient
		foreign key (patient_id)
		references Patients(patient_id)
		on delete cascade   -- The patient is not removed from the 'Patients' table untill he pays his billings.
		on update cascade
)



create table Machines (
	machine_id int primary key identity(100, 1),
	machine_name varchar(50),
	time_of_purchase date,
	department_id int default null,
	room_id int default null,
	price int ,
	about varchar(255),
	is_working bit 

	constraint FK_Machine_Department
		foreign key (department_id)
		references Departments (department_id)
		on delete set null
		on update cascade,

	constraint FK_Machine_Room
		foreign key (room_id)
		references Rooms (room_id)
		on delete set null
		-- I made a trigger (UpdateRoomsRelated) for the case of updating the room information.
)

-- Re-enable Foreign Key Constraints
EXEC sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL";


