import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/model/restaurant_in_list.dart';
import 'package:restaurant_app/provider/favorite_provider.dart';
import 'package:restaurant_app/provider/restaurants_provider.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';
import 'package:restaurant_app/ui/search_page.dart';
import 'package:restaurant_app/widgets/platform_widget.dart';

class RestaurantListPage extends StatelessWidget {
  const RestaurantListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _androidBuild, iOSBuilder: _iOSBuild);
  }

  Widget _androidBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Restaurant App',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text('Apa yang ingin kamu cari?',
                            style: Theme.of(context).textTheme.bodyMedium),
                        content: TextField(
                          onSubmitted: (String query) {
                            Navigator.pushNamed(context, SearchPage.routeName,
                                arguments: query);
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(30),
                              labelText: 'Ketik di sini'),
                        ),
                      );
                    });
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: _buildRestaurantList(context),
    );
  }

  Widget _iOSBuild(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Restaurant App',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        trailing: IconButton(
            onPressed: () async {
              await showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title: Text('Apa yang ingin kamu cari?',
                          style: Theme.of(context).textTheme.bodyMedium),
                      content: CupertinoTextField(
                        onSubmitted: (String query) {
                          Navigator.pushNamed(context, SearchPage.routeName,
                              arguments: query);
                        },
                        placeholder: 'Ketik di sini',
                      ),
                    );
                  });
            },
            icon: const Icon(Icons.search)),
        transitionBetweenRoutes: false,
      ),
      child: _buildRestaurantList(context),
    );
  }

  Widget _buildRestaurantList(BuildContext context) {
    return Consumer<RestaurantsProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
            ),
          );
        } else if (state.state == ResultState.hasData) {
          return ListView.builder(
            itemCount: state.restaurants.restaurants.length,
            itemBuilder: (context, index) {
              var restaurant = state.restaurants.restaurants[index];
              return _buildRestaurantItem(context, restaurant);
            },
          );
        } else if (state.state == ResultState.noData) {
          return Center(
            child: Material(
              child: Text(state.message),
            ),
          );
        } else if (state.state == ResultState.error) {
          return Center(
            child: Material(
              child: Text(state.message),
            ),
          );
        } else {
          return const Center(
            child: Material(
              child: Text(''),
            ),
          );
        }
      },
    );
  }

  Widget _buildRestaurantItem(
      BuildContext context, RestaurantInList restaurant) {
    return Material(
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Hero(
          tag: restaurant.id,
          child: Image.network(
            'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}',
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
        trailing: Consumer<FavoriteProvider>(
          builder: (context, provider, _) {
            return FutureBuilder(
              future: provider.isFavoriteAdded(restaurant.id),
              builder: (context, snapshot) {
                bool isFavorite = snapshot.data ?? false;
                if (isFavorite) {
                  return IconButton(
                      onPressed: () async {
                        provider.deleteFavorite(restaurant.id);
                      },
                      icon: const Icon(CupertinoIcons.heart_fill));
                } else {
                  return IconButton(
                    onPressed: () async {
                      provider.addFavorite(restaurant);
                    },
                    icon: const Icon(CupertinoIcons.heart_slash),
                  );
                }
              },
            );
          },
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
          Navigator.pushNamed(context, RestaurantDetailPage.routeName,
              arguments: restaurant);
        },
      ),
    );
  }
}
