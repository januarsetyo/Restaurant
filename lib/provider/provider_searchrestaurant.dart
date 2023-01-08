import 'package:flutter/material.dart';
import 'package:restaurant/data/api/api_restaurant.dart';
import 'package:restaurant/data/model/restaurants.dart';

enum ResultState { loading, error, noData, hasData }

class SearchProvider extends ChangeNotifier {
  final ApiRestaurant apiService;
  String query;

  SearchProvider({
    required this.apiService,
    this.query = '',
  }) {
    _fetchAllRestaurant(query);
  }

  late SearchRestaurant _searchResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;
  SearchRestaurant get search => _searchResult;
  ResultState? get state => _state;

  restoSearch(String newValue) {
    query = newValue;
    _fetchAllRestaurant(query);
    notifyListeners();
  }

  Future<dynamic> _fetchAllRestaurant(value) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.searchRestaurant(value);
      if (restaurant.restaurants.isNotEmpty) {
        _state = ResultState.hasData;
        notifyListeners();
        return _searchResult = restaurant;
      } else {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'No Connection!';
    }
  }
}
