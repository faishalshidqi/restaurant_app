import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/provider/search_provider.dart';
import 'package:restaurant_app/widgets/platform_widget.dart';
import 'package:restaurant_app/widgets/restaurant_card.dart';

class SearchPage extends StatelessWidget {
  static const routeName = '/search';
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _androidBuild, iOSBuilder: _iOSBuild);
  }

  Widget _buildSearchPage(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: TextField(
                onSubmitted: (String value) async {
                  await showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return _buildSearchList(context, value);
                      });
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Input Something To Search Here'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _androidBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: _buildSearchPage(context),
    );
  }

  Widget _iOSBuild(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            'Search',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(CupertinoIcons.back)),
        ),
        child: _buildSearchPage(context));
  }

  Widget _buildSearchList(BuildContext context, String query) {
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(apiService: ApiService(), query: query),
      child: Consumer<SearchProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.grey,
              ),
            );
          } else if (state.state == ResultState.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: state.searched.restaurants.length,
              itemBuilder: (context, index) {
                var result = state.searched.restaurants[index];
                return RestaurantCard(restaurant: result);
              },
            );
          } else if (state.state == ResultState.error) {
            return Center(
              child: Material(
                child: Text(state.message),
              ),
            );
          } else if (state.state == ResultState.noData) {
            return Center(
              child: Material(
                child: Text(state.message),
              ),
            );
          } else {
            return const Material(
              child: Text(''),
            );
          }
        },
      ),
    );
  }
}
