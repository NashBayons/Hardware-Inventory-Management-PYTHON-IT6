from tkinter import *
from tkinter import ttk, messagebox
import mysql.connector
from datetime import datetime

class ReturnFrame(Frame):
    def __init__(self, root, db, session):
        super().__init__(root, bg="white", width=1080, height=600)
        self.root = root
        self.db = db
        self.session = session
        self.current_EmpID = self.session.user_id
        self.supplier_return_qty_entries = {}  # Store return quantity entries per row for supplier returns
        self.customer_return_qty_entries = {}  # Store return quantity entries per row for customer returns
        self.create_supplier_return_frame()  
        self.create_customer_return_frame()

    def create_supplier_return_frame(self):
        # Supplier Return Section
        Label(self, text="Supplier Return", font=("Arial", 16, "bold"), bg="white").place(x=20, y=20)

        Label(self, text="Search Order ID:").place(x=20, y=60)
        self.search_order_entry = Entry(self)
        self.search_order_entry.place(x=140, y=60)

        Button(self, text="Search", command=self.search_supplier_order).place(x=300, y=58)

        # Supplier return tree view
        self.supplier_tree_frame = Frame(self, bg="white")
        self.supplier_tree_frame.place(x=20, y=100, width=500, height=300)

        self.supplier_tree = ttk.Treeview(self.supplier_tree_frame, columns=("ItemID", "Quantity", "Price"), show="headings")
        for col in ("ItemID", "Quantity", "Price"):
            self.supplier_tree.heading(col, text=col)
            self.supplier_tree.column(col, width=100)
        self.supplier_tree.pack(side=LEFT, fill=BOTH)

        # Frame to hold supplier return quantity input boxes
        self.supplier_qty_frame = Frame(self, bg="white")
        self.supplier_qty_frame.place(x=330, y=100, width=500, height=100)

        Label(self, text="Supplier Return Reason:").place(x=20, y=410)
        self.supplier_return_reason_entry = Entry(self, width=30)
        self.supplier_return_reason_entry.place(x=160, y=410)

        Button(self, text="Process Supplier Return", command=self.process_supplier_return).place(x=20, y=440)

    def create_customer_return_frame(self):
        # Customer Return Section
        Label(self, text="Customer Return", font=("Arial", 16, "bold"), bg="white").place(x=560, y=20)

        Label(self, text=" Order ID:").place(x=560, y=60)
        self.search_order_entry_customer = Entry(self)
        self.search_order_entry_customer.place(x=680, y=60)

        Label(self, text=" Customer Name:").place(x=560, y=90)
        self.search_name_entry_customer = Entry(self)
        self.search_name_entry_customer.place(x=680, y=90)

        Button(self, text="Search", command=self.search_customer_order).place(x=840, y=58)

        # Customer return tree view
        self.customer_tree_frame = Frame(self, bg="white")
        self.customer_tree_frame.place(x=560, y=120, width=500, height=300)

        self.customer_tree = ttk.Treeview(self.customer_tree_frame, columns=("ItemID", "Quantity", "Price"), show="headings")
        for col in ("ItemID", "Quantity", "Price"):
            self.customer_tree.heading(col, text=col)
            self.customer_tree.column(col, width=100)
        self.customer_tree.pack(side=LEFT, fill=BOTH)

        # Frame to hold customer return quantity input boxes
        self.customer_qty_frame = Frame(self, bg="white")
        self.customer_qty_frame.place(x=870, y=120, width=500, height=120)

        Label(self, text="Customer Return Reason:").place(x=560, y=440)
        self.customer_return_reason_entry = Entry(self, width=30)
        self.customer_return_reason_entry.place(x=700, y=440)

        Button(self, text="Process Customer Return", command=self.process_customer_return).place(x=560, y=470)

    def search_supplier_order(self):
        order_id = self.search_order_entry.get()
        if not order_id:
            messagebox.showerror("Error", "Please enter an Order ID.")
            return

        self.supplier_tree.delete(*self.supplier_tree.get_children())
        for widget in self.supplier_qty_frame.winfo_children():
            widget.destroy()
        self.supplier_return_qty_entries.clear()

        conn = self.db.get_connection()
        cursor = conn.cursor()

        try:
            cursor.execute("SELECT * FROM order_table WHERE OrderID = %s", (order_id,))
            order = cursor.fetchone()
            if not order:
                messagebox.showerror("Error", "Order not found.")
                return

            cursor.execute("""
                SELECT od.ItemID, od.Quantity, od.UnitPrice
                FROM order_details od
                WHERE od.OrderID = %s
            """, (order_id,))
            rows = cursor.fetchall()
            for i, row in enumerate(rows):
                self.supplier_tree.insert("", "end", iid=i, values=row)

                Label(self.supplier_qty_frame, text=f"Return Qty {i + 1}:").grid(row=i, column=0, padx=5, pady=2)
                qty_entry = Entry(self.supplier_qty_frame, width=5)
                qty_entry.grid(row=i, column=1, padx=5)
                self.supplier_return_qty_entries[i] = (row[0], qty_entry)  # Store ItemID and Entry widget

        except mysql.connector.Error as err:
            messagebox.showerror("Database Error", f"Error: {err}")
        finally:
            cursor.close()
            conn.close()

    def search_customer_order(self):
        order_id = self.search_order_entry_customer.get()
        cust_name = self.search_name_entry_customer.get()
        if not order_id and cust_name:
            messagebox.showerror("Error", "Please fill all entry fields.")
            return

        self.customer_tree.delete(*self.customer_tree.get_children())
        for widget in self.customer_qty_frame.winfo_children():
            widget.destroy()
        self.customer_return_qty_entries.clear()
        conn = self.db.get_connection()
        cursor = conn.cursor()
        try:

            cursor.execute("SELECT * FROM customer_order WHERE OrderID = %s AND CustomerName = %s", (order_id, cust_name))
            order = cursor.fetchone()
            if not order:
                messagebox.showerror("Error", "Customer order not found.")
                return

            cursor.execute("""
                SELECT od.ItemID, od.Quantity, od.Unit_Price
                FROM custorder_details od
                WHERE od.OrderID = %s
            """, (order_id,))
            rows = cursor.fetchall()
            for i, row in enumerate(rows):
                self.customer_tree.insert("", "end", iid=i, values=row)

                Label(self.customer_qty_frame, text=f"Return Qty {i + 1}:").grid(row=i, column=0, padx=5, pady=2)
                qty_entry = Entry(self.customer_qty_frame, width=5)
                qty_entry.grid(row=i, column=1, padx=5)
                self.customer_return_qty_entries[i] = (row[0], qty_entry)  # Store ItemID and Entry widget

        except mysql.connector.Error as err:
            messagebox.showerror("Database Error", f"Error: {err}")
        finally:
            cursor.close()
            conn.close()

    def process_supplier_return(self):
        order_id = self.search_order_entry.get()
        return_reason = self.supplier_return_reason_entry.get()
        if not return_reason:
            messagebox.showerror("Error", "Please enter a return reason.")
            return
        conn = None
        cursor = None
        try:
            conn = self.db.get_connection()
            if conn is None:
                messagebox.showerror("Database Error", "Could not establish a connection to the database.")
                return
            cursor = conn.cursor()

            cursor.execute("SELECT SuppID, EmpID FROM order_table WHERE OrderID = %s", (order_id,))
            order_info = cursor.fetchone()
            if not order_info:
                messagebox.showerror("Error", "Invalid Order ID.")
                return

            supp_id, emp_id = order_info
            return_date = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            return_status = "Pending"

            # Insert into supplier_return
            cursor.execute("""
                INSERT INTO supplier_return (OrderID, SuppID, Return_date, Return_reason, Return_status, Processed_by_Employee)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (order_id, supp_id, return_date, return_reason, return_status, self.current_EmpID))
            conn.commit()
            return_id = cursor.lastrowid

            cursor.execute("""
                        INSERT INTO stock_adjustment (EmpID, ReportedDate, Adjustment_Type, Status)
                        VALUES (%s, %s, %s, %s)
                    """, (self.current_EmpID, return_date, "Supplier Return", "Pending"))
            adjustment_id = cursor.lastrowid

            # Log the creation of the supplier return
            self.log_audit(
                action_type="CREATE",
                table_name="supplier_return",
                record_id=return_id,
                reason=f"Supplier return created for Order ID: {order_id}"
            )

            items_returned = 0
            for i, (item_id, entry) in self.supplier_return_qty_entries.items():
                qty_text = entry.get()
                if qty_text and qty_text.isdigit():
                    qty = int(qty_text)
                    if qty > 0:
                        # Fetch unit price
                        cursor.execute("""
                            SELECT UnitPrice FROM order_details WHERE OrderID = %s AND ItemID = %s
                        """, (order_id, item_id))
                        unit_price = cursor.fetchone()[0]
                        refund_amount = qty * unit_price

                        cursor.execute("""
                            INSERT INTO supplier_return_details (Supp_Return_ID, ItemID, Quantity, Refund_amount)
                            VALUES (%s, %s, %s, %s)
                        """, (return_id, item_id, qty, refund_amount))

                        cursor.execute("SELECT Quantity_in_Stock FROM items WHERE ItemID = %s", (item_id,))
                        result = cursor.fetchone()
                        previous_qty = result[0] if result else 0
                        new_qty = previous_qty - qty

                        # Insert into stock_adjustment_detail
                        cursor.execute("""
                                        INSERT INTO stock_adjustment_detail (Adjustment_ID, ItemID, Quantity_Adjusted, Previous_Quantity, New_Quantity)
                                        VALUES (%s, %s, %s, %s, %s)
                                    """, (adjustment_id, item_id, -qty, previous_qty, new_qty))

                        cursor.execute("UPDATE items SET Quantity_in_Stock = %s WHERE ItemID = %s", (new_qty, item_id))

                        # Log the addition of the item to the supplier return
                        self.log_audit(
                            action_type="ADD_ITEM",
                            table_name="supplier_return_details",
                            record_id=return_id,
                            new_value=f"Item: {item_id}, Quantity: {qty}, Refund: {refund_amount}",
                            reason=f"Item added to supplier return #{return_id}"
                        )

                        items_returned += 1

            if items_returned > 0:
                conn.commit()
                messagebox.showinfo("Success", f"{items_returned} item(s) returned to supplier.")
            else:
                messagebox.showwarning("Warning", "No valid items selected for return.")

            self.clear_supplier_search_results()

        except mysql.connector.Error as err:
            messagebox.showerror("Database Error", f"Error: {err}")
            print("yesyes")
        finally:
            cursor.close()
            conn.close()

    def process_customer_return(self):
        order_id = self.search_order_entry_customer.get()
        return_reason = self.customer_return_reason_entry.get()
        if not return_reason:
            messagebox.showerror("Error", "Please enter a return reason.")
            return

        conn = self.db.get_connection()
        cursor = conn.cursor()

        try:
            # Fetch customer ID and employee ID from order
            cursor.execute("SELECT CustomerName, EmpID FROM customer_order WHERE OrderID = %s", (order_id,))
            order_info = cursor.fetchone()
            if not order_info:
                messagebox.showerror("Error", "Invalid Customer Order ID.")
                return

            customer_id, emp_id = order_info
            return_date = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            return_status = "Pending"

            # Insert into customer_return - fixed missing closing parenthesis
            cursor.execute("""
                INSERT INTO customer_return (CustOrder_ID, Return_date, Return_reason, Return_status, Processed_by_Employee)
                VALUES (%s, %s, %s, %s, %s)
            """, (order_id, return_date, return_reason, return_status, emp_id))

            # Get the return ID immediately after insertion
            return_id = cursor.lastrowid

            # Insert into stock_adjustment (header)
            cursor.execute("""
                INSERT INTO stock_adjustment (EmpID, ReportedDate, Adjustment_Type, Status)
                VALUES (%s, %s, %s, %s)
            """, (self.current_EmpID, return_date, "Customer Return", "Pending"))
            adjustment_id = cursor.lastrowid

            # Log the creation of the customer return
            self.log_audit(
                action_type="CREATE",
                table_name="customer_return",
                record_id=return_id,
                reason=f"Customer return created for Order ID: {order_id}"
            )

            items_returned = 0
            for i, (item_id, entry) in self.customer_return_qty_entries.items():
                qty_text = entry.get()
                if qty_text and qty_text.isdigit():
                    qty = int(qty_text)
                    if qty > 0:
                        # Fetch unit price
                        cursor.execute("""
                            SELECT Unit_Price, CODetails_ID FROM custorder_details WHERE OrderID = %s AND ItemID = %s
                        """, (order_id, item_id))
                        result = cursor.fetchone()
                        price_result = result[0]
                        CODetails_ID = result[1]

                        # Check if the item exists in the order
                        if not price_result:
                            messagebox.showwarning("Warning", f"Item {item_id} not found in order {order_id}.")
                            continue

                        unit_price = price_result
                        refund_amount = qty * unit_price

                        # Insert into customer_return_details - updated to match schema
                        cursor.execute("""
                            INSERT INTO customer_return_details (Cust_Return_ID, CODetails_ID, Quantity_Returned, Refund_Amount)
                            VALUES (%s, %s, %s, %s)
                        """, (return_id, CODetails_ID, qty, refund_amount))

                        # Log the addition of the item to the customer return
                        self.log_audit(
                            action_type="ADD_ITEM",
                            table_name="customer_return_details",
                            record_id=return_id,
                            new_value=f"Item: {item_id}, Quantity: {qty}, Refund: {refund_amount}",
                            reason=f"Item added to customer return #{return_id}"
                        )

                        items_returned += 1

                        # Get current stock quantity
                        cursor.execute("SELECT Quantity_in_stock FROM items WHERE ItemID = %s", (item_id,))
                        result = cursor.fetchone()
                        previous_qty = result[0] if result else 0
                        new_qty = previous_qty + qty  # Customer return adds stock

                        # Insert into stock_adjustment_detail
                        cursor.execute("""
                            INSERT INTO stock_adjustment_detail (Adjustment_ID, ItemID, Quantity_Adjusted, Previous_Quantity, New_Quantity)
                            VALUES (%s, %s, %s, %s, %s)
                        """, (adjustment_id, item_id, qty, previous_qty, new_qty))

                        # Update the stock table
                        cursor.execute("UPDATE items SET Quantity_in_stock = %s WHERE ItemID = %s", (new_qty, item_id))

            # Commit only after all operations are successful
            if items_returned > 0:
                conn.commit()
                messagebox.showinfo("Success", f"{items_returned} item(s) returned by customer.")
            else:
                # Roll back if no items were returned
                conn.rollback()
                messagebox.showwarning("Warning", "No valid items selected for return.")

            self.clear_customer_search_results()

        except mysql.connector.Error as err:
            conn.rollback()  # Roll back on error
            messagebox.showerror("Database Error", f"Error: {err}")
        finally:
            cursor.close()
            conn.close()

    def clear_supplier_search_results(self):
        self.supplier_tree.delete(*self.supplier_tree.get_children())
        for widget in self.supplier_qty_frame.winfo_children():
            widget.destroy()
        self.supplier_return_qty_entries.clear()
        self.search_order_entry.delete(0, END)
        self.supplier_return_reason_entry.delete(0, END)

    def clear_customer_search_results(self):
        self.customer_tree.delete(*self.customer_tree.get_children())
        for widget in self.customer_qty_frame.winfo_children():
            widget.destroy()
        self.customer_return_qty_entries.clear()
        self.search_order_entry_customer.delete(0, END)
        self.customer_return_reason_entry.delete(0, END)

    def log_audit(self, action_type, table_name, record_id=None, old_value=None, new_value=None, reason=None):
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
