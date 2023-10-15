import 'dart:convert';

import 'package:restaurant_app/data/model/restaurant.dart';

Restaurants parsedFromJson(String str) =>
    Restaurants.fromJson(json.decode(str));

String parseToJson(Restaurants data) => json.encode(data.toJson());

class Restaurants {
  List<Restaurant> restaurants;

  Restaurants({
    required this.restaurants,
  });

  factory Restaurants.fromJson(Map<String, dynamic> json) => Restaurants(
        restaurants: List<Restaurant>.from(
            json["restaurants"].map((x) => Restaurant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}
