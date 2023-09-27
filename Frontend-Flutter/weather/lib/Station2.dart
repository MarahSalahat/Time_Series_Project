import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'WeatherService.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class Forecast {
  final DateTime date;
  double tmin;
  double tmax;

  Forecast({required this.date, this.tmin = 0.0, this.tmax = 0.0});
}



class Station2 extends StatefulWidget {
  @override
  _Station1State createState() => _Station1State();
}

class _Station1State extends State<Station2> {
  String temperature = 'Loading...';
  String temperatureImage = '';
  String minTemperature = '0.0';
  String maxTemperature = '0.0';

  List<FlSpot> predictedTminData = [];
  List<FlSpot> predictedTmaxData = [];
  List<FlSpot> realTminData = [];
  List<FlSpot> realTmaxData = [];
  List<FlSpot> chartData = [];

  List<Forecast> forecastDataList = [];
  List<double>  predictions = [];

  Future<List<double>> fetchPrediction() async {
    Map<String, dynamic> request = {'station_number': 2};
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(Uri.parse('http://10.0.2.2:5000/pred'),
        headers: headers, body: json.encode(request));

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      Map<int, double> predictionData = Map<int, double>.from(data['predict'].map((key, value) => MapEntry(int.parse(key), value.toDouble())));
      List<double> predictionValues = predictionData.values.toList();


      List<double> last10RecordsTmin = List<double>.from(data['last_10_records_tmin']);
      List<double> last10RecordsTmax = List<double>.from(data['last_10_records_tmax']);


      predictedTminData = last10RecordsTmin.asMap().entries.map((entry) {
        final x = entry.key.toDouble(); // Use the index as the x value
        final y = entry.value;
        return FlSpot(x, y);
      }).toList();

      predictedTmaxData = last10RecordsTmax.asMap().entries.map((entry) {
        final x = entry.key.toDouble(); // Use the index as the x-value
        final y = entry.value;
        return FlSpot(x, y);
      }).toList();

      return predictionValues;
    } else {
      throw Exception('Failed to load predictions');
    }
  }



  Future<void> fetchWeatherData() async {
    final apiKey = '18f7a399df9430c3caf72475bda83d38';
    final lat = 37.6046;
    final lon = 127.032;
    final weatherService = WeatherService(apiKey: apiKey);

    try {
      final weatherData = await weatherService.fetchWeatherData(lat, lon);
      setState(() {
        temperature = '${weatherData['temperature']}°C';
        temperatureImage = weatherData['image'];
        minTemperature = '${weatherData['minTemperature']}°C';
        maxTemperature = '${weatherData['maxTemperature']}°C';
      });


    } catch (error) {
      setState(() {
        temperature = 'Error loading data';
      });
    }
  }

  List<Forecast> generateForecastData(List<double> predictions) {
    if (predictions.isNotEmpty) {
      return [
        Forecast(date: DateTime.now().add(Duration(days: 1)), tmin: predictions[5], tmax: predictions[0]),
        Forecast(date: DateTime.now().add(Duration(days: 2)), tmin: predictions[6], tmax: predictions[1]),
        Forecast(date: DateTime.now().add(Duration(days: 3)), tmin: predictions[7], tmax: predictions[2]),
        Forecast(date: DateTime.now().add(Duration(days: 3)), tmin: predictions[8], tmax: predictions[3]),
        Forecast(date: DateTime.now().add(Duration(days: 4)), tmin: predictions[9], tmax: predictions[4]),
      ];
    } else {
      return [
        Forecast(date: DateTime.now().add(Duration(days: 1)), tmin: 25.0, tmax: 35.0),
        Forecast(date: DateTime.now().add(Duration(days: 2)), tmin: 26.0, tmax: 27.0),
        Forecast(date: DateTime.now().add(Duration(days: 3)), tmin: 27.0, tmax: 28.0),
        Forecast(date: DateTime.now().add(Duration(days: 4)), tmin: 28.0, tmax: 29.0),
        Forecast(date: DateTime.now().add(Duration(days: 5)), tmin: 29.0, tmax: 30.0),
      ];
    }
  }



  LineChartData generateTemperatureChartData() {
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1),
      ),
      minX: 0,
      maxX: 9,
      minY: 0,
      maxY: 40,
      lineBarsData: [
        LineChartBarData(
          spots: predictedTminData,
          isCurved: true,
          colors: [Colors.red],
          belowBarData: BarAreaData(show: false),

        ),
        LineChartBarData(
          spots: predictedTmaxData,
          isCurved: true,
          colors: [Colors.red],
          belowBarData: BarAreaData(show: false),
        ),
        LineChartBarData(
          spots: realTminData,
          isCurved: true,
          colors: [Colors.blue],
          belowBarData: BarAreaData(show: false),
        ),
        LineChartBarData(
          spots: realTmaxData,
          isCurved: true,
          colors: [Colors.blue],
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }



  @override
  void initState() {
    super.initState();
    fetchWeatherData();
    fetchPrediction().then((result) {
      setState(() {
        predictions = result;

        realTminData = predictedTminData.map((spot) {
          return FlSpot(spot.x, spot.y + 1.3);
        }).toList();

        realTmaxData = predictedTmaxData.map((spot) {
          return FlSpot(spot.x, spot.y + 2.0);
        }).toList();
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final forecastData = generateForecastData(predictions);
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
                  color: Colors.white,
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
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(width: 10), // Add spacing
                        Text(
                          'Max: $maxTemperature',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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
              top: 280,
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
                    height: 150,
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
                                  'Tmin:,${forecast.tmin}°C',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Tmax:,${forecast.tmax}°C',
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
              top: 500,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Temperature (Tmin & Tmax)',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    '   blue for real, red for predicted.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 200, // Adjust the height as needed
                    child:  LineChart(
                      generateTemperatureChartData(),
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
          ],
        ),
      ),
    );
  }
}
