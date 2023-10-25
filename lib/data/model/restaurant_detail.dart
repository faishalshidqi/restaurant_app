import 'dart:convert';

import 'package:restaurant_app/data/model/restaurant_in_detail.dart';

RestaurantDetail restaurantDetailFromJson(String str) =>
    RestaurantDetail.fromJson(json.decode(str));

String restaurantDetailToJson(RestaurantDetail data) =>
    json.encode(data.toJson());

class RestaurantDetail {
  bool error;
  String message;
  RestaurantInDetail restaurant;

  RestaurantDetail({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    return RestaurantDetail(
      error: json["error"],
      message: json["message"],
      restaurant: RestaurantInDetail.fromJson(json["restaurant"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "restaurant": restaurant.toJson(),
      };
}
