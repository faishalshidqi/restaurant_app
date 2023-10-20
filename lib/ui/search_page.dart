import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/provider/search_provider.dart';
import 'package:restaurant_app/widgets/restaurant_card.dart';
import 'package:restaurant_app/widgets/platform_widget.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/search';
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Text(
                  'Search Query',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            TextField(
              controller: _controller,
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
          ],
        ),
      ),
    );
  }

  Widget _androidBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: _buildSearchPage(context),
    );
  }

  Widget _iOSBuild(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Search'),
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
              child: CircularProgressIndicator(),
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
