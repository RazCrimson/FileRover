import 'package:flutter/material.dart';

import '../fs/sorters/enums.dart';

class SortProvider with ChangeNotifier {
  SortBy _sortBy = SortBy.name;
  SortOrder _sortOrder = SortOrder.ascending;

  SortBy get sortBy => _sortBy;

  SortOrder get sortOrder => _sortOrder;

  set sortBy(SortBy sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  set sortOrder(SortOrder sortOrder) {
    _sortOrder = sortOrder;
    notifyListeners();
  }

  void reset() {
    _sortBy = SortBy.name;
    _sortOrder = SortOrder.ascending;
    notifyListeners();
  }
}
