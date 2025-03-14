from tkinter import Frame, Label, Entry, Button, ttk, messagebox, Toplevel, StringVar
import bcrypt
import mysql.connector

class EmployeeFrame(Frame):
    def __init__(self, master, db, session):
        super().__init__(master, bg="white", width=950, height=500)
        self.db = db
        self.session = session
        self.current_user = self.session.user_id
        self.place(x=250, y=100)

        # Search Section
        search_label = Label(self, text="Search:", bg="white")
        search_label.place(x=20, y=20)
        self.search_entry = Entry(self)
        self.search_entry.place(x=80, y=20)

        search_button = Button(self, text="Search", command=self.search_employee)
        search_button.place(x=200, y=16)

        # Buttons for Add, Edit, Remove
        add_button = Button(self, text="Add", command=self.add_employee)
        add_button.place(x=260, y=16)
        edit_button = Button(self, text="Edit", command=self.edit_employee)
        edit_button.place(x=300, y=16)
        delete_button = Button(self, text="Remove", command=self.remove_employee)
        delete_button.place(x=340, y=16)

        # Treeview for Employees
        columns = ("EmpID", "Emp_Name", "Position", "Status", "CreatedByID", "CreatedDate", "UpdatedByID", "UpdatedDate")
        self.employee_tree = ttk.Treeview(self, columns=columns, show="headings")
        for col in columns:
            self.employee_tree.heading(col, text=col)
            self.employee_tree.column(col, width=100)
        self.employee_tree.place(x=20, y=50, width=900, height=400)

        # Load Employees
        self.load_employees()

    def search_employee(self):
        search_term = self.search_entry.get().strip()

        if not search_term:
            messagebox.showerror("Error", "Please enter a search term")
            return

        for item in self.employee_tree.get_children():
            self.employee_tree.delete(item)

        conn = self.db.get_connection()
        if conn:
            cursor = conn.cursor()
            try:
                query = """
                    SELECT * FROM employee 
                    WHERE EmpID LIKE %s 
                    OR Emp_Name LIKE %s 
                    OR Position LIKE %s
                """
                search_pattern = f"%{search_term}%"
                cursor.execute(query, (search_pattern, search_pattern, search_pattern))
                rows = cursor.fetchall()

                for row in rows:
                    self.employee_tree.insert("", "end", values=row)

                if not rows:
                    messagebox.showinfo("No Results", "No matching records found")

            except mysql.connector.Error as err:
                messagebox.showerror("Database Error", f"Error: {err}")
            finally:
                cursor.close()
                conn.close()

    def add_employee(self):
        add_window = Toplevel(self.master)
        add_window.title("Add Employee")
        add_window.geometry("350x300")

        # Form Fields
        Label(add_window, text="Name:").place(x=10, y=10)
        name_entry = Entry(add_window)
        name_entry.place(x=130, y=10)

        Label(add_window, text="Position:").place(x=10, y=40)
        position_entry = Entry(add_window)
        position_entry.place(x=130, y=40)

        Label(add_window, text="Username:").place(x=10, y=70)
        username_entry = Entry(add_window)
        username_entry.place(x=130, y=70)

        Label(add_window, text="Password:").place(x=10, y=100)
        password_entry = Entry(add_window, show="*")
        password_entry.place(x=130, y=100)

        Label(add_window, text="Confirm Password:").place(x=10, y=130)
        conpassword_entry = Entry(add_window, show="*")
        conpassword_entry.place(x=130, y=130)

        Label(add_window, text="Status:").place(x=10, y=160)
        status_var = StringVar(value="Inactive")
        status_entry = ttk.Combobox(add_window, textvariable=status_var, values=["Active", "Inactive"])
        status_entry.place(x=130, y=160)

        def save_employee():
            name = name_entry.get()
            position = position_entry.get()
            newusername_employee = username_entry.get()
            newpassword_employee = password_entry.get()
            newconpassword_employee = conpassword_entry.get()
            status = status_var.get()
            created_by = self.current_user
            updated_by = self.current_user

            if not name or not position or not newusername_employee or not newpassword_employee or not newconpassword_employee:
                messagebox.showerror("Error", "All fields are required")
                return

            if newconpassword_employee != newpassword_employee:
                messagebox.showerror("Error", "Passwords do not match")
                return

            newemp_hashed_password = bcrypt.hashpw(newpassword_employee.encode("utf-8"), bcrypt.gensalt())

            conn = self.db.get_connection()
            if conn:
                cursor = conn.cursor()
                try:
                    cursor.callproc('Insert_Employee', (
                        name, 
                        position, 
                        newusername_employee, 
                        newemp_hashed_password, 
                        created_by, 
                        updated_by, 
                        status
                    ))
                    conn.commit()

                    self.db.log_audit(
                        action_type="CREATE",
                        table_name="employee",
                        record_id=cursor.lastrowid,  
                        reason="New employee added"
                    )

                    messagebox.showinfo("Success", "Employee added successfully!")
                    add_window.destroy()
                    self.load_employees()
                except mysql.connector.Error as err:
                    messagebox.showerror("Database Error", f"Error: {err}")
                finally:
                    cursor.close()
                    conn.close()

        save_button = Button(add_window, text="Save", command=save_employee)
        save_button.place(x=100, y=200)

    def edit_employee(self):
        selected_item = self.employee_tree.selection()
        if not selected_item:
            messagebox.showerror("Error", "No employee selected")
            return

        emp_id = self.employee_tree.item(selected_item)["values"][0]

        edit_window = Toplevel(self.master)
        edit_window.title("Edit Employee")
        edit_window.geometry("300x250")

        conn = self.db.get_connection()
        if conn:
            cursor = conn.cursor()
            try:
                cursor.execute("SELECT * FROM employee WHERE EmpID = %s", (emp_id,))
                employee_data = cursor.fetchone()

                Label(edit_window, text="Name:").place(x=10, y=10)
                name_entry = Entry(edit_window)
                name_entry.insert(0, employee_data[1])
                name_entry.place(x=100, y=10)

                Label(edit_window, text="Position:").place(x=10, y=40)
                position_entry = Entry(edit_window)
                position_entry.insert(0, employee_data[2])
                position_entry.place(x=100, y=40)

                Label(edit_window, text="Status:").place(x=10, y=70)
                status_var = StringVar(value="Active" if employee_data[9] == "1" else "Inactive")
                status_entry = ttk.Combobox(edit_window, textvariable=status_var, values=["Active", "Inactive"])
                status_entry.place(x=100, y=70)

                def save_changes():
                    new_name = name_entry.get()
                    new_position = position_entry.get()
                    new_status = status_var.get()
                    if not new_name or not new_position:
                        messagebox.showerror("Error", "Name and Position are required")
                        return

                    updated_by = self.current_user

                    new_status_value = 1 if new_status == "Active" else 0

                    try:
                        cursor.callproc('UpdateEmployee', (emp_id, new_name, new_position, new_status_value, updated_by))
                        conn.commit()

                        # Log the update of an employee
                        self.db.log_audit(
                            action_type="UPDATE",
                            table_name="employee",
                            record_id=emp_id,
                            old_value=f"Name: {employee_data[1]}, Position: {employee_data[2]}, Status: {employee_data[3]}",
                            new_value=f"Name: {new_name}, Position: {new_position}, Status: {new_status}",
                            reason="Employee details updated"
                        )

                        messagebox.showinfo("Success", "Employee updated successfully")
                        edit_window.destroy()
                        self.load_employees()
                    except mysql.connector.Error as err:
                        messagebox.showerror("Database Error", f"Error: {err}")
                    finally:
                        cursor.close()
                        conn.close()

                save_button = Button(edit_window, text="Save", command=save_changes)
                save_button.place(x=100, y=110)

            except mysql.connector.Error as err:
                messagebox.showerror("Database Error", f"Error: {err}")
                cursor.close()
                conn.close()

    def remove_employee(self):
        selected_item = self.employee_tree.selection()
        if not selected_item:
            messagebox.showerror("Error", "No item selected")
            return

        emp_id = self.employee_tree.item(selected_item)["values"][0]

        conn = self.db.get_connection()
        if conn:
            cursor = conn.cursor()
            try:
                # Log the deletion of an employee
                cursor.execute("SELECT Emp_Name, Position, Status FROM employee WHERE EmpID = %s", (emp_id,))
                employee_data = cursor.fetchone()

                self.db.log_audit(
                    action_type="DELETE",
                    table_name="employee",
                    record_id=emp_id,
                    old_value=f"Name: {employee_data[0]}, Position: {employee_data[1]}, Status: {employee_data[2]}",
                    reason="Employee removed"
                )

                cursor.execute("DELETE FROM employee WHERE EmpID = %s", (emp_id,))
                conn.commit()
                self.employee_tree.delete(selected_item)
                messagebox.showinfo("Success", "Employee removed successfully")
            except mysql.connector.Error as err:
                messagebox.showerror("Database Error", f"Error: {err}")
            finally:
                cursor.close()
                conn.close()

    def load_employees(self):
        for item in self.employee_tree.get_children():
            self.employee_tree.delete(item)

        conn = self.db.get_connection()
        if conn:
            cursor = conn.cursor()
            try:
                cursor.execute("SELECT EmpID, Emp_Name, Position, Status, CreatedByID, CreatedDate, UpdatedByID, UpdatedDate FROM employee")
                rows = cursor.fetchall()
                for row in rows:
                    self.employee_tree.insert("", "end", values=row)
            except mysql.connector.Error as err:
                messagebox.showerror("Database Error", f"Error: {err}")
            finally:
                cursor.close()
                conn.close()