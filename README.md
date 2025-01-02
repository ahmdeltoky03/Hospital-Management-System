# 🏥 **Hospital Management System**
A hospital database project designed to manage and integrate hospital operations, leveraging AI for intelligent data retrieval and optimized workflows across departments, machines, rooms, and patient management.

## 🎥 Project Demo

https://github.com/user-attachments/assets/c33823ae-7d6a-4f2e-b4f1-ed1edf635b79


## 🚀 Getting Started

To be familiar with this project and set it up, you need to ensure the required dependencies are installed.

#### Prerequisites
  - Python **3.8** or above (preferably **Miniconda** or **Anaconda**)
  - Pip (Python package installer)

### Installation Steps

1 - Clone the repository: 

      git clone https://github.com/eslam-khalifa/Hospital-Management-System.git
      cd hospital-management-system
2 - Install the required python packages:

      pip install flask pyodbc langchain langchain-mistralai langchain-community
3 - Run the application:

      python app.py

4 - Set up your Microsoft SQL Server database and update the connection details in the project.
      
      open __init__.py set server = your_own_server_name
      database = 'HOSPITAL'   # database_name
      driver = "ODBC Driver 17 for SQL Server"  # use an available ODBC driver
    
5 - Open your web browser and navigate to http://127.0.0.1:5000


## 🛠️ **Technologies Used**

### Frontend Technologies
- #### HTML/CSS/JavaScript:  
   Implements a clean, intuitive, and interactive interface to ensure a seamless user experience.

- #### Bootstrap Framework:  
   Utilized for responsive and consistent design, making the application visually appealing and mobile-friendly.

### Backend (Integration) Technologies
- #### Microsoft SQL Server:  
   The primary database used for storing and managing all hospital-related data, ensuring scalab!
ility and reliability.

- #### Stored Procedures:  
   Used for efficiently handling CRUD operations (Create, Read, Update, Delete) across all tabs, optimizing performance.

- #### Triggers:  
   Automated mechanisms to maintain data integrity, such as logging changes or performing additional actions when certain events occur.

- #### Flask:  
   The web application framework that handles routing, user requests, and serves as the foundation of the backend.

- #### PyODBC:  
   A Python library that connects the Flask backend to the Microsoft SQL Server database, enabling smooth communication.

- #### LangChain (RAG):  
   Facilitates enhanced data retrieval capabilities, providing intelligent querying when integrated into the system.


## 📂 Project Parts


### 🏠 Home Tab

#### Overview
The **Home Tab** serves as the landing page and acts as the welcome screen for users. It provides quick access to key features of the hospital management system, including employee search, appointments, and other sections.

#### Features

- **Welcome Message**  
   Greets the user with a personalized welcome message.

- **Quick Links to Employee Search**  
   Provides direct links to search for employees, making it easier to find specific hospital staff.

- **Appointments Button**  
   Allows users to quickly access and manage patient appointments, with the option to schedule, view, or update appointments.

- **Navigation Shortcuts**  
   Offers quick access to other sections like Departments, Machines, Rooms, and more.

- **System Notifications**  
   Displays any important system updates or alerts, such as pending approvals or maintenance schedules.

#### Example Use Case

- **Welcome Screen and Navigation**  
   Upon logging in, the user is welcomed and can easily navigate to find specific employees, manage appointments, or check other system tabs. 



### 🏢 Departments Tab

#### Overview
The **Departments Tab** allows users to manage department-related information efficiently, facilitating hospital operations.

#### Features

- **Add New Department**  
   Add a new department by providing necessary details (e.g., Department Name, Head of Department).

- **Update Department Details**  
   Modify existing department details, such as department name or head of department.

- **Delete a Department**  
   Remove a department that is no longer relevant.

- **Search Functionality**  
   Search for departments by name, head ID, or head name.

#### Example Use Case

- **Adding a Department**  
   Navigate to the **Departments Tab**, fill in the form, and click **Submit**.

- **Searching for a Department**  
   Enter a keyword (e.g., "Cardiology") to view search results.

---



### 🖥️ Machines Tab

#### Overview
The **Machines Tab** helps manage information about hospital machinery and ensures proper maintenance.

#### Features

- **Add New Machine**  
   Input machine details like name, ID, and department association.

- **Update Machine Details**  
   Modify machine maintenance schedules or department assignments.

- **Delete a Machine**  
   Remove obsolete or decommissioned machinery.

- **Search Functionality**  
   Search by Machine Name, Machine ID, or Department.

---

### 🏨 Rooms Tab

#### Overview
The **Rooms Tab** manages information about hospital rooms, including availability and assignments.

#### Features

- **Add New Room**  
   Add details like Room Number, Room Type (ICU, General Ward), and Status.

- **Update Room Details**  
   Modify room status or type.

- **Delete a Room**  
   Remove rooms that are no longer in use.

- **Search Functionality**  
   Search by Room Number or Room Type.

---

### 🛠️ Others Tab

#### Overview
The **Others Tab** encompasses additional functionalities, such as managing absence records, operations, visits, and bills.

#### Features

- **Manage Absence Records**  
   Add, update, or delete staff absence details.

- **Operations Management**  
   Record and track surgical operations.

- **Visit Management**  
   Log patient visits and their outcomes.

- **Bill Management**  
   Generate and manage billing records.

---
### ⚙️ API and Question Input Page

The **API and Question Input Page** allows users to submit queries and interact with the hospital database in a user-friendly way.

#### Features

- **User Query Submission**  
   Users input queries related to the hospital database.

- **SQL Query Generation**  
   The system dynamically generates SQL queries based on the user's input.

- **Result Display**  
   Results are fetched from the database and displayed directly on the page.

- **Error Handling**  
   The system gracefully handles errors and ensures smooth user interaction.

#### How It Works

1. The user enters a query in the input field.
2. The system generates an SQL query and executes it on the backend.
3. The results are displayed on the page, with error handling if necessary.

---

### 📄 About Us Tab

#### Overview
The **About Us Tab** provides information about the development team and the purpose of the hospital database project.

#### Features

- **Team Member Profiles**  
   Displays names, roles, and contact information of team members.

- **Project Purpose**  
   Explains the objectives and scope of the project.

---


## 👥 Team Members

Our dedicated team of developers and contributors has worked tirelessly to bring this hospital management system to life. Below are the team members responsible for the project:

### . Ibrahim Hisham 
- **GitHub**: https://github.com/Ibrahim2021Hisham

### . Ahmed Eltokhy  
- **GitHub**: https://github.com/ahmdeltoky03

### . Ahmed Adel  
- **GitHub**: https://github.com/ahmeda335

### . Eslam Khalifa
- **GitHub**: https://github.com/eslam-khalifa

### . Mohamed Rehab 
- **GitHub**: https://github.com/mohammedrehab288

### . Mohamed Karam  
- **GitHub**: https://github.com/mohammed-karam

---

## 🛠️ **Upcoming Features**

- **Authentication & Authorization**
- **Fixing Some Bugs**
- **Adding CRUD Operations to Appointements Page**

---

We greatly appreciate the collaboration and dedication of each team member. For any inquiries or suggestions, feel free to reach out to us!