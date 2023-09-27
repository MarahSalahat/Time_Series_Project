import 'package:flutter/material.dart';
import 'package:weather/main.dart';
import 'Station1.dart';
import 'Station2.dart';
import 'Station3.dart';
import 'Station4.dart';
import 'Station5.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Stations extends StatelessWidget {
  String username;

  Stations({Key? key, required this.username}) : super(key: key);

  final List<String> stationNames = ['Station1', 'Station2', 'Station3', 'Station4', 'Station5'];
  final String stationImage = 'assets/images/4102326_cloud_sun_sunny_weather_icon.png';

  @override
  Widget build(BuildContext context) {
    final buttonTextSize = MediaQuery.of(context).size.height * 0.04;

    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.4),
                  Colors.blue.withOpacity(0.3),
                  Colors.blue.withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Choose a Station',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[600],
                      fontFamily: 'Caveat',
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    for (int i = 0; i < 2; i++)
                      GestureDetector(
                        onTap: () {
                          // Navigate to the respective station screen based on index
                          switch (i) {
                            case 0:
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Station1()));
                              break;
                            case 1:
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Station2()));
                              break;
                          }
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Column(
                                children: [
                                  Image.asset(
                                    stationImage,
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height * 0.2,
                                  ),
                                  Text(
                                    stationNames[i],
                                    style: TextStyle(
                                      fontSize: buttonTextSize,
                                      color: Colors.blue,
                                      fontFamily: 'Caveat',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: MediaQuery.of(context).size.height * 0.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.white.withOpacity(0.1), Colors.transparent],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                GestureDetector(
                  onTap: () {
                    // Navigate to station3
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Station3()));
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              stationImage,
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.2,
                            ),
                            Text(
                              stationNames[2],
                              style: TextStyle(
                                fontSize: buttonTextSize,
                                color: Colors.blue,
                                fontFamily: 'Caveat',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.white.withOpacity(0.1), Colors.transparent],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    for (int i = 3; i < 5; i++)
                      GestureDetector(
                        onTap: () {
                          // Navigate to the respective station screen based on index
                          switch (i) {
                            case 3:
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Station4()));
                              break;
                            case 4:
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Station5()));
                              break;
                          }
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Column(
                                children: [
                                  Image.asset(
                                    stationImage,
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height * 0.2,
                                  ),
                                  Text(
                                    stationNames[i],
                                    style: TextStyle(
                                      fontSize: buttonTextSize,
                                      color: Colors.blue,
                                      fontFamily: 'Caveat',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: MediaQuery.of(context).size.height * 0.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.white.withOpacity(0.1), Colors.transparent],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 16.0,
            right: 16.0,
            child: InkWell(
              onTap: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.blue[900],
                  ),
                  SizedBox(width: 6.0),
                  Text(
                    'LogOut',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                ],
              ),
            ),
          ),


        ],
      ),
    );
  }
}