import tkinter as tk
from tkinter import ttk, messagebox
import mysql.connector
from datetime import datetime

class CustomerOrderFrame(tk.Frame):
    def __init__(self, master, db, session):
        super().__init__(master)
        self.db = db
        self.session = session
        self.item_dict = {}
        self.selected_items = []
        self.current_EmpId = self.session.user_id

        self.configure(padx=20, pady=20, bg="#f0f0f0")

        # Order ID (Auto-generated, display only)
        tk.Label(self, text="Order ID (Auto):", bg="#f0f0f0").grid(row=0, column=0, padx=10, pady=5, sticky="w")
        self.order_id_label = tk.Label(self, text="(Auto-generated)", bg="#f0f0f0")
        self.order_id_label.grid(row=0, column=1, padx=10, pady=5, sticky="w")

        # Customer Name
        tk.Label(self, text="Customer Name:", bg="#f0f0f0").grid(row=1, column=0, padx=10, pady=5, sticky="w")
        self.customer_name_entry = tk.Entry(self)
        self.customer_name_entry.grid(row=1, column=1, padx=10, pady=5)

        # Order Date (Auto)
        tk.Label(self, text="Order Date:", bg="#f0f0f0").grid(row=2, column=0, padx=10, pady=5, sticky="w")
        self.order_date_label = tk.Label(self, text=str(datetime.now().strftime('%Y-%m-%d %H:%M:%S')), bg="#f0f0f0")
        self.order_date_label.grid(row=2, column=1, padx=10, pady=5, sticky="w")

        # Item Dropdown
        tk.Label(self, text="Select Item:", bg="#f0f0f0").grid(row=3, column=0, padx=10, pady=5, sticky="w")
        self.item_dropdown = ttk.Combobox(self)
        self.item_dropdown.grid(row=3, column=1, padx=10, pady=5)

        # Quantity Entry
        tk.Label(self, text="Quantity:", bg="#f0f0f0").grid(row=4, column=0, padx=10, pady=5, sticky="w")
        self.quantity_entry = tk.Entry(self)
        self.quantity_entry.grid(row=4, column=1, padx=10, pady=5)

        # Add Item Button
        tk.Button(self, text="Add Item", command=self.add_item).grid(row=5, column=1, padx=10, pady=5)

        # Items Listbox
        self.items_listbox = tk.Listbox(self, width=60, height=10)
        self.items_listbox.grid(row=6, column=0, columnspan=2, padx=10, pady=10)

        # Total Price Label
        self.total_price_label = tk.Label(self, text="Total Price: 0", bg="#f0f0f0")
        self.total_price_label.grid(row=7, column=0, padx=10, pady=5, sticky="w")

        # Payment Status Dropdown
        tk.Label(self, text="Payment Status:", bg="#f0f0f0").grid(row=8, column=0, padx=10, pady=5, sticky="w")
        self.payment_status_combo = ttk.Combobox(self, values=["Pending", "Paid"])
        self.payment_status_combo.grid(row=8, column=1, padx=10, pady=5)
        self.payment_status_combo.set("Pending")

        # Order Status Dropdown
        tk.Label(self, text="Order Status:", bg="#f0f0f0").grid(row=9, column=0, padx=10, pady=5, sticky="w")
        self.order_status_combo = ttk.Combobox(self, values=["Processing", "Completed", "Cancelled"])
        self.order_status_combo.grid(row=9, column=1, padx=10, pady=5)
        self.order_status_combo.set("Processing")

        # Purchase Button
        tk.Button(self, text="Purchase", command=self.purchase_items).grid(row=10, column=0, columnspan=2, pady=10)

        self.populate_dropdown()

    def populate_dropdown(self):
        try:
            conn = self.db.get_connection()
            cursor = conn.cursor()
            cursor.execute("SELECT ItemID, ItemName, SellingPrice FROM items")
            items = cursor.fetchall()
            self.item_dropdown['values'] = [item[1] for item in items]
            self.item_dict = {item[1]: {'id': item[0], 'price': item[2]} for item in items}
        finally:
            cursor.close()
            conn.close()

    def add_item(self):
        item_name = self.item_dropdown.get()
        quantity = self.quantity_entry.get()

        if not item_name or not quantity:
            messagebox.showwarning("Input Error", "Please select an item and enter quantity.")
            return

        try:
            quantity = int(quantity)
            if quantity <= 0:
                messagebox.showwarning("Invalid Input", "Quantity must be greater than zero.")
                return
        except ValueError:
            messagebox.showwarning("Invalid Input", "Quantity must be a number.")
            return
        
        conn = self.db.get_connection()
        cursor = conn.cursor()
        try:
            cursor.execute("SELECT Quantity_in_Stock FROM items WHERE ItemID = %s", (self.item_dict[item_name]['id'],))
            stock = cursor.fetchone()[0]

            if stock <= 0:
                messagebox.showwarning("Out of Stock", f"{item_name} is out of stock.")
                return
            elif stock < quantity:
                messagebox.showwarning("Insufficient Stock", f"Only {stock} units of {item_name} are available.")
                return

        finally:
            cursor.close()
            conn.close()

        item_price = self.item_dict[item_name]['price']
        total_price = item_price * quantity

        self.items_listbox.insert(tk.END, f"{item_name} - Quantity: {quantity} - Price: {total_price}")
        self.selected_items.append({'id': self.item_dict[item_name]['id'], 'quantity': quantity, 'price': total_price})

        self.update_total_price()

    def purchase_items(self):
        customer_name = self.customer_name_entry.get()
        payment_status = self.payment_status_combo.get()
        order_status = self.order_status_combo.get()

        if not customer_name:
            messagebox.showerror("Error", "Customer name is required.")
            return

        if not self.selected_items:
            messagebox.showerror("Error", "No items added to the order.")
            return

        conn = self.db.get_connection()
        cursor = conn.cursor()

        try:
            for item in self.selected_items:
                cursor.execute("SELECT Quantity_in_Stock FROM items WHERE ItemID = %s", (item['id'],))
                stock = cursor.fetchone()[0]

                if stock <= 0:
                    messagebox.showerror("Out of Stock", f"Item ID {item['id']} is out of stock.")
                    return
                elif stock < item['quantity']:
                    messagebox.showerror("Insufficient Stock", f"Item ID {item['id']} has only {stock} units in stock.")
                    return

            # Insert into customer_order
            cursor.execute("""
                INSERT INTO customer_order (CustomerName, OrderDate, TotalAmount, Payment_Status, Order_status, EmpID)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (customer_name, datetime.now(), sum(item['price'] for item in self.selected_items), payment_status, order_status, self.current_EmpId))
            order_id = cursor.lastrowid

            # Update the Order ID label
            self.order_id_label.config(text=str(order_id))

            # Insert into custorder_details
            for item in self.selected_items:
                cursor.execute("""
                    INSERT INTO custorder_details (OrderID, ItemID, Quantity, Unit_Price, Total_Price)
                    VALUES (%s, %s, %s, %s, %s)
                """, (order_id, item['id'], item['quantity'], item['price']/item['quantity'], item['price']))

                # Update items stock
                cursor.execute("UPDATE items SET Quantity_in_Stock = Quantity_in_Stock - %s WHERE ItemID = %s", (item['quantity'], item['id']))

            conn.commit()
            messagebox.showinfo("Success", "Purchase successful and stock updated!")

            self.log_audit(
                action_type="PURCHASE",
                table_name="customer_order",
                record_id=order_id,
                reason=f"New order placed by {customer_name}"
            )

            # Clear the form
            self.customer_name_entry.delete(0, tk.END)
            self.items_listbox.delete(0, tk.END)
            self.selected_items.clear()
            self.update_total_price()

        except mysql.connector.Error as err:
            messagebox.showerror("Database Error", str(err))
        finally:
            cursor.close()
            conn.close()

    def log_audit(self, action_type, table_name, record_id=None, old_value=None, new_value=None, reason=None):
        """
        Log an action to the audit_log table.

        Parameters:
            action_type (str): The type of action (e.g., PURCHASE, UPDATE, DELETE).
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

    def update_total_price(self):
        total_price = sum(item['price'] for item in self.selected_items)
        self.total_price_label.config(text=f"Total Price: {total_price}")