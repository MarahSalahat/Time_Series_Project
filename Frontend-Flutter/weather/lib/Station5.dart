import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'WeatherService.dart';
import 'package:fl_chart/fl_chart.dart';
import 'main.dart';

class Forecast {
  final DateTime date;
  final double temperature;

  Forecast({required this.date, required this.temperature});
}

List<Forecast> generateForecastData() {
  // Replace this with your actual logic to generate forecast data
  return [
    Forecast(date: DateTime.now(), temperature: 25.0),
    Forecast(date: DateTime.now().add(Duration(days: 1)), temperature: 26.0),
    Forecast(date: DateTime.now().add(Duration(days: 2)), temperature: 27.0),
    Forecast(date: DateTime.now().add(Duration(days: 3)), temperature: 28.0),
    Forecast(date: DateTime.now().add(Duration(days: 4)), temperature: 29.0),
  ];
}

class Station5 extends StatefulWidget {
  @override
  _Station1State createState() => _Station1State();
}

class _Station1State extends State<Station5> {
  String temperature = 'Loading...';
  String temperatureImage = '';
  String minTemperature = '0.0'; // Initialize with default values
  String maxTemperature = '0.0';

  // Declare chartData as a class-level variable
  List<FlSpot> chartData = [];

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    final apiKey = '18f7a399df9430c3caf72475bda83d38';

    final lat = 37.5507	;
    final lon = 127.135	;

    final weatherService = WeatherService(apiKey: apiKey);

    try {
      final weatherData =
      await weatherService.fetchWeatherData(lat, lon);
      setState(() {
        temperature = '${weatherData['temperature']}°C';
        temperatureImage = weatherData['image'];
        minTemperature = '${weatherData['minTemperature']}°C';
        maxTemperature = '${weatherData['maxTemperature']}°C';
      });

      // Update chartData here with your actual temperature data
      chartData = [
        FlSpot(0, 25), // Past data
        FlSpot(1, 26), // Past data
        // ... Add more past data ...
        FlSpot(11, double.parse(weatherData['minTemperature'].replaceAll('°C', ''))), // Forecasted data (min temp)
        FlSpot(12, double.parse(weatherData['maxTemperature'].replaceAll('°C', ''))), // Forecasted data (max temp)
        // ... Add more forecasted data ...
      ];
    } catch (error) {
      setState(() {
        temperature = 'Error loading data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final forecastData = generateForecastData();

    return Scaffold(
      appBar: null,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              // Colors.yellow.withOpacity(0.6),
              Colors.blue.withOpacity(0.4),
              Colors.blue.withOpacity(0.3),
              Colors.blue.withOpacity(0.1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 70,
              left: 40,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.white, // Set the background color to white
                  border: Border.all(
                    color: Colors.blue, // Border color (blue)
                    width: 3.0, // Border width
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Today',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      temperature,
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5), // Add spacing
                    Row(
                      children: [
                        Text(
                          'Min: $minTemperature',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(width: 10), // Add spacing
                        Text(
                          'Max: $maxTemperature',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 70,
              left: 210,
              child: Image.asset(
                temperatureImage,
                width: 120,
                height: 150,
              ),
            ),
            Positioned(
              top: 280, // Adjust the position according to your layout
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '5-Day Forecast',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 150, // Adjust the height as needed
                    child: ListView.builder(
                      itemCount: forecastData.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, index) {
                        final forecast = forecastData[index];
                        final DateFormat dateFormat = DateFormat('EEE');
                        final DateFormat monthDayFormat = DateFormat('MMM d');
                        return Card(
                          color: Colors.white,
                          shadowColor: Colors.yellow[800],
                          elevation: 2,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  dateFormat.format(forecast.date),
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  '${forecast.temperature}°C',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  monthDayFormat.format(forecast.date),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 500, // Adjust the position according to your layout
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '10-Day Temperature Chart',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 200, // Adjust the height as needed
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: const Color(0xff37434d),
                            width: 1,
                          ),
                        ),
                        minX: 0,
                        maxX: 22, // Adjust the maximum x-axis value based on your data
                        minY: 0,
                        maxY: 40, // Adjust the maximum y-axis value based on your data
                        lineBarsData: [
                          LineChartBarData(
                            spots: chartData, // Use the chartData variable here
                            isCurved: true,
                            colors: [Colors.blue],
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
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
      ),
    );
  }
}
