import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant_in_list.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantInList restaurant;

  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Hero(
          tag: restaurant.id,
          child: Image.network('https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}'),
        ),
        title: Text(restaurant.name),
        subtitle: Text(restaurant.city),
        onTap: () => Navigator.pushReplacementNamed(context, RestaurantDetailPage.routeName, arguments: restaurant),
      ),
    );
  }
}
