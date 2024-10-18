import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchQueryNotifier extends ChangeNotifier {
  String _query = '';

  String get query => _query;

  void setQuery(String query) {
    _query = query;
    notifyListeners();
  }
}

final searchQueryProvider =
    ChangeNotifierProvider<SearchQueryNotifier>((ref) => SearchQueryNotifier());
