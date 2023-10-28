import 'package:flutter/material.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/model/restaurant_in_list.dart';
import 'package:restaurant_app/utils/database_helper.dart';
class FavoriteProvider extends ChangeNotifier {
  FavoriteProvider() {
    _dbHelper = DatabaseHelper();
    _getFavorites();
  }

  List<RestaurantInList> _favs = [];
  List<RestaurantInList> get favs => _favs;
  late ResultState _state;
  ResultState get state => _state;
  String _message = '';
  String get message => _message;

  late DatabaseHelper _dbHelper;

  dynamic _getFavorites() async {
    try {
      _state = ResultState.loading;
      _favs = await _dbHelper.getFavorites();
      if (_favs.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
      }
      notifyListeners();
    } catch (error) {
      _state = ResultState.error;
      notifyListeners();
      return '$error';
    }
  }

  Future<void> addFavorite(RestaurantInList restaurant) async {
    try {
      await _dbHelper.insertFavorite(restaurant);
      _getFavorites();
    } catch (error) {
      _state = ResultState.error;
      _message = '$error';
      notifyListeners();
    }
  }

  Future<bool> isFavoriteAdded(String id) async {
    final favorite = await _dbHelper.getFavoriteById(id);
    return favorite.isNotEmpty;
  }

  void deleteFavorite(String id) async {
    try {
      await _dbHelper.deleteFavorite(id);
      _getFavorites();
    } catch (error) {
      _state = ResultState.error;
      _message = '$error';
      notifyListeners();
    }
  }
}
