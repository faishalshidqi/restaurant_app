import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_detail.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;
  RestaurantDetailProvider({required this.apiService, required this.id}) {
    _fetchDetailRestaurant(id);
  }
  late RestaurantDetail _restaurantDetail;
  late ResultState _state;
  String _message = '';
  int maxDescLines = 6;
  bool isClicked = false;
  RestaurantDetail get restaurantDetail => _restaurantDetail;
  ResultState get state => _state;
  String get message => _message;

  void updateMaxLines(int lines) {
    maxDescLines = lines;
    notifyListeners();
  }

  void updateIsClicked(bool click) {
    isClicked = click;
    notifyListeners();
  }

  Future<dynamic> _fetchDetailRestaurant(id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.getRestaurantDetail(id);
      if (restaurant.error) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Detail Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantDetail = restaurant;
      }
    } on SocketException {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'No Internet Connection';
    } on ClientException catch (error) {
      _state = ResultState.error;
      notifyListeners();
      _message = error.message;
      return _message;
    }
  }
}
