import 'dart:convert';

RestaurantInList restaurantInListFromJson(String str) =>
    RestaurantInList.fromJson(json.decode(str));

String restaurantInListToJson(RestaurantInList data) =>
    json.encode(data.toJson());

class RestaurantInList {
  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;

  RestaurantInList({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory RestaurantInList.fromJson(Map<String, dynamic> json) =>
      RestaurantInList(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        pictureId: json["pictureId"],
        city: json["city"],
        rating: json["rating"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "pictureId": pictureId,
        "city": city,
        "rating": rating,
      };
}
