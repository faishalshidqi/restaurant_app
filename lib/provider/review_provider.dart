import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/review_response.dart';

class ReviewProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;
  String? name;
  String? review;

  ReviewProvider({required this.apiService, required this.id}) {
    postReview(id, name, review);
  }

  late ReviewResponse _reviewResponse;
  late ResultState _state;
  String _message = '';

  ReviewResponse get reviewResponse => _reviewResponse;
  String get message => _message;
  ResultState get state => _state;

  updateName(String value) {
    name = value;
    notifyListeners();
  }

  updateReviews(String value) {
    review = value;
    notifyListeners();
  }

  Future<dynamic> postReview(id, name, review) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final reviewResult = await apiService.sendReview(id, name, review);
      if (reviewResult.error) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Failed sending review';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _reviewResponse = reviewResult;
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
