-- Data Insertion for Hospital Database
use HOSPITAL

-- Disable Foreign Key Constraints Temporarily
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT ALL";

-- Inserting Data into Patients Table
INSERT INTO Patients (first_name, middle_name, last_name, date_of_birth, gender, patient_entry_date, phone_number, room_id, bed_id, patient_status) 
VALUES
('Ahmed', 'Mohamed', 'Ali', '1985-01-15', 'male', '2024-01-01', '01012345678', 101, 101, 'Recovered'),
('Sara', 'Ibrahim', 'Hassan', '1992-05-20', 'female', '2024-01-05', '01112345678', 102, 102, 'Under Treatment'),
('Mahmoud', 'Ahmed', 'Youssef', '1980-12-11', 'male', '2024-01-10', '01212345678', 103, 103, 'Discharged'),
('Noor', 'Ali', 'Saeed', '1995-07-25', 'female', '2024-01-15', '01512345678', 104, 104, 'Recovered'),
('Yasmin', 'Khaled', 'Saleh', '1990-03-03', 'female', '2024-01-20', '01098765432', 105, 105, 'Under Observation'),
('Omar', 'Tarek', 'Mostafa', '1987-08-19', 'male', '2024-01-25', '01234567890', 106, 106, 'Recovered'),
('Layla', 'Samir', 'Adel', '1993-04-10', 'female', '2024-01-30', '01598765432', 107, 107, 'Under Treatment'),
('Khaled', 'Hussein', 'Fadel', '1982-03-11', 'male', '2024-02-01', '01055555555', 108, 108, 'Under Observation'),
('Mariam', 'Omar', 'Ezzat', '1991-09-12', 'female', '2024-02-05', '01166666666', 109, 109, 'Recovered'),
('Samir', 'Hassan', 'Salem', '1984-06-14', 'male', '2024-02-10', '01277777777', 110, 110, 'Under Treatment');

select * from Patients

-- Inserting into employees 

INSERT INTO Employees (first_name, middle_name, last_name, date_of_birth, gender, salary, hire_date, weekly_hours, employee_address, phone_number, manager_id, performance_rating)
VALUES
('Ahmed', 'Ali', 'Al-Sayed', '1985-04-12', 'male', 5000.00, '2020-01-15', 40, '123 Cairo Street, Cairo', '01012345678', NULL, 4.2),
('Mohamed', 'Tariq', 'Abdel Rahman', '1990-07-21', 'male', 4500.00, '2021-03-10', 40, '456 Giza Street, Giza', '01098765432', NULL, 3.8),
('Ali', 'Ibrahim', 'Hassan', '1987-08-05', 'male', 6000.00, '2019-05-20', 45, '789 Alexandria Street, Alexandria', '01122334455', NULL, 4.5),
('Sara', 'Hassan', 'El-Masry', '1993-12-22', 'female', 4000.00, '2022-02-11', 40, '101 Tanta Street, Tanta', '01234567890', NULL, 4.0),
('Fatima', 'Mohamed', 'Hassan', '1995-06-17', 'female', 3800.00, '2021-06-01', 40, '202 Mansoura Street, Mansoura', '01011122334', NULL, 4.3),
('Omar', 'Ahmed', 'Ibrahim', '1989-11-03', 'male', 5500.00, '2018-08-25', 42, '303 Luxor Street, Luxor', '01123456789', NULL, 4.7),
('Mona', 'Mahmoud', 'Khaled', '1992-03-14', 'female', 4200.00, '2020-10-02', 40, '404 Sharm El Sheikh, Sharm', '01055443322', NULL, 3.9),
('Yasser', 'Sayed', 'Adel', '1983-01-29', 'male', 5700.00, '2017-09-12', 40, '505 Hurghada Street, Hurghada', '01076543210', NULL, 4.8),
('Hassan', 'Mohamed', 'Fathy', '1988-05-06', 'male', 5100.00, '2019-07-30', 40, '606 Aswan Street, Aswan', '01156789012', NULL, 4.4),
('Layla', 'Kamal', 'Gamal', '1994-02-17', 'female', 3900.00, '2021-04-22', 40, '707 Cairo Street, Cairo', '01087654321', NULL, 4.0);

-- more employees
INSERT INTO Employees (first_name, middle_name, last_name, date_of_birth, gender, salary, hire_date, weekly_hours, employee_address, phone_number, manager_id, performance_rating)
VALUES
('Mariam', 'Salah', 'Abdel Rahman', '1986-03-15', 'female', 3500.00, '2022-05-01', 40, '123 Al-Mahalla Street, Mahalla', '01022223344', NULL, 3.9),
('Rami', 'Fathi', 'Mohamed', '1991-08-10', 'male', 3300.00, '2021-07-05', 40, '456 Tanta Street, Tanta', '01032334455', NULL, 4.1),
('Noha', 'Hassan', 'Mohamed', '1990-01-02', 'female', 3700.00, '2022-06-11', 40, '789 Cairo Street, Cairo', '01155667788', NULL, 4.3),
('Ahmed', 'Ali', 'Mahmoud', '1989-12-23', 'male', 3600.00, '2021-09-15', 40, '101 Alexandria Street, Alexandria', '01044556677', NULL, 4.0),
('Laila', 'Khaled', 'Ali', '1994-05-18', 'female', 3400.00, '2022-02-17', 40, '202 Mansoura Street, Mansoura', '01077889900', NULL, 4.2),
('Mohamed', 'Hassan', 'Abdel Aziz', '1987-10-30', 'male', 3800.00, '2021-03-20', 40, '303 Aswan Street, Aswan', '01166778899', NULL, 4.4),
('Fatima', 'Sayed', 'Ali', '1995-06-10', 'female', 3300.00, '2022-08-25', 40, '404 Sharm El Sheikh, Sharm', '01055443311', NULL, 3.8),
('Karim', 'Fathy', 'Hassan', '1992-11-05', 'male', 3700.00, '2021-12-01', 40, '505 Hurghada Street, Hurghada', '01098765432', NULL, 4.1),
('Nesreen', 'Salah', 'Mahmoud', '1988-04-22', 'female', 3600.00, '2020-11-12', 40, '606 Luxor Street, Luxor', '01099887766', NULL, 4.3),
('Tamer', 'Mohamed', 'Ali', '1993-07-30', 'male', 3500.00, '2021-10-15', 40, '707 Sharm El Sheikh, Sharm', '01111223344', NULL, 4.2);

-- more employees
-- Insert data for employees 121 to 130
INSERT INTO Employees (first_name, middle_name, last_name, date_of_birth, gender, salary, hire_date, weekly_hours, employee_address, phone_number, manager_id, performance_rating)
VALUES
('Ziad', 'Mohamed', 'Gaber', '1992-05-10', 'male', 3500.00, '2022-06-01', 40, '123 Zamalek Street, Cairo', '01012345001', NULL, 3.7),
('Salma', 'Tarek', 'Shawky', '1990-11-17', 'female', 3300.00, '2023-01-10', 40, '456 Mohandessin, Cairo', '01012345002', NULL, 3.5),
('Mahmoud', 'Ahmed', 'Ezzat', '1988-03-25', 'male', 3700.00, '2021-09-05', 40, '789 Nasr City, Cairo', '01012345003', NULL, 3.8),
('Huda', 'Samir', 'Mostafa', '1994-08-10', 'female', 3200.00, '2023-02-12', 40, '101 El Maadi, Cairo', '01012345004', NULL, 3.6),
('Khaled', 'Ali', 'Salah', '1991-06-19', 'male', 3600.00, '2020-04-30', 40, '202 6th October, Giza', '01012345005', NULL, 3.9),
('Nour', 'Ibrahim', 'Fawzy', '1986-12-22', 'female', 3900.00, '2021-07-16', 40, '303 Heliopolis, Cairo', '01012345006', NULL, 4.1),
('Youssef', 'Fathi', 'Mahmoud', '1989-02-05', 'male', 3400.00, '2020-11-11', 40, '404 Dokki, Cairo', '01012345007', NULL, 3.7),
('Rania', 'Mohamed', 'Abd El-Hakim', '1995-04-15', 'female', 3100.00, '2022-07-22', 40, '505 New Cairo', '01012345008', NULL, 3.8),
('Omar', 'Ali', 'Khalil', '1993-01-29', 'male', 3800.00, '2020-10-05', 40, '606 Sheikh Zayed, Giza', '01012345009', NULL, 4.0),
('Dina', 'Tamer', 'Abdel-Moneim', '1987-09-30', 'female', 3300.00, '2023-05-01', 40, '707 Al Haram, Giza', '01012345010', NULL, 3.6);


select * from employees


-- Insert sample data into Departments table
INSERT INTO Departments (department_name, department_description, head_of_department)
VALUES
('Human Resources', 'Responsible for managing employee relations, hiring, training, and development.', 100),  -- Ahmed Ali is the head
('Finance', 'Handles the company’s financial operations, budgeting, and reporting.', 101),  -- Mohamed Tariq is the head
('IT Department', 'Manages all technology and infrastructure needs, software, and hardware.', 102),  -- Ali Ibrahim is the head
('Sales and Marketing', 'Responsible for promoting the company’s products and services, and managing customer relations.', 104),  -- Sara Hassan is the head
('Customer Service', 'Handles client interactions, queries, and customer support issues.', 103),  -- Omar Ahmed is the head
('Operations', 'Manages the day-to-day business activities and ensures smooth operation.', 108),  -- Yasser Sayed is the head
('R&D Department', 'Focuses on research and development to innovate and improve products.', 105),  -- Fatima Mohamed is the head
('Legal Department', 'Responsible for legal compliance, contracts, and company law matters.', 107),  -- Mona Mahmoud is the head
('Procurement', 'Handles the sourcing and purchasing of necessary materials and services.', 109),  -- Hassan Mohamed is the head
('Logistics', 'Manages the distribution and transportation of goods and materials.', 104);  -- Layla Kamal is the head


select * from Departments


-- Inserting Data into Doctors Table
INSERT INTO Doctors (doctor_id, department_id, experience, specialization, appointment_room, medical_license_number, email_address, number_of_operations)
VALUES
(100, 11, 5, 'Cardiology', 101, 'MD123456', 'ahmed@yahoo.com', 50),
(101, 12, 3, 'Neurology', 102, 'MD123457', 'mohamed@yahoo.com', 30),
(102, 13, 8, 'Orthopedics', 103, 'MD123458', 'ali@gmail.com', 75),
(103, 14, 2, 'Pediatrics', 104, 'MD123459', 'mona@gmail.com', 12),
(104, 15, 10, 'General Surgery', 105, 'MD123460', 'sarah@yahoo.com', 100),
(105, 16, 6, 'Dermatology', 106, 'MD123461', 'yasmine@gmail.com', 25),
(106, 17, 4, 'Oncology', 107, 'MD123462', 'mohamed@yahoo.com', 40),
(107, 18, 7, 'Gynecology', 108, 'MD123463', 'ahmed@yahoo.com', 60),
(108, 19, 1, 'Ophthalmology', 109, 'MD123464', 'ali@yahoo.com', 15),
(109, 20, 9, 'ENT', 110, 'MD123465', 'sarah@yahoo.com', 85);

select * from Doctors





INSERT INTO Nursing (nurse_id, department_id, experience, supervisor, shift_schedule)
VALUES
(111, 11, 3, 100, 'Morning'),
(112, 12, 2, 101, 'Evening'),
(113, 13, 4, 102, 'Night'),
(114, 14, 1, 103, 'Morning'),
(115, 15, 3, 104, 'Evening'),
(116, 16, 2, 105, 'Night'),
(117, 17, 4, 106, 'Morning'),
(118, 18, 1, 107, 'Evening')


select * from Nursing

select * from Departments


-- Insert data into Workers table
INSERT INTO Workers (worker_id, department_id,  worker_role, shift_schedule)
VALUES
(121, 11 , 'Cleaner', 'Morning'),
(122, 12 , 'Security Guard', 'Evening'),
(123, 13 , 'Cook', 'Morning'),
(124, 14 , 'Gardener', 'Night'),
(125, 15 , 'Driver', 'Morning'),
(126, 16 , 'Housekeeper', 'Evening'),
(127, 17 , 'Maintenance Worker', 'Night'),
(128, 18 , 'Laborer', 'Morning'),
(129, 19 , 'Warehouse Worker', 'Evening');

select * from workers



-- employee with id = 100 is responsible for approving absense
INSERT INTO Absense (employee_id, absense_date, reason, absense_status, approved_by)
VALUES
-- Ahmed Ali Al-Sayed (employee_id = 100)
(100, '2023-01-10', 'Sick Leave', 'approved', 100),
(100, '2023-06-15', 'Vacation', 'approved', 100),

-- Mohamed Tariq Abdel Rahman (employee_id = 101)
(101, '2023-03-22', 'Personal Reasons', 'pending', 100),
(101, '2023-08-05', 'Sick Leave', 'rejected', 100),

-- Ali Ibrahim Hassan (employee_id = 102)
(102, '2023-02-12', 'Vacation', 'approved', 100),
(102, '2023-07-10', 'Sick Leave', 'approved', 100),

-- Sara Hassan El-Masry (employee_id = 103)
(103, '2023-04-14', 'Medical Appointment', 'approved', 100),
(103, '2023-09-20', 'Personal Reasons', 'pending', 100),

-- Fatima Mohamed Hassan (employee_id = 104)
(104, '2023-05-01', 'Family Emergency', 'approved', 100),
(104, '2023-10-10', 'Vacation', 'approved', 100),

-- Omar Ahmed Ibrahim (employee_id = 105)
(105, '2023-06-05', 'Sick Leave', 'rejected', 100),
(105, '2023-12-01', 'Vacation', 'approved', 100),

-- Mona Mahmoud Khaled (employee_id = 106)
(106, '2023-03-30', 'Sick Leave', 'approved', 100),
(106, '2023-11-18', 'Personal Reasons', 'approved', 100),

-- Yasser Sayed Adel (employee_id = 107)
(107, '2023-01-18', 'Family Emergency', 'pending', 100),
(107, '2023-07-22', 'Medical Leave', 'approved', 100),

-- Hassan Mohamed Fathy (employee_id = 108)
(108, '2023-05-03', 'Sick Leave', 'approved', 100),
(108, '2023-09-12', 'Vacation', 'approved', 100),

-- Layla Kamal Gamal (employee_id = 109)
(109, '2023-02-25', 'Personal Reasons', 'pending', 100),
(109, '2023-08-30', 'Medical Appointment', 'approved', 100),

-- Ahmed Ali (employee_id = 110)
(110, '2023-04-01', 'Vacation', 'approved', 100),
(110, '2023-10-10', 'Sick Leave', 'approved', 100),

-- Fady Kassem (employee_id = 111)
(111, '2023-01-11', 'Personal Reasons', 'approved', 100),
(111, '2023-07-25', 'Sick Leave', 'rejected', 100),

-- Mona Khaled (employee_id = 112)
(112, '2023-03-15', 'Vacation', 'approved', 100),
(112, '2023-09-03', 'Medical Leave', 'approved', 100),

-- Karim Nour (employee_id = 113)
(113, '2023-02-21', 'Medical Appointment', 'approved', 100),
(113, '2023-06-19', 'Sick Leave', 'pending', 100),

-- Salma Tarek (employee_id = 114)
(114, '2023-03-10', 'Sick Leave', 'approved', 100),
(114, '2023-08-18', 'Vacation', 'approved', 100),

-- Marwa Youssef (employee_id = 115)
(115, '2023-05-25', 'Family Emergency', 'approved', 100),
(115, '2023-10-01', 'Sick Leave', 'approved', 100),

-- Tamer Abdallah (employee_id = 116)
(116, '2023-04-07', 'Sick Leave', 'approved', 100),
(116, '2023-09-12', 'Personal Reasons', 'rejected', 100),

-- Rania Ali (employee_id = 117)
(117, '2023-02-10', 'Sick Leave', 'approved', 100),
(117, '2023-07-21', 'Vacation', 'approved', 100),

-- Hany Mohamed (employee_id = 118)
(118, '2023-03-30', 'Personal Reasons', 'approved', 100),
(118, '2023-10-15', 'Sick Leave', 'pending', 100),

-- Yomna Sayed (employee_id = 119)
(119, '2023-04-05', 'Medical Leave', 'approved', 100),
(119, '2023-09-08', 'Sick Leave', 'approved', 100),

-- Eslam Ghanem (employee_id = 120)
(120, '2023-02-17', 'Vacation', 'approved', 100),
(120, '2023-08-25', 'Sick Leave', 'approved', 100),

-- Sameh Atef (employee_id = 121)
(121, '2023-01-20', 'Family Emergency', 'approved', 100),
(121, '2023-06-23', 'Sick Leave', 'rejected', 100),

-- Mahmoud Hossam (employee_id = 122)
(122, '2023-03-12', 'Personal Reasons', 'pending', 100),
(122, '2023-09-14', 'Medical Appointment', 'approved', 100),

-- Rasha Mohamed (employee_id = 123)
(123, '2023-04-15', 'Vacation', 'approved', 100),
(123, '2023-10-20', 'Sick Leave', 'approved', 100),

-- Ziad Hassan (employee_id = 124)
(124, '2023-05-10', 'Medical Leave', 'approved', 100),
(124, '2023-11-12', 'Sick Leave', 'pending', 100),

-- Iman Ahmed (employee_id = 125)
(125, '2023-06-22', 'Vacation', 'approved', 100),
(125, '2023-11-05', 'Personal Reasons', 'approved', 100),

-- Hossam Khalil (employee_id = 126)
(126, '2023-07-03', 'Medical Appointment', 'approved', 100),
(126, '2023-12-04', 'Vacation', 'approved', 100),

-- Amina Tamer (employee_id = 127)
(127, '2023-02-14', 'Sick Leave', 'approved', 100),
(127, '2023-08-14', 'Personal Reasons', 'approved', 100),

-- Mervat Saleh (employee_id = 128)
(128, '2023-03-18', 'Family Emergency', 'approved', 100),
(128, '2023-09-21', 'Sick Leave', 'approved', 100);


select * from Absense


-- Inserting Data into Rooms Table
-- two rooms for each department
INSERT INTO Rooms (room_number, room_length, room_width, department_id, is_available)
VALUES
-- Department 11
('R101', 5.00, 4.00, 11, 1),
('R102', 6.00, 4.50, 11, 1),

-- Department 12
('R103', 6.50, 4.25, 12, 1),
('R104', 7.00, 5.00, 12, 0),

-- Department 13
('R105', 5.50, 4.00, 13, 1),
('R106', 6.75, 4.75, 13, 1),

-- Department 14
('R107', 7.25, 5.00, 14, 1),
('R108', 5.50, 4.25, 14, 0),

-- Department 15
('R109', 6.00, 4.50, 15, 1),
('R110', 6.25, 4.75, 15, 1),

-- Department 16
('R111', 7.00, 5.25, 16, 1),
('R112', 6.50, 4.50, 16, 0),

-- Department 17
('R113', 5.75, 4.25, 17, 1),
('R114', 6.00, 4.50, 17, 1),

-- Department 18
('R115', 7.50, 5.00, 18, 1),
('R116', 6.00, 4.75, 18, 1),

-- Department 19
('R117', 5.25, 4.00, 19, 1),
('R118', 6.00, 4.25, 19, 0),

-- Department 20
('R119', 7.00, 5.00, 20, 1),
('R120', 6.50, 4.75, 20, 1);


select * from rooms


-- Inserting Data into Beds Table
-- 2 beds for each room
INSERT INTO Beds (bed_number, room_id, is_available)
VALUES
-- Room 101
('B101', 101, 1),
('B102', 101, 1),

-- Room 102
('B103', 102, 1),
('B104', 102, 0),

-- Room 103
('B105', 103, 1),
('B106', 103, 1),

-- Room 104
('B107', 104, 1),
('B108', 104, 0),

-- Room 105
('B109', 105, 1),
('B110', 105, 1),

-- Room 106
('B111', 106, 1),
('B112', 106, 1),

-- Room 107
('B113', 107, 1),
('B114', 107, 0),

-- Room 108
('B115', 108, 1),
('B116', 108, 1),

-- Room 109
('B117', 109, 1),
('B118', 109, 1),

-- Room 110
('B119', 110, 1),
('B120', 110, 1),

-- Room 111
('B121', 111, 1),
('B122', 111, 1),

-- Room 112
('B123', 112, 1),
('B124', 112, 0),

-- Room 113
('B125', 113, 1),
('B126', 113, 1),

-- Room 114
('B127', 114, 1),
('B128', 114, 0),

-- Room 115
('B129', 115, 1),
('B130', 115, 1),

-- Room 116
('B131', 116, 1),
('B132', 116, 0),

-- Room 117
('B133', 117, 1),
('B134', 117, 1),

-- Room 118
('B135', 118, 1),
('B136', 118, 1),

-- Room 119
('B137', 119, 1),
('B138', 119, 1);


select * from beds


-- Insert 15 operations data with departments and patient IDs
INSERT INTO Operations (operation_about, patient_id, patient_name, patient_phone_number, department_id, room_id, operation_date, operation_start_time, operation_end_time, success)
VALUES
('Heart Surgery', 100, 'Ali Ahmed', 01122334455, 11, 100, '2024-12-20', '08:30:00', '10:00:00', 1),    -- Cardiology, Room 100
('Knee Replacement', 101, 'Fatima Mohamed', 01011122334, 12, 101, '2024-12-21', '09:00:00', '11:00:00', 1), -- Orthopedics, Room 101
('Appendectomy', 102, 'Omar Ahmed', 01123456789, 13, 102, '2024-12-22', '10:00:00', '12:00:00', 1),       -- Gastroenterology, Room 102
('Cataract Surgery', 103, 'Mona Mahmoud', 01055443322, 14, 103, '2024-12-23', '11:00:00', '12:30:00', 0),   -- Ophthalmology, Room 103
('Dental Implant', 104, 'Yasser Sayed', 01076543210, 15, 104, '2024-12-24', '13:00:00', '14:00:00', 1),     -- Dentistry, Room 104
('Spinal Surgery', 105, 'Hassan Mohamed', 01156789012, 16, 105, '2024-12-25', '14:30:00', '16:00:00', 1),   -- Orthopedics, Room 105
('Laparoscopy', 106, 'Layla Kamal', 01087654321, 17, 106, '2024-12-26', '15:00:00', '16:30:00', 0),        -- General Surgery, Room 106
('Gallbladder Removal', 107, 'Ahmed Ali', 01012345678, 18, 107, '2024-12-27', '16:30:00', '18:00:00', 1),   -- Gastroenterology, Room 107
('Mastectomy', 108, 'Mohamed Tariq', 01098765432, 19, 108, '2024-12-28', '17:00:00', '18:30:00', 1),       -- Plastic Surgery, Room 108
('Hip Surgery', 109, 'Ali Ibrahim', 01122334455, 20, 109, '2024-12-29', '08:00:00', '09:30:00', 0),        -- Orthopedics, Room 109
('Cosmetic Surgery', 100, 'Sara Hassan', 01234567890, 19, 110, '2024-12-30', '09:30:00', '11:00:00', 0),    -- Plastic Surgery, Room 110
('Brain Surgery', 101, 'Fatima Mohamed', 01011122334, 11, 111, '2024-12-31', '10:00:00', '11:30:00', 1),    -- Cardiology, Room 111
('Knee Arthroscopy', 102, 'Omar Ahmed', 01123456789, 12, 112, '2024-12-20', '08:00:00', '09:30:00', 1),    -- Orthopedics, Room 112
('Thyroid Surgery', 103, 'Mona Mahmoud', 01055443322, 14, 113, '2024-12-21', '09:00:00', '10:30:00', 1),    -- Ophthalmology, Room 113
('Tonsillectomy', 104, 'Yasser Sayed', 01076543210, 17, 114, '2024-12-22', '10:30:00', '12:00:00', 0);    -- General Surgery, Room 114



select * from operations
select * from rooms



-- Inserting 15 rows for OperationDoctors table with the updated doctor data
INSERT INTO OperationDoctors (operation_id, doctor_id, doctor_name, doctor_phone_number)
VALUES
(100, 100, 'Ahmed Ali', 01012345678),    -- Heart Surgery (Doctor 100)
(101, 106, 'Mohamed Tariq', 01055443322), -- Knee Replacement (Doctor 101)
(102, 102, 'Ali Ibrahim', 01122334455),   -- Appendectomy (Doctor 102)
(103, 103, 'Mona Mahmoud', 01234567890),  -- Cataract Surgery (Doctor 103)
(104, 104, 'Sara Hassan', 01087654321),   -- Dental Implant (Doctor 104)
(105, 105, 'Yasmine Mohamed', 01123456789), -- Spinal Surgery (Doctor 105)
(106, 106, 'Mohamed Tariq', 01055443322),  -- Laparoscopy (Doctor 106)
(107, 100, 'Ahmed Ali', 01012345678),     -- Gallbladder Removal (Doctor 107)
(108, 102, 'Ali Ibrahim', 01122334455),   -- Mastectomy (Doctor 108)
(109, 104, 'Sara Hassan', 01087654321),   -- Hip Surgery (Doctor 109)
(110, 100, 'Ahmed Ali', 01012345678),    -- Cosmetic Surgery (Doctor 100)
(111, 106, 'Mohamed Tariq', 01055443322), -- Brain Surgery (Doctor 101)
(112, 102, 'Ali Ibrahim', 01122334455),   -- Knee Arthroscopy (Doctor 102)
(113, 103, 'Mona Mahmoud', 01234567890),  -- Thyroid Surgery (Doctor 103)
(114, 104, 'Sara Hassan', 01087654321);   -- Tonsillectomy (Doctor 104)






INSERT INTO Appointments (patient_id, patient_name, patient_phone_number, department_id, doctor_id, doctor_name, doctor_phone_number, room_id, appointment_date, appointment_time, notes)
VALUES
(100, 'Ahmed Ali', '01011223344', 11, 100, 'Dr. Khaled Mohamed', '01022334455', 101, '2024-12-20', '09:00:00', 'Routine checkup for heart disease.'),
(101, 'Mohamed Tariq', '01022334455', 12, 101, 'Dr. Sara Ahmed', '01033445566', 102, '2024-12-21', '10:00:00', 'Neurology consultation for headaches.'),
(102, 'Ali Ibrahim', '01133445566', 13, 102, 'Dr. Tamer Youssef', '01044556677', 103, '2024-12-22', '11:00:00', 'Orthopedic consultation for knee pain.'),
(103, 'Sara Hassan', '01244556677', 14, 103, 'Dr. Mona Hassan', '01055667788', 104, '2024-12-23', '12:00:00', 'Pediatric appointment for child vaccination.'),
(104, 'Fatima Mohamed', '01055667788', 15, 104, 'Dr. Ahmed Fathy', '01066778899', 105, '2024-12-24', '14:00:00', 'General surgery consultation for abdominal pain.'),
(105, 'Omar Ahmed', '01166778899', 16, 105, 'Dr. Yasmine Ali', '01077889900', 106, '2024-12-25', '15:00:00', 'Skin checkup and mole removal.'),
(106, 'Mona Mahmoud', '01077889900', 17, 106, 'Dr. Mohamed Ibrahim', '01088990011', 107, '2024-12-26', '16:00:00', 'Chemotherapy follow-up consultation.'),
(107, 'Yasser Sayed', '01088990011', 18, 107, 'Dr. Nabil Saeed', '01099001122', 108, '2024-12-27', '17:00:00', 'Gynecological checkup and ultrasound.'),
(108, 'Hassan Mohamed', '01199001122', 19, 108, 'Dr. Ali Mahmoud', '01110111222', 109, '2024-12-28', '18:00:00', 'Eye exam and vision correction.'),
(109, 'Layla Kamal', '01010111222', 20, 109, 'Dr. Sarah Kamal', '01121222333', 110, '2024-12-29', '19:00:00', 'ENT consultation for chronic sinusitis.');





INSERT INTO Visits (patient_id, visit_date, visitors_number)
VALUES
(100, '2024-12-01', 3),
(101, '2024-12-02', 2),
(102, '2024-12-03', 4),
(103, '2024-12-04', 1),
(104, '2024-12-05', 5),
(105, '2024-12-06', 2),
(106, '2024-12-07', 3),
(107, '2024-12-08', 6),
(108, '2024-12-09', 2),
(109, '2024-12-10', 4);



INSERT INTO Billings (patient_id, billing_description, billing_value, payment_status, billing_date, payment_method)
VALUES
(100, 'Cardiology Consultation and Heart Surgery', 1500.00, 'paid', '2024-12-01', 'credit'),
(101, 'Neurology Consultation and MRI Scan', 250.00, 'pending', '2024-12-02', 'cash'),
(102, 'Orthopedic Consultation and Knee Surgery', 2000.00, 'overdue', '2024-12-03', 'insurance'),
(103, 'Pediatric Checkup and Vaccinations', 500.00, 'paid', '2024-12-04', 'other'),
(104, 'General Surgery Consultation and Appendectomy', 1200.00, 'pending', '2024-12-05', 'credit'),
(105, 'Dermatology Consultation for Skin Rashes', 300.00, 'paid', '2024-12-06', 'cash'),
(106, 'Oncology Consultation and Chemotherapy', 800.00, 'overdue', '2024-12-07', 'insurance'),
(107, 'Gynecology Consultation and Hysterectomy', 1500.00, 'paid', '2024-12-08', 'credit'),
(108, 'Ophthalmology Consultation and Eye Surgery', 350.00, 'pending', '2024-12-09', 'cash'),
(109, 'ENT Consultation and Sinus Surgery', 1000.00, 'overdue', '2024-12-10', 'insurance');



INSERT INTO Machines (machine_name, time_of_purchase, department_id, room_id, price, about, is_working)
VALUES
('EKG Machine', '2023-06-15', 11, 101, 5000, 'Machine used for monitoring heart activity', 1),
('MRI Scanner', '2021-10-20', 12, 102, 30000, 'Machine for detailed brain and spine imaging', 1),
('X-Ray Machine', '2022-01-10', 13, 103, 15000, 'Machine for capturing internal body images', 1),
('Ventilator', '2023-03-05', 14, 104, 8000, 'Machine for assisting patients with breathing', 1),
('Ultrasound Machine', '2021-08-30', 15, 105, 12000, 'Machine used for imaging internal organs', 1),
('Dialysis Machine', '2022-07-25', 16, 106, 25000, 'Machine used for kidney dialysis treatment', 1),
('CT Scanner', '2020-12-15', 17, 107, 35000, 'Machine for detailed cross-sectional imaging of the body', 1),
('Defibrillator', '2021-09-02', 18, 108, 7000, 'Machine used to revive patients in case of heart failure', 1),
('Infusion Pump', '2022-04-17', 19, 109, 4000, 'Machine for controlling the flow of fluids into the patient', 1),
('Surgical Laser', '2023-05-10', 20, 110, 15000, 'Laser used for surgical procedures', 1);


-- Re-enable Foreign Key Constraints
EXEC sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL";