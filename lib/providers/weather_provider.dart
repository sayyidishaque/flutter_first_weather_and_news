import 'package:flutter/foundation.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

enum WeatherStatus { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();

  WeatherModel? _weather;
  WeatherStatus _status = WeatherStatus.initial;
  String _errorMessage = '';

  // Getters
  WeatherModel? get weather => _weather;
  WeatherStatus get status => _status;
  String get errorMessage => _errorMessage;

  bool get isLoading => _status == WeatherStatus.loading;
  bool get hasError => _status == WeatherStatus.error;
  bool get hasData => _status == WeatherStatus.loaded && _weather != null;

  Future<void> fetchWeather() async {
    _setStatus(WeatherStatus.loading);

    try {
      _weather = await _weatherService.getCurrentWeather();

      _setStatus(WeatherStatus.loaded);
    } catch (e) {
      _errorMessage = e.toString();

      _setStatus(WeatherStatus.error);
    }
  }

  void _setStatus(WeatherStatus status) {
    _status = status;
    notifyListeners();
  }

  void clearError() {
    if (_status == WeatherStatus.error) {
      _status = WeatherStatus.initial;
      _errorMessage = '';
      notifyListeners();
    }
  }
}
