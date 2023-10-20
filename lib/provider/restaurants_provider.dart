import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurants.dart';

class RestaurantsProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantsProvider({required this.apiService}) {
    _fetchListRestaurant();
  }

  late Restaurants _restaurants;
  late ResultState _state;
  String _message = '';

  Restaurants get restaurants => _restaurants;
  ResultState get state => _state;
  String get message => _message;

  Future<dynamic> _fetchListRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurantList = await apiService.getRestaurants();
      if (restaurantList.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurants = restaurantList;
      }
    } on SocketException {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'No Internet Connection';
    } on ClientException catch (error) {
      _state = ResultState.error;
      notifyListeners();
      _message = error.message;
      return 'Error --> $_message';
    }
  }
}
