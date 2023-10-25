import 'package:flutter/material.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/model/restaurant_in_list.dart';
import 'package:restaurant_app/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider extends ChangeNotifier {
  List<RestaurantInList> _favs = [];

  List<RestaurantInList> get favs => _favs;

  late ResultState _state;

  ResultState get state => _state;

  String _message = '';

  String get message => _message;

  late DatabaseHelper _dbHelper;

  static const isAdded = 'FavIsAdded';

  bool _isInFavorite = false;

  bool get isInFavorite => _isInFavorite;

  void _getIsInFavorite(String id) async {
    _isInFavorite = await isFavRestaurantAdded(id);
    notifyListeners();
  }

  Future<bool> isFavRestaurantAdded(String id) async {
    final prefs = await SharedPreferences.getInstance();
    print("isFavRestaurantAdded: ${prefs.getBool('${id}_isAdded')}");
    return prefs.getBool('${id}_isAdded') ?? false;
  }

  void setFavorite(bool value, String id) {
    addFavToSP(value, id);
    _getIsInFavorite(id);
  }

  void addFavToSP(bool value, String id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('${id}_isAdded', value);
  }

  FavoriteProvider() {
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
