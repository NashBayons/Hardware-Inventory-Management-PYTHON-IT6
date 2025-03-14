from tkinter import Frame, Label, Entry, Button, ttk, messagebox, StringVar
import mysql.connector

class AuditFrame(Frame):
    def __init__(self, master, db):
        super().__init__(master, bg="white", width=950, height=500)
        self.db = db

        # Title
        title_label = Label(self, text="Audit Log", font=("Arial", 16, "bold"), bg="white")
        title_label.place(x=20, y=20)

        # Treeview for Audit Logs
        columns = ("Log ID", "Action Type", "Table Name", "Record ID", "Timestamp", "Old Value", "New Value", "Reason")
        self.audit_tree = ttk.Treeview(self, columns=columns, show="headings")
        
        # Set column widths
        self.audit_tree.column("Log ID", width=70, anchor="center")
        self.audit_tree.column("Action Type", width=100, anchor="center")
        self.audit_tree.column("Table Name", width=100, anchor="center")
        self.audit_tree.column("Record ID", width=80, anchor="center")
        self.audit_tree.column("Timestamp", width=120, anchor="center")
        self.audit_tree.column("Old Value", width=100, anchor="center")
        self.audit_tree.column("New Value", width=100, anchor="center")
        self.audit_tree.column("Reason", width=200, anchor="center")

        # Set column headings
        for col in columns:
            self.audit_tree.heading(col, text=col)

        # Place Treeview
        self.audit_tree.place(x=20, y=60, width=900, height=300)  # Adjusted width

        # Sort Frame
        self.sort_frame = Frame(self, bg="white")
        self.sort_frame.place(x=20, y=370)

        # Sort Label
        sort_label = Label(self.sort_frame, text="Filter by Table:", bg="white")
        sort_label.grid(row=0, column=0, padx=5, pady=5)

        # Sort Dropdown (Table Names)
        self.table_var = StringVar()
        self.table_var.set("All Tables")  # Default filter
        self.table_dropdown = ttk.Combobox(self.sort_frame, textvariable=self.table_var, 
                                           values=["All Tables", "employee", "supplier", "login/register", "po", "co"])
        self.table_dropdown.grid(row=0, column=1, padx=5, pady=5)
        self.table_dropdown.bind("<<ComboboxSelected>>", self.filter_audit_logs)

        # Search Frame
        search_label = Label(self, text="Search:", bg="white")
        search_label.place(x=20, y=400)
        self.audit_search_entry = Entry(self)
        self.audit_search_entry.place(x=80, y=400)

        search_button = Button(self, text="Search", command=self.search_audit_logs)
        search_button.place(x=250, y=395)

        # Load Audit Logs
        self.load_audit_logs()

    def load_audit_logs(self, table_name="All Tables", sort_by="Timestamp"):
        """Load audit logs from the database."""
        for item in self.audit_tree.get_children():
            self.audit_tree.delete(item)

        conn = self.db.get_connection()
        if conn:
            cursor = conn.cursor()
            try:
                # Build the query
                query = """
                    SELECT Log_ID, Action_Type, Table_Name, Record_ID, Timestamp, Old_value, New_value, Reason 
                    FROM audit_log 
                """

                # Add a WHERE clause if filtering by a specific table
                if table_name != "All Tables":
                    query += f" WHERE Table_Name = '{table_name}'"

                # Add ORDER BY clause
                query += f" ORDER BY {sort_by}"

                cursor.execute(query)
                rows = cursor.fetchall()
                for row in rows:
                    self.audit_tree.insert("", "end", values=row)
            except mysql.connector.Error as err:
                messagebox.showerror("Database Error", f"Error: {err}")
            finally:
                cursor.close()
                conn.close()

    def filter_audit_logs(self, event=None):
        """Filter audit logs based on the selected table."""
        table_name = self.table_var.get()
        self.load_audit_logs(table_name)

    def search_audit_logs(self):
        """Search audit logs based on the search term."""
        search_term = self.audit_search_entry.get().strip()

        for item in self.audit_tree.get_children():
            self.audit_tree.delete(item)

        conn = self.db.get_connection()
        if conn:
            cursor = conn.cursor()
            try:
                query = """
                    SELECT Log_ID, Action_Type, Table_Name, Record_ID, Timestamp, Old_value, New_value, Reason 
                    FROM audit_log 
                    WHERE Action_Type LIKE %s 
                    OR Table_Name LIKE %s 
                    OR Record_ID LIKE %s 
                    OR Reason LIKE %s
                """
                search_pattern = f"%{search_term}%"
                cursor.execute(query, (search_pattern, search_pattern, search_pattern, search_pattern))
                rows = cursor.fetchall()

                for row in rows:
                    self.audit_tree.insert("", "end", values=row)

                if not rows:
                    messagebox.showinfo("No Results", "No matching records found")

            except mysql.connector.Error as err:
                messagebox.showerror("Database Error", f"Error: {err}")
            finally:
                cursor.close()
                conn.close()