import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/restaurant_detail.dart';
import 'package:restaurant_app/data/model/restaurants.dart';
import 'package:restaurant_app/data/model/review_response.dart';
import 'package:restaurant_app/data/model/searched_restaurant.dart';

class ApiService {
  http.Client? client;

  ApiService({this.client}) {
    client ??= http.Client();
  }

  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<Restaurants> getRestaurants() async {
    final response = await http.get(Uri.parse('$_baseUrl/list'));
    if (response.statusCode == 200) {
      return Restaurants.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurants data');
    }
  }

  Future<RestaurantDetail> getRestaurantDetail(id) async {
    final response = await http.get(Uri.parse('$_baseUrl/detail/$id'));
    if (response.statusCode == 200) {
      return RestaurantDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant\'s detail data');
    }
  }

  Future<SearchedRestaurant> search(query) async {
    final response = await http.get(Uri.parse('$_baseUrl/search?q=$query'));
    if (response.statusCode == 200) {
      return SearchedRestaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('The searched data is not found');
    }
  }

  Future<ReviewResponse> sendReview(id, name, review) async {
    final response = await http.post(Uri.parse('$_baseUrl/review'),
        body: jsonEncode({'id': id, 'name': name, 'review': review}),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 201) {
      return ReviewResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to send review');
    }
  }
}
