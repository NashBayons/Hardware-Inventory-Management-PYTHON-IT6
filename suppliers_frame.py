from tkinter import Frame, Label, Entry, Button, ttk, messagebox, Toplevel
import mysql.connector

class SuppliersFrame(Frame):
    def __init__(self, master, db):
        super().__init__(master, bg="white", width=950, height=500)
        self.db = db
        self.place(x=250, y=100)

        search_label = Label(self, text="Search:", bg="white")
        search_label.place(x=20, y=20)
        self.search_entry = Entry(self)
        self.search_entry.place(x=80, y=20)

        search_button = Button(self, text="Search", command=self.search_supplier)
        search_button.place(x=200, y=16)

        add_button = Button(self, text="Add", command=self.insert_supplier)
        add_button.place(x=260, y=16)
        edit_button = Button(self, text="Edit", command=self.edit_supplier)
        edit_button.place(x=300, y=16)

        columns = ("SuppID", "Supplier Name", "Contact", "Status")
        self.supplier_tree = ttk.Treeview(self, columns=columns, show="headings")
        for col in columns:
            self.supplier_tree.heading(col, text=col)
            self.supplier_tree.column(col, width=100)
        self.supplier_tree.place(x=20, y=50, width=900, height=400)
        self.supplier_tree.bind("<ButtonRelease-1>", self.on_select_supplier)
        self.load_suppliers()

    def search_supplier(self):
        search_term = self.search_entry.get().strip()

        if not search_term:
            messagebox.showerror("Error", "Please enter a search term")
            return
        for item in self.supplier_tree.get_children():
            self.supplier_tree.delete(item)

        conn = self.db.get_connection()
        if conn:
            cursor = conn.cursor()
            try:
                query = """
                            SELECT * FROM supplier
                            WHERE SuppID LIKE %s 
                            OR Supplier_Name LIKE %s 
                            OR Contact LIKE %s
                        """
                search_pattern = f"%{search_term}%"
                cursor.execute(query, (search_pattern, search_pattern, search_pattern))
                rows = cursor.fetchall()

                for row in rows:
                    self.supplier_tree.insert("", "end", values=row)

                if not rows:
                    messagebox.showinfo("No Results", "No matching records found")

            except mysql.connector.Error as err:
                messagebox.showerror("Database Error", f"Error: {err}")
            finally:
                cursor.close()
                conn.close()

    def insert_supplier(self):
        add_window = Toplevel(self.master)
        add_window.title("Add Supplier")
        add_window.geometry("300x200")

        Label(add_window, text="Name:").place(x=10, y=10)
        name_entry = Entry(add_window)
        name_entry.place(x=100, y=10)

        Label(add_window, text="Contact:").place(x=10, y=40)
        contact_entry = Entry(add_window)
        contact_entry.place(x=100, y=40)

        def save_supplier():
            name = name_entry.get()
            contact = contact_entry.get()

            if not name or not contact:
                messagebox.showerror("Error", "Name and Contact are required")
                return

            conn = self.db.get_connection()
            if conn:
                cursor = conn.cursor()
                try:
                    cursor.callproc('InsertSuppliers', (name, contact))
                    conn.commit()

                    # Get the ID of the newly added supplier
                    cursor.execute("SELECT LAST_INSERT_ID()")
                    supplier_id = cursor.fetchone()[0]

                    # Log the addition of the new supplier
                    self.log_audit(
                        action_type="CREATE",
                        table_name="supplier",
                        record_id=supplier_id,
                        new_value=f"Name: {name}, Contact: {contact}",
                        reason="New supplier added"
                    )

                    messagebox.showinfo("Success", "Supplier added successfully")
                    add_window.destroy()
                    self.load_suppliers()
                except mysql.connector.Error as err:
                    messagebox.showerror("Database Error", f"Error: {err}")
                finally:
                    cursor.close()
                    conn.close()

        save_button = Button(add_window, text="Save", command=save_supplier)
        save_button.place(x=100, y=80)

    def edit_supplier(self):
        if not hasattr(self, 'selected_supplier'):
            messagebox.showwarning("No Selection", "Please select a supplier to edit")
            return

        supplier_id, name, contact, is_active = self.selected_supplier

        edit_window = Toplevel(self.master)
        edit_window.title("Edit Supplier")
        edit_window.geometry("300x200")

        Label(edit_window, text="Name:").place(x=10, y=10)
        name_entry = Entry(edit_window)
        name_entry.insert(0, name)  
        name_entry.place(x=100, y=10)

        Label(edit_window, text="Contact:").place(x=10, y=40)
        contact_entry = Entry(edit_window)
        contact_entry.insert(0, contact)  
        contact_entry.place(x=100, y=40)

        Label(edit_window, text="is Active:").place(x=10, y=70)
        is_active = ttk.Combobox(edit_window, values=["Active","Inactive"])
        if is_active == 1:
            is_active.set("Active")
        else:
            is_active.set("Inactive")
        is_active.place(x=100, y=70)

        def save_changes():
            new_name = name_entry.get()
            new_contact = contact_entry.get()
            new_is_active = is_active.get().strip()
            if not new_name or not new_contact:
                messagebox.showerror("Error", "Name and Contact are required")
                return

            if new_is_active == "Active":
                new_is_active = 1
            elif new_is_active == "Inactive":
                new_is_active = 0
            else:
                messagebox.showerror("Error", "Invalid selection for 'is Active'")
                return

            conn = self.db.get_connection()
            if conn:
                cursor = conn.cursor()
                try:
                    cursor.callproc('updateSuppliers', (supplier_id, new_name, new_contact, new_is_active))
                    conn.commit()

                    # Log the update of the supplier
                    self.log_audit(
                        action_type="UPDATE",
                        table_name="supplier",
                        record_id=supplier_id,
                        old_value=f"Name: {name}, Contact: {contact}",
                        new_value=f"Name: {new_name}, Contact: {new_contact}",
                        reason="Supplier details updated"
                    )

                    messagebox.showinfo("Success", "Supplier updated successfully")
                    edit_window.destroy()
                    self.load_suppliers()
                except mysql.connector.Error as err:
                    messagebox.showerror("Database Error", f"Error: {err}")
                finally:
                    cursor.close()
                    conn.close()

        save_button = Button(edit_window, text="Save", command=save_changes)
        save_button.place(x=100, y=100)

    def on_select_supplier(self, event):
        selected_item = self.supplier_tree.selection()
        if selected_item:
            self.selected_supplier = self.supplier_tree.item(selected_item[0])['values']

    def load_suppliers(self):
        for item in self.supplier_tree.get_children():
            self.supplier_tree.delete(item)

        conn = self.db.get_connection()
        if conn:
            cursor = conn.cursor()
            try:
                cursor.execute("SELECT * FROM supplier")
                rows = cursor.fetchall()

                for row in rows:
                    active_status = "Active" if row[3] == 1 else "Inactive"
                    self.supplier_tree.insert("", "end", values=(row[0], row[1], row[2], active_status))

                if not rows:
                    messagebox.showinfo("No Results", "No suppliers found")

            except mysql.connector.Error as err:
                messagebox.showerror("Database Error", f"Error: {err}")
            finally:
                cursor.close()
                conn.close()

    def get_supplier_id(self, supplier_name):
        conn = self.db.get_connection()
        if conn:
            cursor = conn.cursor()
            cursor.execute("SELECT SuppID FROM supplier WHERE Supplier_Name = %s", (supplier_name,))
            supplier_id = cursor.fetchone()
            cursor.close()
            conn.close()
            return supplier_id[0] if supplier_id else None
        return None

    def log_audit(self, action_type, table_name, record_id=None, old_value=None, new_value=None, reason=None):
        """
        Log an action to the audit_log table.

        Parameters:
            action_type (str): The type of action (e.g., CREATE, UPDATE, DELETE).
            table_name (str): The name of the table being affected.
            record_id (str/int): The ID of the record being modified.
            old_value (str): The old value of the record (for updates).
            new_value (str): The new value of the record (for updates or creations).
            reason (str): Additional information about the action.
        """
        conn = self.db.get_connection()
        if conn:
            cursor = conn.cursor()
            try:
                query = """
                    INSERT INTO audit_log (Action_Type, Table_Name, Record_ID, Old_value, New_value, Reason)
                    VALUES (%s, %s, %s, %s, %s, %s)
                """
                cursor.execute(query, (action_type, table_name, record_id, old_value, new_value, reason))
                conn.commit()
            except mysql.connector.Error as err:
                messagebox.showerror("Audit Log Error", f"Error logging audit: {err}")
            finally:
                cursor.close()
                conn.close()