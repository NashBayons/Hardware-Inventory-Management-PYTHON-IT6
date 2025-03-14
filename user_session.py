class UserSession:
    def __init__(self):
        self.user_id = None
        self.username = None

    def set_user(self, user_id, username):
        self.user_id = user_id
        self.username = username

    def clear_user(self):
        self.user_id = None
        self.username = None