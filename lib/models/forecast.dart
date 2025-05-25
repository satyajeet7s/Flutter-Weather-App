class Forecast {
  final DateTime dateTime;
  final double temperature;
  final String description;
  final String icon; // Added icon field

  Forecast({
    required this.dateTime,
    required this.temperature,
    required this.description,
    required this.icon,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      dateTime: DateTime.parse(json['dt_txt']),
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'] as String,
      icon: json['weather'][0]['icon'] as String, // Parse icon from JSON
    );
  }
}
