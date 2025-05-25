##Flutter Weather App

#Overview
This Flutter Weather App provides real-time weather information for any village or city using the OpenWeatherMap API. It features a clean, user-friendly interface with a dynamic search bar, detailed weather data display, and a forecast summary. The app is designed to handle invalid inputs gracefully and provides a seamless experience for users to check weather conditions.
Features

#Search by Village/City Name#: Enter a village or city name to fetch current weather data and a 5-day forecast.
Dynamic Search Bar: Displays a search icon when empty and a clear (cross) icon when text is entered, allowing users to reset the search.
Weather Details: Shows temperature, humidity, weather conditions, and a weather icon for the searched location.
Forecast Summary: Displays a horizontal scrollable forecast with daily temperature, weather icons, and conditions.
Error Handling: Shows a "No record found" message when a village/city name is not found, replacing the weather UI.
Customizable UI:
Initial screen background is gray for better readability.
Weather conditions dynamically change the background gradient (e.g., yellow for sunny, blue for rainy).

Screenshots
(Add screenshots of your app here, e.g., initial screen, search bar with cross icon, weather data display, and error message screen. You can upload images to the repository and link them here, like:)


Installation
Follow these steps to set up and run the app locally:

Clone the Repository:
git clone https://github.com/your-username/flutter-weather-app.git
cd flutter-weather-app


Install Dependencies:Ensure you have Flutter installed. Then, run:
flutter pub get


###Set Up OpenWeatherMap API Key:

Sign up at OpenWeatherMap and get your API key.
Open lib/services/weather_service.dart and replace YOUR_API_KEY with your actual API key:static const String _apiKey = 'YOUR_API_KEY';


