import 'package:flutter/material.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/model/restaurant_in_list.dart';
import 'package:restaurant_app/utils/database_helper.dart';

class DbProvider extends ChangeNotifier {
  List<RestaurantInList> _favs = [];

  List<RestaurantInList> get favs => _favs;

  late ResultState _state;

  ResultState get state => _state;

  String _message = '';

  String get message => _message;

  late DatabaseHelper _dbHelper;

  DbProvider() {
    _dbHelper = DatabaseHelper();
    _getFavorites();
  }

  dynamic _getFavorites() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      _favs = await _dbHelper.getFavorites();
      if (_favs.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _favs;
      }
    } catch (error) {
      _state = ResultState.error;
      notifyListeners();
      return '$error';
    }
  }

  Future<void> addFavorite(RestaurantInList restaurant) async {
    await _dbHelper.insertFavorite(restaurant);
    _getFavorites();
  }

  Future<RestaurantInList> getFavoriteById(String id) async {
    return await _dbHelper.getFavoriteById(id);
  }

  void deleteFavorite(String id) async {
    await _dbHelper.deleteFavorite(id);
    _getFavorites();
  }
}
