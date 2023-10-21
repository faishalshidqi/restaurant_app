import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/searched_restaurant.dart';

class SearchProvider extends ChangeNotifier {
  final ApiService apiService;
  final String query;

  SearchProvider({required this.apiService, required this.query}) {
    _searchQuery(query);
  }

  late SearchedRestaurant _searched;
  late ResultState _state;
  String _message = '';

  SearchedRestaurant get searched => _searched;
  ResultState get state => _state;
  String get message => _message;

  Future<dynamic> _searchQuery(query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final searchResult = await apiService.search(query);
      if (searchResult.founded == 0) {
        _state = ResultState.noData;
        notifyListeners();
        return _message =
            'Nothing Found. Tap anywhere outside of this text to back to the search page';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _searched = searchResult;
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
