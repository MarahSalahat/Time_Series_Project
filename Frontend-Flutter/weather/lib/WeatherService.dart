import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey;

  WeatherService({required this.apiKey});

  Future<Map<String, dynamic>> fetchWeatherData(double lat, double lon) async {
    final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final mainData = data['main'];

        final tempKelvin = mainData['temp'];
        final tempCelsius = tempKelvin - 273.15;

        final tempMinKelvin = mainData['temp_min'];
        final tempMinCelsius = tempMinKelvin - 273.15;

        final tempMaxKelvin = mainData['temp_max'];
        final tempMaxCelsius = tempMaxKelvin - 273.15;

        // Define temperature ranges and their corresponding image URLs
        final temperatureImages = {
          'cold': 'assets/images/cold-removebg-preview.png',
          'cool': 'assets/images/cool-removebg-preview.png',
          'optimal': 'assets/images/optimal-removebg-preview.png',
          'warm': 'assets/images/warm-removebg-preview.png',
          'heat': 'assets/images/heat-removebg-preview.png',
          'extreme_heat': 'assets/images/extremeheat-removebg-preview (1).png',
        };

        String temperatureRange;
        if (tempCelsius < 0) {
          temperatureRange = 'cold';
        } else if (tempCelsius < 10) {
          temperatureRange = 'cool';
        } else if (tempCelsius < 20) {
          temperatureRange = 'optimal';
        } else if (tempCelsius < 30) {
          temperatureRange = 'warm';
        } else if (tempCelsius < 40) {
          temperatureRange = 'heat';
        } else {
          temperatureRange = 'extreme_heat';
        }

        final temperatureImage = temperatureImages[temperatureRange];

        return {
          'temperature': tempCelsius.toStringAsFixed(1),
          'minTemperature': tempMinCelsius.toStringAsFixed(1),
          'maxTemperature': tempMaxCelsius.toStringAsFixed(1),
          'image': temperatureImage,
        };
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (error) {
      throw Exception('Error loading data: $error');
    }
  }
}
