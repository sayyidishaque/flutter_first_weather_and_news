import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF87CEEB), Color(0xFF98D8E8), Color(0xFFF0F8FF)],
          ),
        ),
        child: SafeArea(
          child: Consumer<WeatherProvider>(
            builder: (context, weatherProvider, child) {
              return RefreshIndicator(
                onRefresh: () => weatherProvider.fetchWeather(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Current Weather',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 3,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildWeatherContent(context, weatherProvider),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherContent(BuildContext context, WeatherProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: Column(
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Getting your location...',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (provider.hasError) {
      return Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.white70),
            const SizedBox(height: 16),
            Text(
              'Error loading weather data',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              provider.errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => provider.fetchWeather(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (provider.hasData) {
      final weather = provider.weather!;
      return Column(
        children: [
          _buildCurrentWeatherCard(weather),
          const SizedBox(height: 20),
          _buildHourlyForecast(weather),
          const SizedBox(height: 20),
          _buildWeatherDetails(weather),
        ],
      );
    }

    return Center(
      child: Column(
        children: [
          const Icon(Icons.wb_sunny_outlined, size: 64, color: Colors.white70),
          const SizedBox(height: 16),
          const Text(
            'Welcome!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the button below to get current weather',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => provider.fetchWeather(),
            icon: const Icon(Icons.location_on),
            label: const Text('Get Weather'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentWeatherCard(weather) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Colors.white, Color(0xFFF8F8FF)],
          ),
        ),
        child: Column(
          children: [
            Text(
              weather.locationName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E4057),
              ),
            ),
            const SizedBox(height: 16),
            Text(weather.weatherIcon, style: const TextStyle(fontSize: 80)),
            const SizedBox(height: 16),
            Text(
              '${weather.currentTemperature.round()}°C',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E4057),
              ),
            ),
            Text(
              weather.weatherCondition,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF5A6C7D),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text(
                      'HIGH',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF5A6C7D),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${weather.todayRange['max']?.round() ?? 0}°',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E4057),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: const Color(0xFF5A6C7D).withValues(alpha: 0.3),
                ),
                Column(
                  children: [
                    const Text(
                      'LOW',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF5A6C7D),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${weather.todayRange['min']?.round() ?? 0}°',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E4057),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHourlyForecast(weather) {
    final todayWeather = weather.todayWeather
        .take(12)
        .toList(); // Show next 12 hours

    if (todayWeather.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withValues(alpha: 0.9),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hourly Forecast',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E4057),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: todayWeather.length,
                itemBuilder: (context, index) {
                  final hourWeather = todayWeather[index];
                  return Container(
                    width: 60,
                    margin: const EdgeInsets.only(right: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          hourWeather.formattedTime,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF5A6C7D),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF87CEEB,
                            ).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getTempIcon(hourWeather.temperature),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        Text(
                          '${hourWeather.temperature.round()}°',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E4057),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTempIcon(double temp) {
    if (temp >= 30) return '☀️';
    if (temp >= 25) return '🌤️';
    if (temp >= 20) return '⛅';
    return '☁️';
  }

  Widget _buildWeatherDetails(weather) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withValues(alpha: 0.9),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Location Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E4057),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailItem(
                  Icons.location_on,
                  'Coordinates',
                  '${weather.latitude.toStringAsFixed(2)}, ${weather.longitude.toStringAsFixed(2)}',
                ),
                _buildDetailItem(
                  Icons.terrain,
                  'Elevation',
                  '${weather.elevation.round()}m',
                ),
                _buildDetailItem(
                  Icons.access_time,
                  'Timezone',
                  weather.timezone.split('/').last,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 32, color: const Color(0xFF5A6C7D)),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF5A6C7D),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E4057),
          ),
        ),
      ],
    );
  }
}
