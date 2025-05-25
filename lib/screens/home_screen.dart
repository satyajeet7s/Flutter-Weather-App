import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/weather_service.dart';
import '../models/weather.dart';
import '../models/forecast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  Weather? _weather;
  List<Forecast> _forecast = [];
  bool _isLoading = false;
  String? _city;
  final TextEditingController _cityController = TextEditingController();

  Future<void> _fetchWeatherData(String city) async {
    if (city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a city name')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _city = city;
    });

    try {
      final weather = await _weatherService.fetchCurrentWeather(city);
      final forecast = await _weatherService.fetchForecast(city);
      setState(() {
        _weather = weather;
        _forecast = forecast;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _weather = null;
        _forecast = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  String _formatDescription(String description) {
    final Map<String, String> weatherDescriptionMap = {
      'clear sky': 'SUNNY',
      'few clouds': 'PARTLY CLOUDS',
      'scattered clouds': 'PARTLY CLOUDS',
      'broken clouds': 'CLOUDY/OVERCAST',
      'overcast clouds': 'CLOUDY/OVERCAST',
      'shower rain': 'RAINY',
      'rain': 'RAINY',
      'light rain': 'LIGHT RAIN',
      'thunderstorm': 'THUNDERSTORM',
      'snow': 'SNOWY',
      'mist': 'MISTY',
    };
    return weatherDescriptionMap[description.toLowerCase()] ??
        description.toUpperCase();
  }

  LinearGradient _getGradient(String? description) {
    switch (_formatDescription(description ?? 'clear sky')) {
      case 'SUNNY':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFE066), Color(0xFFFFE066)],
        );
      case 'PARTLY CLOUDS':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFDDEAF6), Color(0xFFBFD7EA)],
        );
      case 'CLOUDY/OVERCAST':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFB0BEC5), Color(0xFF90A4AE)],
        );
      case 'RAINY':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFA1C4FD), Color(0xFFC2E9FB)],
        );
      case 'THUNDERSTORM':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF5C93D8), Color(0xFF4A7FB8)],
        );
      case 'SNOWY':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE0E0E0), Color(0xFFB0BEC5)],
        );
      case 'MISTY':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF5F5F5), Color(0xFFE0E0E0)],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFB2DFDB), Color(0xFF80CBC4)],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use DateTime.now() to get the current date and time dynamically
    final now = DateTime.now(); // Simulating as May 25, 2025, 05:37 PM IST
    final timeFormat = DateFormat('HH:mm').format(now); // "17:37"
    final dateFormat = DateFormat('EEEE, d MMM yyyy').format(now).toUpperCase(); // "SUNDAY, 25 MAY 2025"

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _getGradient(_weather?.description),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // City Input Field (Pinned at the top)
                TextField(
                  controller: _cityController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Enter Village name',
                    hintStyle: const TextStyle(color: Colors.black54),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Colors.black),
                      onPressed: () {
                        _fetchWeatherData(_cityController.text.trim());
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    _fetchWeatherData(value.trim());
                  },
                ),
                const SizedBox(height: 20),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Show loading indicator or weather UI
                        if (_isLoading)
                          const Center(child: CircularProgressIndicator())
                        else if (_city == null)
                          const Center(
                            child: Text(
                              'Please enter a city to see the weather',
                              style: TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          )
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Time
                              Text(
                                timeFormat,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                ),
                              ),

                              // City Name
                              Text(
                                _weather?.cityName.toUpperCase() ??
                                    _city!.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Container(
                                width: 140,
                                height: 1,
                                color: Colors.black,
                              ),

                              // Date
                              Text(
                                dateFormat,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Temperature and Humidity Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _weather != null
                                        ? '${_weather!.temperature.round()}°'
                                        : 'N/A',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 72,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      children: [
                                        const Text(
                                          'Humidity',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          _weather != null
                                              ? '${_weather!.humidity}%'
                                              : 'N/A',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Weather Icon
                              if (_weather != null)
                                Center(
                                  child: Image.network(
                                    'https://openweathermap.org/img/wn/${_weather!.icon}@2x.png',
                                    width: 100,
                                    height: 100,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.error, color: Colors.black, size: 60),
                                  ),
                                ),
                              const SizedBox(height: 20),

                              // Weather Message (Each word on a separate line)
                              _weather != null
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: "IT'S ${_formatDescription(_weather!.description)} OUT"
                                          .split(' ')
                                          .map((word) {
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 1.0),
                                          child: Text(
                                            word,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 26,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    )
                                  : const Text(
                                      'N/A',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                              const SizedBox(height: 20),

                              // Forecast Summary (Horizontal View with Icons)
                              _forecast.isNotEmpty
                                  ? SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: _forecast.map((forecast) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 10.0),
                                            child: Container(
                                              width: 100,
                                              height: 170,
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    DateFormat('d MMM').format(forecast.dateTime),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Image.network(
                                                    'https://openweathermap.org/img/wn/${forecast.icon}@2x.png',
                                                    width: 80,
                                                    height: 80,
                                                    errorBuilder: (context, error, stackTrace) =>
                                                        const Icon(
                                                          Icons.error,
                                                          color: Colors.white,
                                                          size: 60,
                                                        ),
                                                  ),
                                                  Text(
                                                    '${forecast.temperature.round()}°C',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    _formatDescription(forecast.description).toLowerCase(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('N/A', style: TextStyle(color: Colors.black)),
                                        Text('N/A', style: TextStyle(color: Colors.black)),
                                        Text('N/A', style: TextStyle(color: Colors.black)),
                                      ],
                                    ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}