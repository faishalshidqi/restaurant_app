import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/drink.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

Widget? _buildMenuTableItem(BuildContext context, Drink menu) {
  return Column(
    children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(menu.name),
      ),
    ],
  );
}

class RestaurantDetailPage extends StatefulWidget {
  static const routeName = '/restaurant_detail';
  final Restaurant restaurant;
  const RestaurantDetailPage({super.key, required this.restaurant});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  bool isClicked = false;
  int maxLines = 6;

  String textButton = 'Click here to read more';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.restaurant.name),
        ),
        body: FutureBuilder<String>(
          future: DefaultAssetBundle.of(context)
              .loadString('assets/local_restaurant.json'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Hero(
                  tag: widget.restaurant.id,
                  child: Column(
                    children: [
                      Image.network(widget.restaurant.pictureId),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.star_border, size: 25),
                                const SizedBox(width: 15),
                                Text(
                                  widget.restaurant.rating.toString(),
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.pin_drop_outlined,
                                  size: 25,
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  widget.restaurant.city,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
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
                              widget.restaurant.description,
                              overflow: TextOverflow.fade,
                              maxLines: maxLines,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isClicked = !isClicked;
                                  if (isClicked) {
                                    textButton = 'Read less';
                                    maxLines = 30;
                                  } else {
                                    textButton = 'Click here to read more';
                                    maxLines = 6;
                                  }
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  textButton,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 5,
                            ),
                            Text(
                              'Menu',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Table(
                              columnWidths: const {1: FractionColumnWidth(0.7)},
                              children: [
                                TableRow(
                                  children: [
                                    Text(
                                      'Makanan',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          widget.restaurant.menus.foods.length,
                                      itemBuilder: (context, index) {
                                        return _buildMenuTableItem(
                                            context,
                                            widget
                                                .restaurant.menus.foods[index]);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Table(
                              columnWidths: const {1: FractionColumnWidth(0.7)},
                              children: [
                                TableRow(
                                  children: [
                                    Text(
                                      'Minuman',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          widget.restaurant.menus.drinks.length,
                                      itemBuilder: (context, index) {
                                        return _buildMenuTableItem(
                                            context,
                                            widget.restaurant.menus
                                                .drinks[index]);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                    ),
                    Text('Error loading the data')
                  ],
                ),
              );
            } else {
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
        ));
  }
}
