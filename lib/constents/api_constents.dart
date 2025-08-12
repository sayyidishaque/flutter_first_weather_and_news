class ApiConstants {
  static const String weatherApiKey = '9a9a34c2557b856a42adbfdb43ed34e3';
  static const String newsApiKey = 'dafd4c94ef7e46df997b6844f4a4ea1e';

  // API Base URLs
  static const String weatherBaseUrl = 'https://api.open-meteo.com/v1/';
  static const String newsBaseUrl = 'https://newsapi.org/v2/';

  // Endpoints
  static String weatherByCoordinates(double lat, double lon) =>
      '$weatherBaseUrl/forecast/?latitude=11.7500&longitude=75.5333&hourly=temperature_2m';

  static String topHeadlines({String country = 'us'}) =>
      '$newsBaseUrl/top-headlines?country=$country&apiKey=$newsApiKey';
}
