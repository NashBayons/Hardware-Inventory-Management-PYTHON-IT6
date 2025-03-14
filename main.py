from tkinter import Tk, Frame, Button, Label, Canvas
from PIL import Image, ImageTk
from dashboard_frame import DashboardFrame
from purchase_order_frame import PurchaseOrderFrame
from suppliers_frame import SuppliersFrame
from employee_frame import EmployeeFrame
from login_frame import LoginFrame
from sales_report_frame import SalesReportFrame
from return_frame import ReturnFrame
from customer_order_frame import CustomerOrderFrame
from items_frame import ItemsFrame
from audit_frame import AuditFrame
from database import Database
from user_session import UserSession

class HardwareInventoryApp:
    def __init__(self, root):
        self.root = root
        self.root.geometry("1280x650")
        self.root.resizable(False, False)
        self.root.title("Hardware Inventory System")
        self.order_items = []
        
        self.db = Database()
        self.session = UserSession()

        self.bg_image = Image.open("image_1.png") 
        self.bg_image = self.bg_image.resize((1280, 650), Image.Resampling.LANCZOS) 
        self.bg_photo = ImageTk.PhotoImage(self.bg_image)

        self.canvas = Canvas(self.root, width=1280, height=650)
        self.canvas.pack(fill="both", expand=True)
        self.canvas.create_image(0, 0, image=self.bg_photo, anchor="nw")

        self.sidebar = Frame(self.root, bg="#1E1E1E", width=200, height=650)
        self.sidebar.place_forget()

        self.logo_img = Image.open("image_2.png").resize((100, 100))
        self.logo_photo = ImageTk.PhotoImage(self.logo_img)
        self.logo_label = Label(self.sidebar, image=self.logo_photo, bg="#1E1E1E")
        self.logo_label.place(x=50, y=20)

        self.top_frame = Frame(self.root, bg="#544E4E", height=60, width=1080)
        self.top_frame.place_forget()

        self.title_label = Label(self.top_frame, text="Login", fg="white", bg="#544E4E", font=("Arial", 20, "bold"))
        self.title_label.place(x=20, y=15)

        self.frames = {
            "Login": LoginFrame(self.root, self.db, self, self.session)
        }

        buttons = [
            ("🖥 Dashboard", 150, "Dashboard"),
            ("📦 Receive Order", 200, "Receive Order"),
            ("📋 Suppliers", 250, "Suppliers"),
            ("📋 Audit", 300, "Audit"),
            ("👨‍💼 Employee", 400, "Employee"),
            ("📊 Sales Report", 350, "Sales Report"),
            ("📦 Returns", 450, "Return"),
            ("🛒 Customer Order", 500, "Customer Order"),
            ("📦 Items", 550, "Items"),
            ("🚪 Log Out", 600, "Login")
        ]

        for text, y, frame_name in buttons:
            btn = Button(self.sidebar, text=text, fg="white", font=("Arial", 12),
                         bg="#1E1E1E", activebackground="#333333", bd=0,
                         highlightthickness=0, cursor="hand2", anchor="w",
                         command=lambda f=frame_name: self.show_frame(f))
            btn.place(x=20, y=y, width=160, height=40)

        self.show_frame("Login")

    def show_frame(self, frame_name):
        """Show the specified frame and hide all others."""
        for frame in self.frames.values():
            frame.place_forget()

        if frame_name not in self.frames:
            if frame_name == "Dashboard":
                self.frames["Dashboard"] = DashboardFrame(self.root, self.db)
            elif frame_name == "Receive Order":
                self.frames["Receive Order"] = PurchaseOrderFrame(self.root, self.db, self.session)
            elif frame_name == "Suppliers":
                self.frames["Suppliers"] = SuppliersFrame(self.root, self.db)
            elif frame_name == "Audit":
                self.frames["Audit"] = AuditFrame(self.root, self.db)
            elif frame_name == "Employee":
                self.frames["Employee"] = EmployeeFrame(self.root, self.db, self.session)
            elif frame_name == "Sales Report":
                self.frames["Sales Report"] = SalesReportFrame(self.root, self.db)
            elif frame_name == "Return":
                self.frames["Return"] = ReturnFrame(self.root, self.db, self.session)
            elif frame_name == "Customer Order":
                self.frames["Customer Order"] = CustomerOrderFrame(self.root, self.db, self.session)
            elif frame_name == "Items":
                self.frames["Items"] = ItemsFrame(self.root, self.db)

        if frame_name in self.frames:
            self.frames[frame_name].place(x=250, y=100)
            self.title_label.config(text=frame_name)

        if frame_name == "Login":
            self.sidebar.place_forget()
            self.top_frame.place_forget()
        else:
            self.sidebar.place(x=0, y=0)
            self.top_frame.place(x=200, y=0)

    def Log_out(self, frame_name):
        return None

if __name__ == "__main__":
    root = Tk()
    app = HardwareInventoryApp(root)
    root.mainloop()