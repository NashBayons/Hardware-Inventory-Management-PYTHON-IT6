from tkinter import *
from tkinter import ttk, messagebox
import mysql.connector
from datetime import datetime, timedelta

class SalesReportFrame(Frame):
    def __init__(self, root, db):
        super().__init__(root, bg="white", width=1080, height=600)
        self.db = db
        self.create_sales_frame()

    def create_sales_frame(self):
        title_label = Label(self, text="Sales Report", font=("Arial", 16, "bold"), bg="white")
        title_label.place(x=20, y=20)

        columns = ("Sale ID", "Customer Name", "Sale Date", "Item ID", "Quantity", "Total Amount", "Order ID", "Order Timestamp")
        self.sales_tree = ttk.Treeview(self, columns=columns, show="headings")
        for col in columns:
            self.sales_tree.heading(col, text=col)
            self.sales_tree.column(col, width=120)
        self.sales_tree.place(x=20, y=60, width=1000, height=300)

        filter_label = Label(self, text="Filter by:", bg="white")
        filter_label.place(x=20, y=400)

        self.filter_option = ttk.Combobox(self, values=["Daily", "Weekly", "Monthly", "Yearly"])
        self.filter_option.place(x=80, y=400)
        self.filter_option.set("Daily")

        filter_button = Button(self, text="Apply Filter", command=self.filter_sales)
        filter_button.place(x=250, y=395)

        refresh_button = Button(self, text="Refresh", command=self.reset_to_daily)
        refresh_button.place(x=350, y=395)

        self.total_sales_label = Label(self, text="Total Sales: $0.00", font=("Arial", 12, "bold"), bg="white")
        self.total_sales_label.place(x=20, y=480)
        self.load_sales()

    def reset_to_daily(self):
        self.filter_option.set("Daily")
        self.filter_sales()

    def load_sales(self, filter_query="", filter_values=()):
        self.sales_tree.delete(*self.sales_tree.get_children())

        conn = self.db.get_connection()
        if conn:
            cursor = conn.cursor()
            try:
                base_query = """
                    SELECT 
                            o.OrderID AS SaleID, 
                            o.CustomerName, 
                            o.OrderDate AS SaleDate, 
                            d.ItemID, 
                            d.Quantity, 
                            o.TotalAmount, 
                            o.OrderID, 
                            o.OrderTimestamp
                            FROM customer_order o
                            JOIN custorder_details d ON o.OrderID = d.OrderID
                """

                # Append filter query if provided
                full_query = base_query + filter_query
                cursor.execute(full_query, filter_values)
                rows = cursor.fetchall()
                for row in rows:
                    self.sales_tree.insert("", "end", values=row)

                total_sales = sum(row[5] for row in rows)
                self.total_sales_label.config(text=f"Total Sales: ${total_sales:.2f}")

            except mysql.connector.Error as err:
                messagebox.showerror("Database Error", f"Error: {err}")
            finally:
                cursor.close()
                conn.close()

    def filter_sales(self):
        filter_type = self.filter_option.get()
        today = datetime.today()

        if filter_type == "Daily":
            start_date = today.strftime('%Y-%m-%d')
            end_date = (today + timedelta(days=1)).strftime('%Y-%m-%d')
        elif filter_type == "Weekly":
            start_date = (today - timedelta(days=7)).strftime('%Y-%m-%d')
            end_date = today.strftime('%Y-%m-%d')
        elif filter_type == "Monthly":
            start_date = (today - timedelta(days=30)).strftime('%Y-%m-%d')
            end_date = today.strftime('%Y-%m-%d')
        elif filter_type == "Yearly":
            start_date = (today - timedelta(days=365)).strftime('%Y-%m-%d')
            end_date = today.strftime('%Y-%m-%d')
        else:
            start_date = end_date = None

        if start_date and end_date:
            filter_query = " WHERE o.OrderDate >= %s AND o.OrderDate < %s"
            filter_values = (start_date, end_date)
        else:
            filter_query = ""
            filter_values = ()

        self.load_sales(filter_query, filter_values)
