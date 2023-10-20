import 'dart:convert';

import 'package:restaurant_app/data/model/restaurant_in_list.dart';

Restaurants parsedFromJson(String str) =>
    Restaurants.fromJson(json.decode(str));

String parseToJson(Restaurants data) => json.encode(data.toJson());

class Restaurants {
  bool error;
  String message;
  int count;
  List<RestaurantInList> restaurants;

  Restaurants({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory Restaurants.fromJson(Map<String, dynamic> json) => Restaurants(
        error: json['error'],
        message: json['message'],
        count: json['count'],
        restaurants: List<RestaurantInList>.from(
            json["restaurants"].map((x) => RestaurantInList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'error': error,
        'message': message,
        'count': count,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}
