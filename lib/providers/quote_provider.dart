import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';

class QuoteProvider extends ChangeNotifier {
  List<QuoteModel> _quotes = [];
  List<QuoteModel> _favoriteQuotes = [];
  bool _isLoading = false;
  bool _isLoadingFavorites = false;

  List<QuoteModel> get quotes => _quotes;
  List<QuoteModel> get favoriteQuotes => _favoriteQuotes;
  bool get isLoading => _isLoading;
  bool get isLoadingFavorites => _isLoadingFavorites;

  /// Fetch quotes from online API
  Future<void> fetchQuotes() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('https://api.quotable.io/quotes?limit=20'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> results = data['results'];
        _quotes = results.map((item) => QuoteModel.fromApi(item)).toList();
      } else {
        _quotes = [];
        debugPrint('Failed to fetch quotes: ${response.statusCode}');
      }
    } catch (e) {
      _quotes = [];
      debugPrint('Error fetching quotes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load favorite quotes for a specific user
  Future<void> loadFavoriteQuotes(String userId) async {
    _isLoadingFavorites = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'favorites_$userId';
      final List<String>? storedFavorites = prefs.getStringList(key);

      if (storedFavorites != null) {
        _favoriteQuotes = storedFavorites
            .map((jsonStr) => QuoteModel.fromMap(jsonDecode(jsonStr)))
            .toList();
      } else {
        _favoriteQuotes = [];
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      _favoriteQuotes = [];
    } finally {
      _isLoadingFavorites = false;
      notifyListeners();
    }
  }

  /// Check if a quote is favorited
  bool isFavorite(String quoteText) {
    return _favoriteQuotes.any((q) => q.text == quoteText);
  }

  /// Add or remove a quote from favorites
  Future<void> toggleFavorite(String userId, QuoteModel quote) async {
    if (isFavorite(quote.text)) {
      _favoriteQuotes.removeWhere((q) => q.text == quote.text);
    } else {
      _favoriteQuotes.add(quote);
    }
    notifyListeners();
    await _saveFavoritesLocally(userId);
  }

  /// Save favorite quotes to local storage
  Future<void> _saveFavoritesLocally(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'favorites_$userId';
      final List<String> storedFavorites = _favoriteQuotes.map((q) => jsonEncode(q.toMap())).toList();
      await prefs.setStringList(key, storedFavorites);
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }
}
