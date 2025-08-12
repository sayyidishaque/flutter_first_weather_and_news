class HourlyWeather {
  final String time;
  final double temperature;

  HourlyWeather({required this.time, required this.temperature});

  String get formattedTime {
    try {
      final dateTime = DateTime.parse(time);
      return '${dateTime.hour.toString().padLeft(2, '0')}:00';
    } catch (e) {
      return time;
    }
  }

  String get dayName {
    try {
      final dateTime = DateTime.parse(time);
      final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return weekdays[dateTime.weekday - 1];
    } catch (e) {
      return '';
    }
  }
}

class WeatherModel {
  final double latitude;
  final double longitude;
  final String timezone;
  final double elevation;
  final List<HourlyWeather> hourlyWeather;

  WeatherModel({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.elevation,
    required this.hourlyWeather,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final timeList = List<String>.from(json['hourly']['time']);
    final temperatureList = List<double>.from(
      json['hourly']['temperature_2m'].map((temp) => (temp as num).toDouble()),
    );

    final hourlyWeatherList = <HourlyWeather>[];
    for (int i = 0; i < timeList.length; i++) {
      hourlyWeatherList.add(
        HourlyWeather(time: timeList[i], temperature: temperatureList[i]),
      );
    }

    return WeatherModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timezone: json['timezone'] ?? 'GMT',
      elevation: (json['elevation'] as num?)?.toDouble() ?? 0.0,
      hourlyWeather: hourlyWeatherList,
    );
  }

  // Get current temperature (first entry is current hour)
  double get currentTemperature =>
      hourlyWeather.isNotEmpty ? hourlyWeather.first.temperature : 0.0;

  // Get today's temperatures (next 24 hours)
  List<HourlyWeather> get todayWeather {
    final now = DateTime.now();
    return hourlyWeather.where((weather) {
      try {
        final weatherTime = DateTime.parse(weather.time);
        return weatherTime.day == now.day && weatherTime.month == now.month;
      } catch (e) {
        return false;
      }
    }).toList();
  }

  // Get temperature range for today
  Map<String, double> get todayRange {
    final todayTemps = todayWeather.map((w) => w.temperature).toList();
    if (todayTemps.isEmpty) return {'min': 0.0, 'max': 0.0};

    return {
      'min': todayTemps.reduce((a, b) => a < b ? a : b),
      'max': todayTemps.reduce((a, b) => a > b ? a : b),
    };
  }

  // Get location name based on coordinates (you can enhance this with reverse geocoding)
  String get locationName {
    // This is a simple approximation - you can improve this with actual reverse geocoding
    if (latitude >= 8.0 &&
        latitude <= 12.0 &&
        longitude >= 75.0 &&
        longitude <= 77.0) {
      return 'Calicut, Kerala';
    }
    return '${latitude.toStringAsFixed(2)}, ${longitude.toStringAsFixed(2)}';
  }

  // Get weather condition based on temperature (simplified)
  String get weatherCondition {
    final temp = currentTemperature;
    if (temp >= 35) return 'Very Hot';
    if (temp >= 30) return 'Hot';
    if (temp >= 25) return 'Warm';
    if (temp >= 20) return 'Pleasant';
    if (temp >= 15) return 'Cool';
    return 'Cold';
  }

  // Get weather icon based on temperature and time
  String get weatherIcon {
    final temp = currentTemperature;
    final now = DateTime.now();
    final isDay = now.hour >= 6 && now.hour < 18;

    if (temp >= 35) return isDay ? '☀️' : '🌙';
    if (temp >= 30) return isDay ? '🌤️' : '🌙';
    if (temp >= 25) return isDay ? '⛅' : '🌙';
    if (temp >= 20) return isDay ? '🌥️' : '🌙';
    return isDay ? '☁️' : '🌙';
  }
}
