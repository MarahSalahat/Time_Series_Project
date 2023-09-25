from flask import Flask, request, jsonify

app = Flask(__name__)

users = [
    {'username': 'bailasan', 'password': '123'},
    {'username': 'jana', 'password': '123'},
    {'username': 'marah', 'password': '123'},
    {'username': 'naser', 'password': '123'}
]

# Keep track of logged-in users (you may use a more secure method)
logged_in_users = set()


@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    user = next((u for u in users if u['username'] == username and u['password'] == password), None)

    if user:
        logged_in_users.add(username)  
        return jsonify({'message': 'Login successful'}), 200
    else:
        return jsonify({'message': 'Login failed'}), 401



if __name__ == '__main__':
    app.run(debug=True)
