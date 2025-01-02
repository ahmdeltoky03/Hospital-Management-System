
use HOSPITAL



-- I have added a department id for each worker 



-- why using left Join rather than inner join ? 
-- As :  If a department has no assigned employees (Doctors, Nurses, or Workers), using an INNER JOIN would exclude that department from the result.
go

-- Employee Count by Department
CREATE PROCEDURE GetEmployeeCountByDepartment
AS
BEGIN
    SELECT 
        d.department_name,
        COUNT(e.employee_id) AS total_employees
    FROM 
        Departments d 
    LEFT JOIN 
        Doctors doc ON d.department_id = doc.department_id
    LEFT JOIN 
        Nursing n ON d.department_id = n.department_id
    LEFT JOIN 
        Workers w ON d.department_id = w.department_id
    JOIN 
        Employees e ON e.employee_id IN (doc.doctor_id, n.nurse_id, w.worker_id)
    GROUP BY 
        d.department_name;
END 




-- Patient Count by Room

/*
	Count how many patients are currently assigned to each room.
	Tables Involved: Patients, Rooms. 
*/
go

CREATE PROCEDURE GetPatientCountByRoom
AS
BEGIN
    SELECT 
        r.room_number,
        COUNT(p.patient_id) AS patient_count
    FROM 
        Rooms r
    LEFT JOIN 
        Patients p ON r.room_id = p.room_id
    GROUP BY 
        r.room_number;
END 





-- Average Performance Rating by Gender
/*
Calculate the average performance rating of employees grouped by gender.
Tables Involved: Employees.
*/
go
CREATE PROCEDURE GetAveragePerformanceByGender
AS
BEGIN
    SELECT 
        gender,
        AVG(performance_rating) AS average_rating
    FROM 
        Employees
    GROUP BY 
        gender;
END 




-- number of operations for each doctor and number of successful operations he has done.
go

CREATE PROCEDURE GetOperationsByDoctor
AS
BEGIN
    SELECT 
        od.doctor_id,
        od.doctor_name,
        COUNT(*) AS total_operations,
        SUM(CASE WHEN o.success = 1 THEN 1 ELSE 0 END) AS successful_operations
    FROM 
        Operations o 
    JOIN 
        OperationDoctors od ON o.operation_id = od.operation_id 
    GROUP BY 
        od.doctor_id, od.doctor_name;
END 




go
-- List Doctors with Number of Appointments and Operations
CREATE PROCEDURE GetDoctorWorkloadSummary
AS
BEGIN
    SELECT 
        d.doctor_id,
        e.first_name,
        e.last_name,
        d.specialization,
        COUNT(DISTINCT a.appointment_id) AS total_appointments,
        COUNT(DISTINCT od.operation_id) AS total_operations
    FROM 
        Doctors d
    JOIN 
        Employees e ON d.doctor_id = e.employee_id
    LEFT JOIN 
        Appointments a ON d.doctor_id = a.doctor_id
    LEFT JOIN 
        OperationDoctors od ON d.doctor_id = od.doctor_id
    GROUP BY 
        d.doctor_id, e.first_name, e.last_name, d.specialization;
END 



go
--  Operations and Their Success Rate by Department
CREATE PROCEDURE GetOperationsSuccessRateByDepartment
AS
BEGIN
    SELECT 
        d.department_name,
        COUNT(o.operation_id) AS total_operations,
        SUM(CASE WHEN o.success = 1 THEN 1 ELSE 0 END) AS successful_operations,
        (SUM(CASE WHEN o.success = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(o.operation_id)) AS success_rate
    FROM 
        Departments d
    LEFT JOIN 
        Operations o ON d.department_id = o.department_id
    GROUP BY 
        d.department_name;
END 



go
-- Average Number of Visitors per Patient
CREATE PROCEDURE GetAverageVisitorsPerPatient
AS
BEGIN
    SELECT 
        p.first_name + ' ' + p.last_name AS patient_name,
        AVG(v.visitors_number) AS average_visitors
    FROM 
        Visits v
    JOIN 
        Patients p ON v.patient_id = p.patient_id
    GROUP BY 
        p.patient_id, p.first_name, p.last_name;
END 




-- execute 

exec GetEmployeeCountByDepartment

exec GetPatientCountByRoom

exec GetAveragePerformanceByGender

exec GetOperationsByDoctor

exec GetDoctorWorkloadSummary

exec GetOperationsSuccessRateByDepartment

exec GetAverageVisitorsPerPatient











