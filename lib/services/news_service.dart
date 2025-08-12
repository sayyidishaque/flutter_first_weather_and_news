import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_news_app/constents/api_constents.dart';
import '../models/news_model.dart';

class NewsService {
  Future<NewsResponse> getTopHeadlines({String country = 'us'}) async {
    try {
      final url = ApiConstants.topHeadlines(country: country);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return NewsResponse.fromJson(data);
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }
}
