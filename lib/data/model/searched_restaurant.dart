import 'dart:convert';

import 'package:restaurant_app/data/model/restaurant_in_list.dart';

SearchedRestaurant searchedRestaurantFromJson(String str) =>
    SearchedRestaurant.fromJson(json.decode(str));

String searchedRestaurantToJson(SearchedRestaurant data) =>
    json.encode(data.toJson());

class SearchedRestaurant {
  bool error;
  int founded;
  List<RestaurantInList> restaurants;

  SearchedRestaurant({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory SearchedRestaurant.fromJson(Map<String, dynamic> json) {
    return SearchedRestaurant(
      error: json["error"],
      founded: json["founded"],
      restaurants: List<RestaurantInList>.from(
          json["restaurants"].map((x) => RestaurantInList.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "error": error,
        "founded": founded,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}
