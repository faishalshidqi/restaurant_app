import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/model/restaurant_in_list.dart';
import 'package:restaurant_app/provider/db_provider.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';
import 'package:restaurant_app/widgets/platform_widget.dart';

class FavoriteListPage extends StatelessWidget {
  static const routeName = '/favorites';

  const FavoriteListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _androidBuild, iOSBuilder: _iOSBuild);
  }

  Widget _androidBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorite Page',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
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
        transitionBetweenRoutes: false,
      ),
      child: _buildRestaurantList(context),
    );
  }

  Widget _buildRestaurantList(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
            ),
          );
        } else if (state.state == ResultState.hasData) {
          return ListView.builder(
            itemCount: state.favs.length,
            itemBuilder: (context, index) {
              var restaurant = state.favs[index];
              //var provider = Provider.of<RestaurantDetailProvider>(context);
              return Dismissible(
                  key: Key(restaurant.id),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    //provider.updateIsAdded(false);
                    state.deleteFavorite(restaurant.id);
                  },
                  child: _buildRestaurantItem(context, restaurant));
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
    var provider = Provider.of<FavoriteProvider>(context);
    print(provider.isInFavorite);
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
        trailing: Icon(provider.isInFavorite
            ? CupertinoIcons.heart_fill
            : CupertinoIcons.heart_slash),
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
