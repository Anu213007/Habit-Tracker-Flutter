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
  bool _hasNetworkError = false;

  List<QuoteModel> get quotes => _quotes;
  List<QuoteModel> get favoriteQuotes => _favoriteQuotes;
  bool get isLoading => _isLoading;
  bool get isLoadingFavorites => _isLoadingFavorites;
  bool get hasNetworkError => _hasNetworkError;

  /// Fallback quotes when API is unavailable
  static const List<Map<String, String>> _fallbackQuotes = [
    {
      'text': 'The journey of a thousand miles begins with one step.',
      'author': 'Lao Tzu',
      'category': 'Motivation'
    },
    {
      'text': 'Success is not final, failure is not fatal: it is the courage to continue that counts.',
      'author': 'Winston Churchill',
      'category': 'Success'
    },
    {
      'text': 'The only way to do great work is to love what you do.',
      'author': 'Steve Jobs',
      'category': 'Passion'
    },
    {
      'text': 'Believe you can and you\'re halfway there.',
      'author': 'Theodore Roosevelt',
      'category': 'Belief'
    },
    {
      'text': 'It always seems impossible until it\'s done.',
      'author': 'Nelson Mandela',
      'category': 'Perseverance'
    },
    {
      'text': 'The future belongs to those who believe in the beauty of their dreams.',
      'author': 'Eleanor Roosevelt',
      'category': 'Dreams'
    },
    {
      'text': 'Don\'t watch the clock; do what it does. Keep going.',
      'author': 'Sam Levenson',
      'category': 'Persistence'
    },
    {
      'text': 'The only limit to our realization of tomorrow is our doubts of today.',
      'author': 'Franklin D. Roosevelt',
      'category': 'Optimism'
    },
    {
      'text': 'What you get by achieving your goals is not as important as what you become by achieving your goals.',
      'author': 'Zig Ziglar',
      'category': 'Growth'
    },
    {
      'text': 'The best way to predict the future is to create it.',
      'author': 'Peter Drucker',
      'category': 'Action'
    }
  ];

  /// Fetch quotes from online API
  Future<void> fetchQuotes() async {
    _isLoading = true;
    _hasNetworkError = false;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://api.quotable.io/quotes?limit=20'),
        headers: {'User-Agent': 'HabitTracker/1.0'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> results = data['results'];
        _quotes = results.map((item) => QuoteModel.fromApi(item)).toList();
        debugPrint('✅ Fetched ${_quotes.length} quotes from API');
      } else {
        _useFallbackQuotes();
        debugPrint('⚠️ API returned ${response.statusCode}, using fallback quotes');
      }
    } catch (e) {
      _useFallbackQuotes();
      _hasNetworkError = true;
      debugPrint('❌ Network error: $e, using fallback quotes');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Use fallback quotes when API fails
  void _useFallbackQuotes() {
    _quotes = _fallbackQuotes.map((item) => QuoteModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: item['text']!,
      author: item['author']!,
      category: item['category'],
    )).toList();
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
            .map((jsonStr) {
              final Map<String, dynamic> map = jsonDecode(jsonStr);
              return QuoteModel.fromMap(map, map['id'] ?? '');
            })
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
