import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Stations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Station',
      theme: ThemeData(),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  final String topBarImage = 'assets/images/weatherwise-removebg-preview.png';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final buttonTextSize = screenSize.height * 0.04;

    return Scaffold(
      appBar: null,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.withOpacity(0.6),
              Colors.blue.withOpacity(0.4),
              Colors.blue.withOpacity(0.2),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: <Widget>[
            Image.asset(
              topBarImage,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 30), // Add some spacing
            Expanded(
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  LoginForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String loginMessage = '';

  Future<void> _login() async {
    final String username = usernameController.text;
    final String password = passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        // Handle successful login
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['message'] == 'Login successful') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Stations(username: username),
          ));
        } else {
          setState(() {
            loginMessage = 'Login Failed';
          });
        }
      } else {
        // Handle login failure
        throw Exception('Login failed');
      }
    } catch (e) {
      if (e is Exception) {
        setState(() {
          loginMessage = 'Login Failed';
        });
      } else {
        // Handle other errors
        setState(() {
          loginMessage = 'Error: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final buttonTextSize = screenSize.height * 0.04;

    return Container(
      width: 300, // the width of the login form
      height: 400,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextField(
              controller: usernameController,
              style: TextStyle( fontSize: 22,),
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: 'Username',
                icon: Icon(Icons.person,),
              ),
            ),
          ),

          SizedBox(height: 15.0),
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextField(
              controller: passwordController,
              style: TextStyle( fontSize: 22),

              obscureText: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: 'Password',
                icon: Icon(Icons.lock),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            loginMessage,
            style: TextStyle(
              color: Colors.red,
              fontSize: 16.0,
            ),
          ),
          SizedBox(
            width: 200.0,
            height: 50.0,
            child: ElevatedButton(
              onPressed: _login,
              child: Text(
                'Login',
                style: TextStyle(fontSize: buttonTextSize ,     ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
