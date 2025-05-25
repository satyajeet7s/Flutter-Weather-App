// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/weather.dart';
// import '../models/forecast.dart';

// class WeatherService {
//   final String apiKey = '840270d5930e1685b79be717f8d743c2'; // Your API key
//   final String baseUrl = 'https://api.openweathermap.org/data/2.5';

//   Future<Weather> fetchCurrentWeather(String city) async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/weather?q=$city&appid=$apiKey'),
//     );

//     if (response.statusCode == 200) {
//       return Weather.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception('Failed to load weather data');
//     }
//   }

//   Future<List<Forecast>> fetchForecast(String city) async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/forecast?q=$city&appid=$apiKey'),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return (data['list'] as List)
//           .map((item) => Forecast.fromJson(item))
//           .toList();
//     } else {
//       throw Exception('Failed to load forecast data');
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../models/forecast.dart';

class WeatherService {
  static const String _apiKey =
      '840270d5930e1685b79be717f8d743c2'; // Replace with your OpenWeatherMap API key
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Weather> fetchCurrentWeather(String city) async {
    final url =
        Uri.parse('$_baseUrl/weather?q=$city&appid=$_apiKey&units=metric');
    print('Fetching current weather for $city: $url'); // Debug log

    try {
      final response = await http.get(url);
      print(
          'Current weather response status: ${response.statusCode}'); // Debug log
      print('Current weather response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to load current weather data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching current weather: $e'); // Debug log
      rethrow;
    }
  }

  Future<List<Forecast>> fetchForecast(String city) async {
    final url =
        Uri.parse('$_baseUrl/forecast?q=$city&appid=$_apiKey&units=metric');
    print('Fetching forecast for $city: $url'); // Debug log

    try {
      final response = await http.get(url);
      print('Forecast response status: ${response.statusCode}'); // Debug log
      print('Forecast response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> forecastList = data['list'];
        // Filter to get one forecast per day (e.g., at 12:00 PM)
        final List<Forecast> dailyForecasts = [];
        final Map<String, dynamic> dailyData = {};

        for (var item in forecastList) {
          final dateTime =
              DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
          final dateKey = '${dateTime.year}-${dateTime.month}-${dateTime.day}';
          // Take the forecast closest to 12:00 PM for each day
          if (!dailyData.containsKey(dateKey) ||
              (dateTime.hour >= 12 && dateTime.hour < 15)) {
            dailyData[dateKey] = item;
          }
        }

        // Convert to Forecast objects (limit to 5 days)
        dailyData.forEach((key, value) {
          if (dailyForecasts.length < 5) {
            dailyForecasts.add(Forecast.fromJson(value));
          }
        });

        print('Parsed ${dailyForecasts.length} daily forecasts'); // Debug log
        return dailyForecasts;
      } else {
        throw Exception(
            'Failed to load forecast data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching forecast: $e'); // Debug log
      rethrow;
    }
  }
}
