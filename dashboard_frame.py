from tkinter import Frame, Label, ttk, StringVar
import mysql.connector
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import matplotlib.pyplot as plt

class DashboardFrame(Frame):
    def __init__(self, master, db):
        super().__init__(master, bg="white")
        self.db = db
        self.pack(fill="both", expand=True) 

        Label(self, text="Dashboard", font=("Arial", 16, "bold"), bg="white").pack(pady=5)

        self.statistics_frame = Frame(self, bg="#f0f0f0")
        self.statistics_frame.pack(fill="x", padx=10, pady=5)

        self.employee_count_label = Label(self.statistics_frame, text="Employees: 0", bg="#f0f0f0", font=("Arial", 10))
        self.employee_count_label.grid(row=0, column=0, padx=5, pady=5, sticky="w")

        self.supplier_count_label = Label(self.statistics_frame, text="Suppliers: 0", bg="#f0f0f0", font=("Arial", 10))
        self.supplier_count_label.grid(row=1, column=0, padx=5, pady=5, sticky="w")

        self.item_count_label = Label(self.statistics_frame, text="Items: 0", bg="#f0f0f0", font=("Arial", 10))
        self.item_count_label.grid(row=2, column=0, padx=5, pady=5, sticky="w")

        self.filter_frame = Frame(self, bg="white")
        self.filter_frame.pack(fill="x", padx=10, pady=5)

        Label(self.filter_frame, text="Filter by:", bg="white", font=("Arial", 10)).grid(row=0, column=0, padx=5, pady=5, sticky="w")

        self.filter_var = StringVar()
        self.filter_var.set("Month")  
        self.filter_dropdown = ttk.Combobox(self.filter_frame, textvariable=self.filter_var, values=["Month", "Week", "Year"], width=10)
        self.filter_dropdown.grid(row=0, column=1, padx=5, pady=5, sticky="w")
        self.filter_dropdown.bind("<<ComboboxSelected>>", self.update_graphs)

        self.graph_frame = Frame(self, bg="white")
        self.graph_frame.pack(fill="both", expand=True, padx=10, pady=5)

        self.load_statistics()
        self.load_sales_graph()
        self.load_pie_chart()

    def load_statistics(self):
        """Load and display statistics for employees, suppliers, and items."""
        conn = self.db.get_connection()
        if conn:
            cursor = conn.cursor()

            cursor.execute("SELECT COUNT(*) FROM employee")
            employee_count = cursor.fetchone()[0]
            self.employee_count_label.config(text=f"Employees: {employee_count}")

            cursor.execute("SELECT COUNT(*) FROM supplier")
            supplier_count = cursor.fetchone()[0]
            self.supplier_count_label.config(text=f"Suppliers: {supplier_count}")

            cursor.execute("SELECT COUNT(*) FROM items")
            item_count = cursor.fetchone()[0]
            self.item_count_label.config(text=f"Items: {item_count}")

            cursor.close()
            conn.close()

    def load_sales_graph(self):
        """Load and display a graph of sales data."""
        conn = self.db.get_connection()
        if conn:
            cursor = conn.cursor()

            filter_type = self.filter_var.get()
            if filter_type == "Month":
                query = """
                    SELECT DATE_FORMAT(OrderDate, '%Y-%m') AS Period, SUM(TotalAmount) AS TotalSales
                    FROM customer_order
                    GROUP BY DATE_FORMAT(OrderDate, '%Y-%m')
                    ORDER BY Period
                """
            elif filter_type == "Week":
                query = """
                    SELECT DATE_FORMAT(OrderDate, '%Y-%U') AS Period, SUM(TotalAmount) AS TotalSales
                    FROM customer_order
                    GROUP BY DATE_FORMAT(OrderDate, '%Y-%U')
                    ORDER BY Period
                """
            elif filter_type == "Year":
                query = """
                    SELECT DATE_FORMAT(OrderDate, '%Y') AS Period, SUM(TotalAmount) AS TotalSales
                    FROM customer_order
                    GROUP BY DATE_FORMAT(OrderDate, '%Y')
                    ORDER BY Period
                """

            cursor.execute(query)
            sales_data = cursor.fetchall()

            cursor.close()
            conn.close()

            periods = [row[0] for row in sales_data]
            sales = [row[1] for row in sales_data]

            fig, ax = plt.subplots(figsize=(6, 3))
            ax.bar(periods, sales, color='skyblue')
            ax.set_xlabel(filter_type)
            ax.set_ylabel("Total Sales")
            ax.set_title(f"Sales by {filter_type}")

            if hasattr(self, 'sales_canvas'):
                self.sales_canvas.get_tk_widget().destroy()  
            self.sales_canvas = FigureCanvasTkAgg(fig, master=self.graph_frame)
            self.sales_canvas.draw()
            self.sales_canvas.get_tk_widget().pack(side="left", fill="both", expand=True)

    def load_pie_chart(self):
        """Load and display a pie chart of most sold items."""
        conn = self.db.get_connection()
        if conn:
            cursor = conn.cursor()

            cursor.execute("""
                SELECT i.ItemName, SUM(od.Quantity) AS TotalQuantity
                FROM custorder_details od
                JOIN items i ON od.ItemID = i.ItemID
                GROUP BY i.ItemName
                ORDER BY TotalQuantity DESC
                LIMIT 5
            """)
            items_data = cursor.fetchall()

            cursor.close()
            conn.close()

            items = [row[0] for row in items_data]
            quantities = [row[1] for row in items_data]

            fig, ax = plt.subplots(figsize=(4, 3))  
            ax.pie(quantities, labels=items, autopct='%1.1f%%', startangle=90, colors=plt.cm.Pastel1.colors)
            ax.set_title("Most Sold Items")

            if hasattr(self, 'pie_canvas'):
                self.pie_canvas.get_tk_widget().destroy()  
            self.pie_canvas = FigureCanvasTkAgg(fig, master=self.graph_frame)
            self.pie_canvas.draw()
            self.pie_canvas.get_tk_widget().pack(side="right", fill="both", expand=True)

    def update_graphs(self, event=None):
        """Update the graphs when the filter is changed."""
        self.load_sales_graph()
        self.load_pie_chart()