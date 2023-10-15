import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';

class RestaurantListPage extends StatelessWidget {
  const RestaurantListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('Restaurant App'),
      ),
      body: FutureBuilder<String>(
        future: DefaultAssetBundle.of(context).loadString('assets/local_restaurant.json'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //print(snapshot.data);
            final Restaurants data = parsedFromJson(snapshot.data.toString());
            return ListView.builder(
              itemCount: data.restaurants.length,
              itemBuilder: (context, index) {
                return _buildRestaurantItem(context, data.restaurants[index]);
              },
            );
          }
          else if (snapshot.hasError) {
            return const Center(
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  ),
                  Text(
                    'Error loading the data'
                  )
                ],
              ),
            );
          }
          else {
            return const Center(
              child: Column(
                children: [
                  SizedBox(
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Still loading'),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildRestaurantItem(BuildContext context, Restaurant restaurant) {
    return Material(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Hero(
          tag: restaurant.id,
          child: Image.network(
            restaurant.pictureId,
            width: 100,
            errorBuilder: (ctx, error, _) => const Center(
              child: Row(
                children: [
                  Text('Error displaying this restaurant\'s data '),
                  Icon(Icons.error)
                ],
              ),
            ),
          ),
        ),
        title: Text(
          restaurant.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Row(
          children: [
            const Icon(Icons.star_border),
            const SizedBox(width: 5),
            Text(
              restaurant.rating.toString(),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(context, RestaurantDetailPage.routeName, arguments: restaurant);
        },
      ),
    );
  }
}
