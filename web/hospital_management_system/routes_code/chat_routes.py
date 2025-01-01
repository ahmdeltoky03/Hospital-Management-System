# from flask import Flask, render_template, request, flash, redirect, url_for
from hospital_management_system.routes import *
import os
from langchain_mistralai import ChatMistralAI
from langchain import hub
from typing import TypedDict, Optional
from typing_extensions import Annotated
from langchain_community.tools.sql_database.tool import QuerySQLDatabaseTool
from langchain_community.utilities import SQLDatabase


secret_api = "cf1d1f01439c7cc8a809dcc6"


DRIVER_NAME = "ODBC Driver 17 for SQL Server"  # Use "SQL Server" if needed
SERVER_NAME = "DESKTOP-HG14PB9"
DATABASE_NAME = "Hospital"

database_url = f"mssql+pyodbc://@{SERVER_NAME}/{DATABASE_NAME}?driver={DRIVER_NAME.replace(' ', '+')}"

db = SQLDatabase.from_uri(database_url)

def run(api, question):
    if "MISTRAL_API_KEY" not in os.environ:
        os.environ["MISTRAL_API_KEY"] = api

    llm = ChatMistralAI(model="open-mistral-7b")

    query_prompt_template = hub.pull("langchain-ai/sql-query-system-prompt")

    assert len(query_prompt_template.messages) == 1
    query_prompt_template.messages[0] = query_prompt_template.messages[0] + """ 
        Note that the database consists of the following tables:
        
        - **Patients**: Stores patient-specific information, including personal details, phone number, room, bed, and status. 
            - Primary key: `patient_id`
            - Foreign keys: `room_id`, `bed_id` (references `Rooms` and `Beds`)
        
        - **Employees**: Contains hospital staff details like personal information, salary, hire date, and manager details.
            - Primary key: `employee_id`
            - Foreign key: `manager_id` (self-references `Employees`)

        - **Departments**: Defines different hospital departments (e.g., Cardiology, Surgery) with a head of department.
            - Primary key: `department_id`
            - Foreign key: `head_of_department` (references `Employees`)

        - **Doctors**: Inherits from `Employees` and includes additional fields specific to doctors, such as department, medical license, specialization, and number of operations performed.
            - Primary key: `doctor_id` (also references `employee_id` from `Employees`)
            - Foreign keys: `department_id` (references `Departments`), `appointment_room` (references `Rooms`)

        - **Nursing**: Inherits from `Employees` and contains nurse-specific data such as supervisor and shift schedules.
            - Primary key: `nurse_id` (also references `employee_id` from `Employees`)
            - Foreign keys: `department_id` (references `Departments`), `supervisor` (references `Employees`)

        - **Workers**: Inherits from `Employees` and captures information specific to workers, such as their role and department.
            - Primary key: `worker_id` (also references `employee_id` from `Employees`)
            - Foreign key: `department_id` (references `Departments`)

        - **Absense**: Records employee absences, including the reason, approval status, and the approver.
            - Primary key: `absense_id`
            - Foreign keys: `employee_id` (references `Employees`), `approved_by` (references `Employees`)

        - **Rooms**: Represents rooms in the hospital and their availability.
            - Primary key: `room_id`
            - Foreign key: `department_id` (references `Departments`)

        - **Beds**: Contains details about beds in each room and their availability.
            - Primary key: `bed_id`
            - Foreign key: `room_id` (references `Rooms`)

        - **Operations**: Records patient operations, including the operation type, date, and success status.
            - Primary key: `operation_id`
            - Foreign keys: `patient_id` (references `Patients`), `department_id` (references `Departments`), `room_id` (references `Rooms`)

        - **OperationDoctors**: Maps doctors to operations they are involved in.
            - Composite primary key: `operation_id`, `doctor_id`
            - Foreign keys: `operation_id` (references `Operations`), `doctor_id` (references `Employees`)

        - **Appointments**: Stores patient appointments with specific doctors and departments.
            - Primary key: `appointment_id`
            - Foreign keys: `patient_id` (references `Patients`), `doctor_id` (references `Employees`), `department_id` (references `Departments`), `room_id` (references `Rooms`)

        - **Visits**: Tracks patient visits by visitors, recording visit dates and visitor count.
            - Primary key: `visit_id`
            - Foreign key: `patient_id` (references `Patients`)

        - **Billings**: Contains patient billing information, including payment status and method.
            - Primary key: `billing_id`
            - Foreign key: `patient_id` (references `Patients`)

        - **Machines**: Records machines used in the hospital, their departments, and rooms.
            - Primary key: `machine_id`
            - Foreign keys: `department_id` (references `Departments`), `room_id` (references `Rooms`)

        ### Relationships Between Tables:
        - Employees table is referenced by **Doctors**, **Nursing**, **Workers**, and **Absense**.
        - **Doctors**, **Nursing**, and **Workers** inherit from the **Employees** table.
        - The **Operations** table is linked to both the **Patients** and **Departments** tables.
        - **Appointments** and **Visits** are related to **Patients**.

        ### Important Notes:
        - Patients must be recorded before any appointment or operation.
        - A patient is never removed from the system until they pay their billings (enforced through the `Billings` table).
        - **Foreign Key Constraints**: All tables have relevant foreign key relationships to ensure data integrity, with cascading actions for updates and deletions where applicable.

        Use this schema to understand the relationships between tables and to generate accurate SQL queries. You can use this structure to fetch data, join tables, and apply filtering conditions effectively.
    """

    class State(TypedDict):
        question: str
        query: str
        result: str
        answer: str

    class QueryOutput(TypedDict):
        """Generated SQL query."""

        query: Annotated[str, ..., "Syntactically valid SQL query."]

    def write_query(state: State):
        """Generate SQL query to fetch information."""
        prompt = query_prompt_template.invoke(
            {
                "dialect": db.dialect,
                "top_k": 10,
                "table_info": db.get_table_info(),
                "input": state["question"],
            }
        )
        structured_llm = llm.with_structured_output(QueryOutput)
        result = structured_llm.invoke(prompt)
        # query = result["query"].replace("LIMIT 10", "TOP 10")
        query = result["query"].replace("LIMIT", "TOP")
        return {"query": result["query"]}

    query = write_query({"question": f"{question}"})

    def execute_query(state: State):
        """Execute SQL query."""
        
        execute_query_tool = QuerySQLDatabaseTool(db=db)
        return {"result": execute_query_tool.invoke(state["query"])}

    db_result = execute_query({"query": f"{query['query']};"})

    def generate_answer(state: State):
        """Answer question using retrieved information as context."""
        prompt = (
            "Given the following user question, corresponding SQL query, "
            "and SQL result, answer the user question.\n\n"
            f'Question: {state["question"]}\n'
            f'SQL Query: {state["query"]}\n'
            f'SQL Result: {state["result"]}'
        )
        response = llm.invoke(prompt)
        return {"answer": response.content}

    return generate_answer({
        "question": f"{question}. Note that table (Employees) is not for patients but for the people who work in the hospital, and tables (Doctors, Nursing, Workers) are inherited from table (Employees) which contains common columns like (first_name, middle_name, last_name, age, ...)",
        "query": f"{query['query']};",
        "result": db_result["result"]
    })["answer"]

@app.route('/chat', methods=['GET', 'POST'])
def chat():
    answer = None
    if request.method == 'POST':
        api_key = request.form.get('api_key')
        question = request.form.get('question')

        if not api_key:
            flash("API Key is required!", "danger")
            return redirect(url_for('chat'))

        if not question:
            flash("Question is required!", "danger")
            return redirect(url_for('chat'))

        try:
            answer = run(api_key, question)
        except Exception as e:
            flash(f"Error: {str(e)}", "danger")

    return render_template('chat.html', answer=answer)

