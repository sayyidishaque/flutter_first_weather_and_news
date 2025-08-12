import 'package:flutter/foundation.dart';
import '../models/news_model.dart';
import '../services/news_service.dart';

enum NewsStatus { initial, loading, loaded, error }

class NewsProvider extends ChangeNotifier {
  final NewsService _newsService = NewsService();

  List<NewsArticle> _articles = [];
  NewsStatus _status = NewsStatus.initial;
  String _errorMessage = '';

  // Getters
  List<NewsArticle> get articles => _articles;
  NewsStatus get status => _status;
  String get errorMessage => _errorMessage;

  bool get isLoading => _status == NewsStatus.loading;
  bool get hasError => _status == NewsStatus.error;
  bool get hasData => _status == NewsStatus.loaded && _articles.isNotEmpty;

  Future<void> fetchNews({String country = 'us'}) async {
    _setStatus(NewsStatus.loading);

    try {
      final newsResponse = await _newsService.getTopHeadlines(country: country);
      _articles = newsResponse.articles;
      _setStatus(NewsStatus.loaded);
    } catch (e) {
      _errorMessage = e.toString();
      _setStatus(NewsStatus.error);
    }
  }

  void _setStatus(NewsStatus status) {
    _status = status;
    notifyListeners();
  }

  void clearError() {
    if (_status == NewsStatus.error) {
      _status = NewsStatus.initial;
      _errorMessage = '';
      notifyListeners();
    }
  }
}
