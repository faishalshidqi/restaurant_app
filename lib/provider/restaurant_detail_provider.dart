import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  //late bool isAdded;
  static const isAdded = 'FavIsAdded';
  bool _isInFavorite = false;

  RestaurantDetail get restaurantDetail => _restaurantDetail;
  ResultState get state => _state;
  String get message => _message;

  bool get isInFavorite => _isInFavorite;

  void _getIsInFavorite() async {
    _isInFavorite = await isFavRestaurantAdded;
    notifyListeners();
  }

  Future<bool> get isFavRestaurantAdded async {
    final prefs = await SharedPreferences.getInstance();
    print("isFavRestaurantAdded: ${prefs.getBool('${id}_isAdded')}");
    return prefs.getBool('${id}_isAdded') ?? false;
  }

  void setFavorite(bool value) {
    addFavToSP(value);
    _getIsInFavorite();
  }

  void addFavToSP(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('${id}_isAdded', value);
  }

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
