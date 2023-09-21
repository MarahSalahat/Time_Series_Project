from flask import Blueprint, render_template, request, flash, redirect, url_for
import json
from werkzeug.security import check_password_hash
from flask_login import login_user, login_required, logout_user, current_user

views = Blueprint('views', __name__)

# Load user data from the JSON file
with open('users.json', 'r') as user_file:
    users_data = json.load(user_file)

users = {}
class User:
    def __init__(self, email, password):
        self.email = email
        self.password = password

    def check_password(self, password):
        return check_password_hash(self.password, password)

for email, user_data in users_data.items():
    users[email] = User(email, user_data['password'])

@views.route('/')
def home():
    return render_template('home.html', user=current_user)


@views.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        user = users.get(email)
        if user and user.check_password(password):
            login_user(user, remember=True)
            flash('Login successful!', category='success')
            return redirect(url_for('views.home'))
        else:
            flash('Login failed. Check your credentials.', category='error')
    return render_template('login.html', user=current_user)

@views.route('/logout')
@login_required
def logout():
    logout_user()
    flash('Logged out successfully!', category='success')
    return redirect(url_for('views.home'))