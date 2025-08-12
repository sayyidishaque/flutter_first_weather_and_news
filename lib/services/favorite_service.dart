import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news_model.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorite_news';

  // Save favorite news article
  static Future<bool> addToFavorites(NewsArticle article) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> favoritesList = prefs.getStringList(_favoritesKey) ?? [];

      // Convert article to JSON string
      String articleJson = jsonEncode(article.toJson());

      // Check if article is already in favorites
      bool isAlreadyFavorite = favoritesList.any((favJson) {
        Map<String, dynamic> fav = jsonDecode(favJson);
        return fav['url'] == article.url;
      });

      if (!isAlreadyFavorite) {
        favoritesList.add(articleJson);
        await prefs.setStringList(_favoritesKey, favoritesList);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Remove from favorites
  static Future<bool> removeFromFavorites(NewsArticle article) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> favoritesList = prefs.getStringList(_favoritesKey) ?? [];

      // Remove article with matching URL
      favoritesList.removeWhere((favJson) {
        Map<String, dynamic> fav = jsonDecode(favJson);
        return fav['url'] == article.url;
      });

      await prefs.setStringList(_favoritesKey, favoritesList);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Check if article is in favorites
  static Future<bool> isFavorite(NewsArticle article) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> favoritesList = prefs.getStringList(_favoritesKey) ?? [];

      return favoritesList.any((favJson) {
        Map<String, dynamic> fav = jsonDecode(favJson);
        return fav['url'] == article.url;
      });
    } catch (e) {
      return false;
    }
  }

  // Get all favorite articles
  static Future<List<NewsArticle>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> favoritesList = prefs.getStringList(_favoritesKey) ?? [];

      return favoritesList.map((favJson) {
        Map<String, dynamic> articleMap = jsonDecode(favJson);
        return NewsArticle.fromJson(articleMap);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Clear all favorites
  static Future<bool> clearFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_favoritesKey);
      return true;
    } catch (e) {
      return false;
    }
  }
}
