import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../constents/api_constents.dart';

class WeatherService {
  Future<WeatherModel> getCurrentWeather() async {
    try {
      // final position = await _getCurrentLocation();

      final url = ApiConstants.weatherByCoordinates(11.7500, 75.5333);

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }
}
