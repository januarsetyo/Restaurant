import 'dart:async';
import 'package:restaurant/data/api/api_restaurant.dart';
import 'package:restaurant/data/model/restaurants.dart';
import 'package:flutter/material.dart';

enum ResultState { loading, noData, hasData, error }

class DetailRestaurantsProvider extends ChangeNotifier {
  final ApiRestaurant apiService;
  final String id;

  DetailRestaurantsProvider({required this.apiService, required this.id}) {
    _fetchAllRestaurant(id);
  }

  late DetailRestaurant _detailRestaurant;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  DetailRestaurant get result => _detailRestaurant;

  ResultState get state => _state;

  Future<dynamic> _fetchAllRestaurant(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final detailRestaurant = await apiService.detailMenu(id);
      if (detailRestaurant.error) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _detailRestaurant = detailRestaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'No Connection!';
    }
  }
}
