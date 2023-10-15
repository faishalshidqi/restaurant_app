import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

Widget _buildMenuItem(BuildContext context, Drink menu) {
  return Material(
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        menu.name,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ),
  );
}

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = '/restaurant_detail';
  final Restaurant restaurant;
  const RestaurantDetailPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
      ),
      body: FutureBuilder<String>(
        future: DefaultAssetBundle.of(context).loadString('assets/local_restaurant.json'),
        builder: (context, snapshot) {
          final Menus menus = menusFromJson(restaurant.menus.toString());
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(restaurant.pictureId),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.pin_drop_outlined,
                              size: 25,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              restaurant.city,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                                Icons.star_border,
                                size: 25
                            ),
                            const SizedBox(width: 15),
                            Text(
                              restaurant.rating.toString(),
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 5,
                        ),
                        Text(
                          'Tentang Restoran Ini',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                            restaurant.description
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 5,
                        ),
                        Text(
                          'Menu',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        ListView.builder(
                          itemCount: menus.foods.length,
                          itemBuilder: (context, index) {
                            return _buildMenuItem(context, menus.foods[index]);
                          },
                        )
                        /*Table(
                              columnWidths: const {1:FractionColumnWidth(0.75)},
                              children: [
                                TableRow(
                                    children: [
                                      const Text('Makanan'),
                                      Column(
                                        children:
                                        [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(restaurant.menus.foods[index].name),
                                          ),
                                        ],
                                      ),
                                    ]
                                ),
                                TableRow(
                                    children: [
                                      const Text('Minuman'),
                                      Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(restaurant.menus.drinks[0].name),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(restaurant.menus.drinks[1].name),
                                          ),
                                        ],
                                      ),
                                    ]
                                ),
                              ],
                            )*/
                      ],
                    ),
                  )
                ],
              ),
            );
              /*ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                return
              },
            );*/
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
      )
    );
  }
}
