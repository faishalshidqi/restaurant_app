import 'dart:convert';

RestaurantInList restaurantInListFromJson(String str) =>
    RestaurantInList.fromJson(json.decode(str));

String restaurantInListToJson(RestaurantInList data) =>
    json.encode(data.toJson());

class RestaurantInList {
  late String id;
  late String name;
  late String description;
  late String pictureId;
  late String city;
  late double rating;

  RestaurantInList({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'picture_id': pictureId,
      'city': city,
      'rating': rating
    };
  }

  RestaurantInList.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    description = map['description'];
    pictureId = map['picture_id'];
    city = map['city'];
    rating = map['rating'];
  }

  factory RestaurantInList.fromJson(Map<String, dynamic> json) {
    return RestaurantInList(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      pictureId: json["pictureId"],
      city: json["city"],
      rating: json["rating"]?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "pictureId": pictureId,
        "city": city,
        "rating": rating,
      };
}
