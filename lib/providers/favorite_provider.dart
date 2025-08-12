import 'package:flutter/foundation.dart';
import '../models/news_model.dart';
import '../services/favorite_service.dart';

enum FavoritesStatus { initial, loading, loaded, error }

class FavoritesProvider extends ChangeNotifier {
  List<NewsArticle> _favorites = [];
  FavoritesStatus _status = FavoritesStatus.initial;
  String _errorMessage = '';

  // Getters
  List<NewsArticle> get favorites => _favorites;
  FavoritesStatus get status => _status;
  String get errorMessage => _errorMessage;

  bool get isLoading => _status == FavoritesStatus.loading;
  bool get hasError => _status == FavoritesStatus.error;
  bool get hasData => _status == FavoritesStatus.loaded;
  bool get isEmpty => _favorites.isEmpty;
  int get favoritesCount => _favorites.length;

  // Check if article is favorite
  bool isFavorite(NewsArticle article) {
    return _favorites.any((fav) => fav.url == article.url);
  }

  // Load favorites from SharedPreferences
  Future<void> loadFavorites() async {
    _setStatus(FavoritesStatus.loading);

    try {
      _favorites = await FavoritesService.getFavorites();
      _setStatus(FavoritesStatus.loaded);
    } catch (e) {
      _errorMessage = 'Error loading favorites: $e';
      _setStatus(FavoritesStatus.error);
    }
  }

  // Add article to favorites
  Future<bool> addToFavorites(NewsArticle article) async {
    try {
      final success = await FavoritesService.addToFavorites(article);
      if (success) {
        _favorites.add(article);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Error adding to favorites: $e';
      return false;
    }
  }

  // Remove article from favorites
  Future<bool> removeFromFavorites(NewsArticle article) async {
    try {
      final success = await FavoritesService.removeFromFavorites(article);
      if (success) {
        _favorites.removeWhere((fav) => fav.url == article.url);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Error removing from favorites: $e';
      return false;
    }
  }

  // Toggle favorite status
  Future<bool> toggleFavorite(NewsArticle article) async {
    if (isFavorite(article)) {
      return await removeFromFavorites(article);
    } else {
      return await addToFavorites(article);
    }
  }

  // Clear all favorites
  Future<bool> clearAllFavorites() async {
    try {
      final success = await FavoritesService.clearFavorites();
      if (success) {
        _favorites.clear();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Error clearing favorites: $e';
      return false;
    }
  }

  void _setStatus(FavoritesStatus status) {
    _status = status;
    notifyListeners();
  }

  void clearError() {
    if (_status == FavoritesStatus.error) {
      _status = FavoritesStatus.initial;
      _errorMessage = '';
      notifyListeners();
    }
  }
}
