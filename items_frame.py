from optparse import TitledHelpFormatter
from tkinter import *
from tkinter import ttk, messagebox
import mysql.connector

class ItemsFrame(Frame):
    def __init__(self, master, db):
        super().__init__(master, bg="white", width=1080, height=600)
        self.db = db
        self.create_items_frame()

    def create_items_frame(self):
        # Title Label
        title_label = Label(self, text="Items", font=("Arial", 16, "bold"), bg="white")
        title_label.place(x=20, y=20)

        # Treeview for displaying items
        columns = ("Item ID", "Item Name", "Is Serialized", "Quantity in Stock", "Selling Price", "Category")  # Add Category
        self.items_tree = ttk.Treeview(self, columns=columns, show="headings")
        for col in columns:
            self.items_tree.heading(col, text=col)
            self.items_tree.column(col, width=120)
        self.items_tree.place(x=20, y=60, width=900, height=300)

        # Load data into the Treeview
        self.load_items()

        # Buttons
        refresh_button = Button(self, text="Refresh", command=self.load_items)
        refresh_button.place(x=20, y=400)

        add_button = Button(self, text="Add Item", command=self.add_item)
        add_button.place(x=80, y=400)

        edit_button = Button(self, text="Edit Item", command=self.edit_item)
        edit_button.place(x=150, y=400)

        remove_button = Button(self, text="Remove Item", command=self.remove_item)
        remove_button.place(x=220, y=400)

        archived_button = Button(self, text="Archived Items", command=self.show_archived_items)
        archived_button.place(x=320, y=400)

    def load_items(self):
        # Clear existing data in the Treeview
        for item in self.items_tree.get_children():
            self.items_tree.delete(item)

        # Fetch data from the database
        conn = self.db.get_connection()
        if conn:
            cursor = conn.cursor()
            try:
                cursor.execute("""
                    SELECT ItemID, ItemName, Is_Serialized, Quantity_in_Stock, SellingPrice, Category 
                    FROM items
                    WHERE is_active = 1
                """)
                rows = cursor.fetchall()

                # Insert rows into the Treeview
                for row in rows:
                    quantity = "Out of Stock" if row[3] == 0 else row[3]
                    display_row = (row[0], row[1], row[2], quantity, row[4], row[5])
                    self.items_tree.insert("", "end", values=display_row)
            except mysql.connector.Error as err:
                messagebox.showerror("Database Error", f"Error: {err}")
            finally:
                cursor.close()
                conn.close()


    def add_item(self):
        # Create a new window for adding an item
        add_window = Toplevel(self.master)
        add_window.title("New Item")
        add_window.geometry("400x450")

        # Labels and Entry fields
        fields = [
            ("Item Name:", 10, 10),
            ("Description:", 10, 40),
            ("Category:", 10, 70),
            ("Is Serialized (1 for Yes, 0 for No):", 10, 100),
            ("Quantity:", 10, 130),
            ("Selling Price:", 10, 160),
        ]
        entries = []

        for label_text, x, y in fields:
            Label(add_window, text=label_text).place(x=x, y=y)
            if label_text == "Category:":
                # Use a Combobox for the category field
                category_combo = ttk.Combobox(add_window, values=["Electronics", "Tools", "Hardware", "Furniture", "Other"])
                category_combo.place(x=x + 180, y=y)
                entries.append(category_combo)
            else:
                entry = Entry(add_window)
                entry.place(x=x + 180, y=y)
                entries.append(entry)

        item_name_entry = entries[0]
        description_entry = entries[1]
        category_combo = entries[2]  # This is now a Combobox
        is_serialized_entry = entries[3]
        quantity_entry = entries[4]
        unit_price_entry = entries[5]

        # Function to save the item
        def save_item():
            item_name = item_name_entry.get().strip()
            description = description_entry.get().strip()
            category = category_combo.get().strip()  # Get selected category from Combobox
            is_serialized = is_serialized_entry.get().strip()
            quantity = quantity_entry.get().strip()
            unit_price = unit_price_entry.get().strip()

            # Validation checks
            if not item_name or not description or not category or not is_serialized or not quantity or not unit_price:
                messagebox.showerror("Error", "All fields are required")
                return

            try:
                is_serialized = int(is_serialized)
                quantity = int(quantity)
                unit_price = float(unit_price)

                if is_serialized not in (0, 1):
                    messagebox.showerror("Error", "Is Serialized must be 0 or 1")
                    return

                if quantity <= 0:
                    messagebox.showerror("Error", "Quantity must be greater than zero")
                    return

                if unit_price <= 0:
                    messagebox.showerror("Error", "Unit Price must be greater than zero")
                    return

            except ValueError:
                messagebox.showerror("Error", "Invalid input for Is Serialized, Quantity, or Unit Price")
                return

            conn = self.db.get_connection()
            if conn:
                cursor = conn.cursor()
                try:
                    query = """
                        INSERT INTO items 
                        (ItemName, Description, Category, Is_Serialized, Quantity_in_Stock, SellingPrice) 
                        VALUES (%s, %s, %s, %s, %s, %s)
                    """
                    values = (item_name, description, category, is_serialized, quantity, unit_price)
                    cursor.execute(query, values)
                    conn.commit()
                    messagebox.showinfo("Success", "Item added successfully")
                    add_window.destroy()
                    self.load_items()  # Refresh the Treeview
                except mysql.connector.Error as err:
                    messagebox.showerror("Database Error", f"Error: {err}")
                finally:
                    cursor.close()
                    conn.close()
            else:
                messagebox.showerror("Error", "Failed to connect to the database")

        save_button = Button(add_window, text="Save", command=save_item)
        save_button.place(x=150, y=200)

    def edit_item(self):
        selected_item = self.items_tree.selection()
        if not selected_item:
            messagebox.showerror("Error", "No Item selected.")
            return

        itemid_selected = self.items_tree.item(selected_item)["values"][0]

        window_itemedit = Toplevel(self.master)
        window_itemedit.title("Edit Item")
        window_itemedit.geometry("400x450")

        conn = self.db.get_connection()
        if conn:
            cursor = conn.cursor()
            try:
                # Fixed SQL query - added space and removed extra tab
                cursor.execute(
                    "SELECT ItemName, Is_Serialized, Quantity_in_Stock, SellingPrice, Category, Description, is_active FROM items "
                    "WHERE ItemID = %s", (itemid_selected,))  # Added comma to make it a tuple

                item_data = cursor.fetchone()
                if not item_data:
                    messagebox.showerror("Error", "Item not found.")
                    cursor.close()
                    conn.close()
                    window_itemedit.destroy()
                    return

                # Extract item data
                item_name, is_serialized, quantity, selling_price, category, description, is_active = item_data

                # Create form fields
                fields = [
                    ("Item Name:", 10, 10, item_name),
                    ("Description:", 10, 40, description),
                    ("Category:", 10, 70, category),
                    ("Is Serialized (1 for Yes, 0 for No):", 10, 100, is_serialized),
                    ("Quantity:", 10, 130, quantity),
                    ("Selling Price:", 10, 160, selling_price),
                    ("Is Active (1 for Yes, 0 for No):", 10, 190, is_active)
                ]

                entries = []

                for label_text, x, y, value in fields:
                    Label(window_itemedit, text=label_text).place(x=x, y=y)
                    if label_text == "Category:":
                        # Use a Combobox for the category field
                        category_combo = ttk.Combobox(window_itemedit,
                                                      values=["Electronics", "Tools", "Hardware", "Furniture", "Other"])
                        category_combo.set(value)  # Set the current value
                        category_combo.place(x=x + 180, y=y)
                        entries.append(category_combo)
                    else:
                        entry = Entry(window_itemedit)
                        entry.insert(0, value)  # Set the current value
                        entry.place(x=x + 180, y=y)
                        entries.append(entry)

                item_name_entry = entries[0]
                description_entry = entries[1]
                category_combo = entries[2]
                is_serialized_entry = entries[3]
                quantity_entry = entries[4]
                unit_price_entry = entries[5]
                is_active_entry = entries[6]

                # Function to update the item
                def update_item():
                    item_name = item_name_entry.get().strip()
                    description = description_entry.get().strip()
                    category = category_combo.get().strip()
                    is_serialized = is_serialized_entry.get().strip()
                    quantity = quantity_entry.get().strip()
                    unit_price = unit_price_entry.get().strip()
                    is_active = is_active_entry.get().strip()

                    # Validation checks
                    if not item_name or not description or not category or not is_serialized or not quantity or not unit_price or not is_active:
                        messagebox.showerror("Error", "All fields are required")
                        return

                    try:
                        is_serialized = int(is_serialized)
                        quantity = int(quantity)
                        unit_price = float(unit_price)
                        is_active = int(is_active)

                        if is_serialized not in (0, 1):
                            messagebox.showerror("Error", "Is Serialized must be 0 or 1")
                            return

                        if is_active not in (0, 1):
                            messagebox.showerror("Error", "Is Active must be 0 or 1")
                            return

                        if quantity < 0:
                            messagebox.showerror("Error", "Quantity must be greater than or equal to zero")
                            return

                        if unit_price <= 0:
                            messagebox.showerror("Error", "Unit Price must be greater than zero")
                            return

                    except ValueError:
                        messagebox.showerror("Error",
                                             "Invalid input for Is Serialized, Quantity, Unit Price, or Is Active")
                        return

                    conn = self.db.get_connection()
                    if conn:
                        cursor = conn.cursor()
                        try:
                            query = """
                                UPDATE items 
                                SET ItemName = %s, Description = %s, Category = %s, 
                                    Is_Serialized = %s, Quantity_in_Stock = %s, 
                                    SellingPrice = %s, is_active = %s
                                WHERE ItemID = %s
                            """
                            values = (item_name, description, category, is_serialized,
                                      quantity, unit_price, is_active, itemid_selected)
                            cursor.execute(query, values)
                            conn.commit()
                            messagebox.showinfo("Success", "Item updated successfully")
                            window_itemedit.destroy()
                            self.load_items()  # Refresh the Treeview
                        except mysql.connector.Error as err:
                            messagebox.showerror("Database Error", f"Error: {err}")
                        finally:
                            cursor.close()
                            conn.close()
                    else:
                        messagebox.showerror("Error", "Failed to connect to the database")

                update_button = Button(window_itemedit, text="Update", command=update_item)
                update_button.place(x=150, y=240)

            except mysql.connector.Error as err:
                messagebox.showerror("Database Error", f"Error: {err}")
            finally:
                cursor.close()
                conn.close()

    def remove_item(self):
        selected_item = self.items_tree.selection()
        if not selected_item:
            messagebox.showerror("Error", "No Item selected.")
            return

        itemid_selected = self.items_tree.item(selected_item)["values"][0]
        item_name = self.items_tree.item(selected_item)["values"][1]

        # Confirm deletion
        confirm = messagebox.askyesno("Confirm Delete", f"Are you sure you want to delete the item '{item_name}'?")
        if not confirm:
            return

        conn = self.db.get_connection()
        if conn:
            cursor = conn.cursor()
            try:
                # Option 1: Hard delete (completely remove from database)
                # cursor.execute("DELETE FROM items WHERE ItemID = %s", (itemid_selected,))

                # Option 2: Soft delete (mark as inactive)
                cursor.execute("UPDATE items SET is_active = 0 WHERE ItemID = %s", (itemid_selected,))

                conn.commit()
                messagebox.showinfo("Success", f"Item '{item_name}' has been removed.")
                self.load_items()  # Refresh the Treeview
            except mysql.connector.Error as err:
                messagebox.showerror("Database Error", f"Error: {err}")
            finally:
                cursor.close()
                conn.close()
        else:
            messagebox.showerror("Error", "Failed to connect to the database")


    def show_archived_items(self):
        # Create a toplevel window for archived items
        archive_window = Toplevel(self.master)
        archive_window.title("Archived Items")
        archive_window.geometry("950x400")

        # Title Label
        title_label = Label(archive_window, text="Archived Items", font=("Arial", 16, "bold"))
        title_label.place(x=20, y=20)

        # Treeview for displaying archived items
        columns = ("Item ID", "Item Name", "Is Serialized", "Quantity", "Selling Price", "Category", "Description")
        archived_tree = ttk.Treeview(archive_window, columns=columns, show="headings")
        for col in columns:
            archived_tree.heading(col, text=col)
            archived_tree.column(col, width=120)
        archived_tree.place(x=20, y=60, width=900, height=250)

        # Function to restore an item (set is_active to 1)
        def restore_item():
            selected_item = archived_tree.selection()
            if not selected_item:
                messagebox.showerror("Error", "No item selected.")
                return

            itemid_selected = archived_tree.item(selected_item)["values"][0]
            item_name = archived_tree.item(selected_item)["values"][1]

            # Confirm restoration
            confirm = messagebox.askyesno("Confirm Restore", f"Are you sure you want to restore the item '{item_name}'?")
            if not confirm:
                return

            conn = self.db.get_connection()
            if conn:
                cursor = conn.cursor()
                try:
                    cursor.execute("UPDATE items SET is_active = 1 WHERE ItemID = %s", (itemid_selected,))
                    conn.commit()
                    messagebox.showinfo("Success", f"Item '{item_name}' has been restored.")
                    # Remove from the archived view
                    archived_tree.delete(selected_item)
                    # Refresh the main items list
                    self.load_items()
                except mysql.connector.Error as err:
                    messagebox.showerror("Database Error", f"Error: {err}")
                finally:
                    cursor.close()
                    conn.close()

        # Add a restore button
        restore_button = Button(archive_window, text="Restore Item", command=restore_item)
        restore_button.place(x=20, y=320)

        # Load archived items
        conn = self.db.get_connection()
        if conn:
            cursor = conn.cursor()
            try:
                cursor.execute("""
                    SELECT ItemID, ItemName, Is_Serialized, Quantity_in_Stock, SellingPrice, Category, Description 
                    FROM items
                    WHERE is_active = 0
                """)
                rows = cursor.fetchall()

                if not rows:
                    # No archived items found
                    no_items_label = Label(archive_window, text="No archived items found.", font=("Arial", 12))
                    no_items_label.place(x=20, y=150)
                else:
                    # Insert rows into the Treeview
                    for row in rows:
                        archived_tree.insert("", "end", values=row)
            except mysql.connector.Error as err:
                messagebox.showerror("Database Error", f"Error: {err}")
            finally:
                cursor.close()
                conn.close()