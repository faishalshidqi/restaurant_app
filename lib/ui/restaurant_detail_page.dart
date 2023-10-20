import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/drink.dart';
import 'package:restaurant_app/data/model/restaurant_in_list.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/review_provider.dart';
import 'package:restaurant_app/widgets/review_card.dart';

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

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = '/restaurant_detail';
  final RestaurantInList restaurant;
  const RestaurantDetailPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          RestaurantDetailProvider(apiService: ApiService(), id: restaurant.id),
      child: Consumer<RestaurantDetailProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.state == ResultState.hasData) {
            var result = state.restaurantDetail;
            return Scaffold(
                appBar: AppBar(
                  title: Text(
                    result.restaurant.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                body: SingleChildScrollView(
                  child: Hero(
                    tag: result.restaurant.id,
                    child: Column(
                      children: [
                        Image.network(
                            'https://restaurant-api.dicoding.dev/images/large/${result.restaurant.pictureId}'),
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
                                    result.restaurant.rating.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
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
                                    result.restaurant.city,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.house_outlined,
                                    size: 25,
                                  ),
                                  const SizedBox(width: 15),
                                  Flexible(
                                    child: Text(
                                      result.restaurant.address,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
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
                                result.restaurant.description,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 6,
                                style: Theme.of(context).textTheme.bodyMedium,
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
                                columnWidths: const {
                                  1: FractionColumnWidth(0.7)
                                },
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
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: result
                                            .restaurant.menus.foods.length,
                                        itemBuilder: (context, index) {
                                          return _buildMenuTableItem(
                                              context,
                                              result.restaurant.menus
                                                  .foods[index]);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Table(
                                columnWidths: const {
                                  1: FractionColumnWidth(0.7)
                                },
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
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: result
                                            .restaurant.menus.drinks.length,
                                        itemBuilder: (context, index) {
                                          return _buildMenuTableItem(
                                              context,
                                              result.restaurant.menus
                                                  .drinks[index]);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Colors.grey,
                                thickness: 5,
                              ),
                              Text(
                                'Ulasan',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    result.restaurant.customerReviews.length,
                                itemBuilder: (context, index) {
                                  return ReviewCard(
                                      review: result
                                          .restaurant.customerReviews[index]);
                                },
                              ),
                              Text(
                                'Ulasanmu',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              ChangeNotifierProvider<ReviewProvider>(
                                create: (_) => ReviewProvider(
                                    apiService: ApiService(),
                                    id: result.restaurant.id),
                                child: Consumer<ReviewProvider>(
                                    builder: (context, state, _) {
                                  final providerReview =
                                      Provider.of<ReviewProvider>(context);
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        TextField(
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText:
                                                  'Ketik namamu di sini'),
                                          onChanged: (String name) =>
                                              providerReview.updateName(name),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText:
                                                  'Ketik ulasanmu di sini'),
                                          onChanged: (String reviewed) =>
                                              providerReview
                                                  .updateReviews(reviewed),
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              providerReview
                                                  .postReview(
                                                      result.restaurant.id,
                                                      providerReview.name,
                                                      providerReview.review)
                                                  .whenComplete(
                                                      () => showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Ulasan berhasil ditambahkan'),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context),
                                                                    child: Text(
                                                                      'OK',
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyLarge,
                                                                    ))
                                                              ],
                                                            );
                                                          }));
                                            },
                                            child: Text(
                                              'Tambahkan Ulasan',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge,
                                            ))
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ));
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
      ),
    );
  }
}
