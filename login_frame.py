from tkinter import Frame, Label, Entry, Button, messagebox
from PIL import Image, ImageTk
import bcrypt
import mysql.connector

class LoginFrame(Frame):
    def __init__(self, master, db, app, session):
        super().__init__(master, bg="#f0f0f0", width=800, height=500)
        self.db = db
        self.app = app
        self.session = session
        self.place(x=50, y=100)
        self.create_login_widgets()

    def create_login_widgets(self):
        self.login_image = Image.open("image3.png")
        self.login_image = self.login_image.resize((400, 500), Image.Resampling.LANCZOS)
        self.login_photo = ImageTk.PhotoImage(self.login_image)
        self.image_label = Label(self, image=self.login_photo, bg="#f0f0f0")
        self.image_label.place(x=0, y=0)

        self.login_form_frame = Frame(self, bg="#f0f0f0", width=400, height=500)
        self.login_form_frame.place(x=400, y=0)

        self.login_label = Label(self.login_form_frame, text="Login", font=("Arial", 24, "bold"), bg="#f0f0f0", fg="#333333")
        self.login_label.place(x=100, y=50)

        self.username_label = Label(self.login_form_frame, text="Username:", font=("Arial", 12), bg="#f0f0f0", fg="#333333")
        self.username_label.place(x=50, y=150)
        self.username_entry = Entry(self.login_form_frame, font=("Arial", 12), bd=2, relief="groove")
        self.username_entry.place(x=150, y=150, width=200, height=30)

        self.password_label = Label(self.login_form_frame, text="Password:", font=("Arial", 12), bg="#f0f0f0", fg="#333333")
        self.password_label.place(x=50, y=200)
        self.password_entry = Entry(self.login_form_frame, font=("Arial", 12), show="*", bd=2, relief="groove")
        self.password_entry.place(x=150, y=200, width=200, height=30)

        self.login_button = Button(self.login_form_frame, text="Login", font=("Arial", 12), bg="#4CAF50", fg="white", bd=0,
                                   command=self.login, cursor="hand2")
        self.login_button.place(x=150, y=250, width=100, height=40)
        self.register_button = Button(self.login_form_frame, text="Register", font=("Arial", 12), bg="#2196F3", fg="white", bd=0,
                                      command=self.show_register, cursor="hand2")
        self.register_button.place(x=50, y=450, width=100, height=40)

    def login(self):
        entered_username = self.username_entry.get()
        entered_password = self.password_entry.get()

        conn = self.db.get_connection()
        if conn is None:
            messagebox.showerror("Database Error", "Could not establish a connection to the database.")
            return

        cursor = conn.cursor(buffered=True)  # Use a buffered cursor
        try:
            # Execute the query to fetch user details
            cursor.execute("SELECT username, password, EmpID, status FROM employee WHERE username = %s", (entered_username,))
            result = cursor.fetchone()  # Fetch the result
            if result:
                stored_password = result[1]
                user_status = result[3]

                # Check if the status is active (1) or "Active" (if stored as text)
                if user_status == 'Inactive' or user_status == 0:
                    messagebox.showerror("Login Failed", "Your account is inactive. Please contact support.")
                    return

                # Check password with bcrypt
                if bcrypt.checkpw(entered_password.encode("utf-8"), stored_password.encode("utf-8")):
                    self.session.set_user(result[2], result[0])
                    print(f"Logged in as {self.session.username} (ID: {self.session.user_id})")

                    # Log the audit trail
                    self.db.log_audit(
                        action_type="LOGIN",
                        table_name="employee",
                        record_id=self.session.user_id,
                        reason="User logged in successfully"
                    )

                    messagebox.showinfo("Login Success", f"Welcome, {self.session.username}!")
                    self.app.show_frame("Dashboard")
            else:
                # Log failed login attempt
                self.db.log_audit(
                    action_type="LOGIN_FAILED",
                    table_name="employee",
                    reason=f"Failed login attempt for username: {entered_username}"
                )
                messagebox.showerror("Login Failed", "Invalid username or password")
        except mysql.connector.Error as err:
            messagebox.showerror("Login Error", f"Error: {err}")
        finally:
            # Ensure the cursor and connection are properly closed
            cursor.close()
            conn.close()

    def show_register(self):
        self.clear_widgets()
        self.create_register_widgets()

    def create_register_widgets(self):
        self.login_label.config(text="Register", font=("Arial", 24, "bold"))

        self.fullname_label = Label(self.login_form_frame, text="Full Name:", font=("Arial", 12), bg="#f0f0f0", fg="#333333")
        self.fullname_label.place(x=50, y=100)
        self.fullname_entry = Entry(self.login_form_frame, font=("Arial", 12), bd=2, relief="groove")
        self.fullname_entry.place(x=150, y=100, width=200, height=30)

        self.Position_label = Label(self.login_form_frame, text="Position:", font=("Arial", 12), bg="#f0f0f0", fg="#333333")
        self.Position_label.place(x=50, y=150)
        self.Position_entry = Entry(self.login_form_frame, font=("Arial", 12), bd=2, relief="groove")
        self.Position_entry.place(x=150, y=150, width=200, height=30)

        # Username Field
        self.username_label = Label(self.login_form_frame, text="Username:", font=("Arial", 12), bg="#f0f0f0", fg="#333333")
        self.username_label.place(x=50, y=200)
        self.reg_username_entry = Entry(self.login_form_frame, font=("Arial", 12), bd=2, relief="groove")
        self.reg_username_entry.place(x=150, y=200, width=200, height=30)

        self.password_label = Label(self.login_form_frame, text="Password:", font=("Arial", 12), bg="#f0f0f0", fg="#333333")
        self.password_label.place(x=50, y=250)
        self.reg_password_entry = Entry(self.login_form_frame, font=("Arial", 12), show="*", bd=2, relief="groove")
        self.reg_password_entry.place(x=150, y=250, width=200, height=30)

        self.confirm_password_label = Label(self.login_form_frame, text="Confirm Password:", font=("Arial", 12), bg="#f0f0f0", fg="#333333")
        self.confirm_password_label.place(x=50, y=300)
        self.confirm_password_entry = Entry(self.login_form_frame, font=("Arial", 12), show="*", bd=2, relief="groove")
        self.confirm_password_entry.place(x=150, y=300, width=200, height=30)

        self.save_button = Button(self.login_form_frame, text="Save", font=("Arial", 12), bg="#4CAF50", fg="white", bd=0,
                                  command=self.register_user, cursor="hand2")
        self.save_button.place(x=150, y=350, width=100, height=40)

        self.back_button = Button(self.login_form_frame, text="Back to Login", font=("Arial", 12), bg="#2196F3", fg="white", bd=0,
                                  command=self.back_to_login, cursor="hand2")
        self.back_button.place(x=50, y=350, width=120, height=40)

    def clear_widgets(self):
        for widget in self.login_form_frame.winfo_children():
            widget.place_forget()

    def back_to_login(self):
        self.clear_widgets()
        self.create_login_widgets()

    def register_user(self):
        fullname = self.fullname_entry.get()
        Position = self.Position_entry.get()
        username = self.reg_username_entry.get()
        password = self.reg_password_entry.get()
        confirm_password = self.confirm_password_entry.get()

        if not fullname or not Position or not username or not password or not confirm_password:
            messagebox.showerror("Error", "All fields are required")
            return

        if password != confirm_password:
            messagebox.showerror("Error", "Passwords do not match")
            return

        hashed_password = bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt())

        conn = self.db.get_connection()
        if conn:
            cursor = conn.cursor(buffered=True)  # Use a buffered cursor
            try:
                print("Calling stored procedure...")
                cursor.callproc('Insert_Employee', (fullname, Position, username, hashed_password, 0, 0))

                print("Fetching stored procedure results...")
                for result in cursor.stored_results():
                    print(result.fetchall())  # Fetch and log all results

                print("Committing transaction...")
                conn.commit()

                # Log the audit trail
                self.db.log_audit(
                    action_type="REGISTER",
                    table_name="employee",
                    record_id=cursor.lastrowid,
                    reason="New user registered"
                )

                print("Registration successful!")
                messagebox.showinfo("Success", "Registration successful!")
                self.back_to_login()
            except mysql.connector.Error as err:
                print(f"Database Error: {err}")
                messagebox.showerror("Database Error", f"Error: {err}")
            finally:
                print("Closing cursor and connection...")
                cursor.close()
                conn.close()