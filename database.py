import mysql.connector
from tkinter import messagebox

class Database:
    def __init__(self):
        self.conn = None
        self.connect_to_db()

    def connect_to_db(self):
        try:
            self.conn = mysql.connector.connect(
                host="localhost",
                user="root",
                password="",
                database="hardware_5",
            )
        except mysql.connector.Error as err:
            messagebox.showerror("Database Connection Error", f"Error: {err}")
            self.conn = None

    def get_connection(self):
        if self.conn is None or not self.conn.is_connected():
            self.connect_to_db()
        return self.conn

    def close_connection(self):
        if self.conn and self.conn.is_connected():
            self.conn.close()
            self.conn = None

    def log_audit(self, action_type, table_name, record_id=None, old_value=None, new_value=None, reason=None):
        conn = self.get_connection()
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