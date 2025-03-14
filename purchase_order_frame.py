from tkinter import Frame, Label, Entry, Button, ttk, Listbox, END, StringVar, Radiobutton, messagebox, Text
from datetime import datetime, timedelta
import mysql.connector

class PurchaseOrderFrame(Frame):
    def __init__(self, master, db, session):
        super().__init__(master, bg="white", width=950, height=500)
        self.db = db
        self.session = session
        self.place(x=250, y=100)
        self.order_items = []
        self.order_total = 0.0
        self.EmpID = self.session.user_id


        Label(self, text="Order Information", font=("Arial", 12, "bold")).place(x=10, y=10)

        Label(self, text="EmployeeID:").place(x=10, y=40)

        self.employee_entry = ttk.Entry(self)
        self.employee_entry.insert(0, self.EmpID)  # Set initial value
        self.employee_entry.config(state='readonly')  # Make it read-only
        self.employee_entry.place(x=150, y=40)

        Label(self, text="Select Supplier:").place(x=10, y=70)
        self.supplier_combobox = ttk.Combobox(self, values=self.get_all_suppliers())
        self.supplier_combobox.place(x=150, y=70)

        Label(self, text="Received Date:").place(x=10, y=100)
        self.order_date_entry = Entry(self)
        self.order_date_entry.insert(0, datetime.now().strftime("%Y-%m-%d"))
        self.order_date_entry.config(state='readonly')
        self.order_date_entry.place(x=150, y=100)

        Label(self, text="Item Details", font=("Arial", 12, "bold")).place(x=10, y=170)

        self.item_type = StringVar()
        self.new_item_frame = Frame(self)
        self.new_item_frame.place(x=10, y=200)

        Label(self.new_item_frame, text="Item Name:").grid(row=0, column=0, sticky="w", padx=5, pady=2)
        self.item_name_entry = Entry(self.new_item_frame, width=30)
        self.item_name_entry.grid(row=0, column=1, padx=5, pady=2, sticky="w")

        Label(self.new_item_frame, text="Description:").grid(row=1, column=0, sticky="w", padx=5, pady=2)
        self.item_desc_entry = Entry(self.new_item_frame, width=40)
        self.item_desc_entry.grid(row=1, column=1, padx=5, pady=2, sticky="w")

        Label(self.new_item_frame, text="Category:").grid(row=2, column=0, sticky="w", padx=5, pady=2)

        self.item_category_combobox = ttk.Combobox(self.new_item_frame,
                                                   values=["Electronics", "Tools", "Hardware", "Furniture", "Other"],
                                                   width=30)
        self.item_category_combobox.grid(row=2, column=1, padx=5, pady=2, sticky="w")

        Label(self.new_item_frame, text="Quantity:").grid(row=3, column=0, sticky="w", padx=5, pady=2)
        self.quantity_entry = Entry(self.new_item_frame)
        self.quantity_entry.grid(row=3, column=1, padx=5, pady=2, sticky="w")

        Label(self.new_item_frame, text="Unit Price:").grid(row=4, column=0, sticky="w", padx=5, pady=2)
        self.unit_price_entry = Entry(self.new_item_frame)
        self.unit_price_entry.grid(row=4, column=1, padx=5, pady=2, sticky="w")

        add_item_button = Button(self, text="Add Item to Order", command=self.add_item_to_order)
        add_item_button.place(x=10, y=390)

        Label(self, text="Order Receipt", font=("Arial", 12, "bold")).place(x=350, y=10)
        self.receipt_text = Text(self, width=70, height=20, state='disabled')
        self.receipt_text.place(x=350, y=40)

        submit_button = Button(self, text="Submit Purchase Order", command=self.submit_purchase_order, bg="#4CAF50", fg="white", font=("Arial", 10, "bold"))
        submit_button.place(x=600, y=450)

        clear_receipt_button = Button(self, text="Clear Receipt", command=self.clear_receipt, bg="#FF6347", fg="white",
                                      font=("Arial", 10, "bold"))
        clear_receipt_button.place(x=600, y=420)

    def add_item_to_order(self):
        supplier_name = self.supplier_combobox.get()
        employee_id = self.employee_entry.get()  # Use employee_entry instead of employee_combobox
        quantity = self.quantity_entry.get()
        unit_price = self.unit_price_entry.get()

        if not supplier_name or not employee_id or not quantity or not unit_price:
            messagebox.showerror("Error", "Please fill in all required fields")
            return

        try:
            quantity = int(quantity)
            unit_price = float(unit_price)
            if quantity <= 0 or unit_price <= 0:
                raise ValueError("Quantity and Unit Price must be positive numbers")
        except ValueError as e:
            messagebox.showerror("Error", str(e))
            return

        item_total = quantity * unit_price

        item_name = self.item_name_entry.get()
        item_desc = self.item_desc_entry.get()
        item_category = self.item_category_combobox.get()

        if not item_name:
            messagebox.showerror("Error", "Please enter item name")
            return

        self.order_items.append({
                'ItemID': None,
                'product_name': item_name,
                'is_new_item': True,
                'description': item_desc,
                'category': item_category,  # Include category
                'quantity': quantity,
                'unit_price': unit_price,
                'item_total': item_total
            })

        self.order_total += item_total
        self.update_receipt()

        self.item_name_entry.delete(0, END)
        self.item_desc_entry.delete(0, END)
        self.item_category_combobox.delete(0, END)

        self.quantity_entry.delete(0, END)
        self.unit_price_entry.delete(0, END)

    def update_receipt(self):
        receipt_content = "=== Order Receipt ===\n"
        receipt_content += f"Order Date: {self.order_date_entry.get()}\n"
        receipt_content += f"Supplier: {self.supplier_combobox.get()}\n\n"
        receipt_content += "--- Items ---\n"

        for idx, item in enumerate(self.order_items, start=1):
            if item['is_new_item']:
                receipt_content += f"{idx}. New Item: {item['product_name']:10} (Category: {item['category']}) x{item['quantity']} @ ${item['unit_price']:.2f} each   -   ${item['item_total']:.2f}\n"
            else:
                receipt_content += f"{idx}. {item['product_name']:15} (Category: {item['category']}) x{item['quantity']} @ ${item['unit_price']:.2f} each   -   ${item['item_total']:.2f}\n"

        receipt_content += "\n--- Total ---\n"
        receipt_content += f"Order Total: ${self.order_total:.2f}\n"
        receipt_content += "====================="

        self.receipt_text.config(state='normal')
        self.receipt_text.delete(1.0, END)
        self.receipt_text.insert(END, receipt_content)
        self.receipt_text.config(state='disabled')

    def submit_purchase_order(self):
        if not self.order_items:
            messagebox.showerror("Error", "No items added to the purchase order.")
            return

        supplier_name = self.supplier_combobox.get()
        employee_id = self.employee_entry.get()  # Use employee_entry instead of employee_combobox
        order_date = self.order_date_entry.get()

        if not supplier_name or not employee_id or not order_date:
            messagebox.showerror("Error", "Please fill in all order details")
            return

        supplier_id = self.get_supplier_id(supplier_name)

        if not supplier_id:
            messagebox.showerror("Error", "Invalid supplier")
            return

        conn = self.db.get_connection()
        if not conn:
            return

        cursor = conn.cursor()
        try:
            cursor.execute("START TRANSACTION")

            # Insert the purchase order
            cursor.callproc('InsertOrder', [supplier_id, employee_id])
            cursor.execute("SELECT LAST_INSERT_ID()")
            order_id = cursor.fetchone()[0]
            print(order_id)
            # Insert order details
            for item in self.order_items:
                item_id = item.get('ItemID')

                if item_id is None and item['is_new_item']:
                    increased_price = item.get('unit_price') * 1.10

                    cursor.execute("""
                        INSERT INTO items 
                        (ItemName, Description, Category, Is_Serialized, Quantity_in_Stock, SellingPrice) 
                        VALUES (%s, %s, %s, %s, %s, %s)
                    """, (
                        item['product_name'],
                        item.get('description', ''),
                        item['category'],  # Include category
                        item.get('is_serialized', 0),
                        item.get('quantity', 0),
                        increased_price
                    ))
                    cursor.execute("SELECT LAST_INSERT_ID()")
                    item_id = cursor.fetchone()[0]

                    if not item_id:
                        messagebox.showerror("Error", "Failed to retrieve new ItemID after insertion!")
                        return

                cursor.execute("""
                    INSERT INTO order_details 
                    (OrderID, ItemID, Quantity, UnitPrice)
                    VALUES (%s, %s, %s, %s)
                """, (order_id, item_id, item['quantity'], item['unit_price']))

            # Log the action in the audit_log table
            self.db.log_audit(
                action_type="CREATE_PURCHASE_ORDER",
                table_name="Recieve_Order",  # Use 'po' as the table name
                record_id=order_id,
                reason=f"Purchase Order #{order_id} created by Employee ID {employee_id}"
            )

            conn.commit()
            messagebox.showinfo("Success", f"Purchase Order #{order_id} submitted successfully")

            self.clear_order_form()
        except mysql.connector.Error as err:
            conn.rollback()
            messagebox.showerror("Database Error", f"Error: {err}")
        finally:
            cursor.close()
            conn.close()

    def clear_order_form(self):
        self.supplier_combobox.set('')
        self.order_date_entry.delete(0, END)
        self.order_date_entry.insert(0, datetime.now().strftime("%Y-%m-%d"))

        if hasattr(self, 'item_name_entry'):
            self.item_name_entry.delete(0, END)
            self.item_desc_entry.delete(0, END)
            self.item_category_combobox.delete(0, END)

        self.quantity_entry.delete(0, END)
        self.unit_price_entry.delete(0, END)

        self.order_items = []
        self.order_total = 0.0
        self.update_receipt()

    def get_all_employees(self):
        conn = self.db.get_connection()
        if conn:
            cursor = conn.cursor()
            cursor.execute("SELECT EmpID, Emp_Name FROM employee")
            employees = cursor.fetchall()
            cursor.close()
            conn.close()
            return [f"{employee[1]} (ID: {employee[0]})" for employee in employees]
        return []

    def get_all_suppliers(self):
        conn = self.db.get_connection()
        if conn:
            cursor = conn.cursor()
            cursor.execute("SELECT SuppID, Supplier_Name FROM supplier")
            suppliers = cursor.fetchall()
            cursor.close()
            conn.close()
            return [supplier[1] for supplier in suppliers]
        return []

    def get_all_item(self):
        conn = self.db.get_connection()
        if conn:
            cursor = conn.cursor()
            cursor.execute("""
                SELECT i.ItemID, i.ItemName, i.Category, COALESCE(od.UnitPrice, 0) AS UnitPrice
                FROM items AS i
                LEFT JOIN order_details AS od ON i.ItemID = od.ItemID
            """)
            items = cursor.fetchall()
            cursor.close()
            conn.close()
            return [f"{item[1]} (${item[3]:.2f}) - Category: {item[2]}" for item in items]  # Include Category
        return []

    def get_product_id(self, product_name):
        conn = self.db.get_connection()
        if conn:
            cursor = conn.cursor()
            cursor.execute("SELECT ItemID FROM items WHERE ItemName = %s", (product_name,))
            product_id = cursor.fetchone()
            cursor.close()
            conn.close()
            return product_id[0] if product_id else None
        return None

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

    def clear_receipt(self):
        self.receipt_text.config(state='normal')
        self.receipt_text.delete(1.0, END)
        self.receipt_text.config(state='disabled')
