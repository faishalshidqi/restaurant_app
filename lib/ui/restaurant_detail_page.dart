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

class RestaurantDetailPage extends StatefulWidget {
  static const routeName = '/restaurant_detail';
  final RestaurantInList restaurant;
  const RestaurantDetailPage({super.key, required this.restaurant});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  bool isClicked = false;
  int maxDescLines = 6;
  String descTextButton = 'Click here to read more';
  String reviewTextButton = 'Click here to view more';
  int maxReviewLength = 3;

  late String reviewer;
  late String review;

  TextEditingController _reviewerController = TextEditingController();
  TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _reviewerController = TextEditingController();
    _reviewController = TextEditingController();
  }

  @override
  void dispose() {
    _reviewerController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RestaurantDetailProvider(
          apiService: ApiService(), id: widget.restaurant.id),
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
                                overflow: TextOverflow.fade,
                                maxLines: maxDescLines,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    isClicked = !isClicked;
                                    if (isClicked) {
                                      descTextButton = 'Read less';
                                      maxDescLines = 30;
                                    } else {
                                      descTextButton = 'Click here to read more';
                                      maxDescLines = 6;
                                    }
                                  });
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    descTextButton,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
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
                                shrinkWrap: true,
                                itemCount: maxReviewLength,
                                itemBuilder: (context, index) {
                                  return ReviewCard(
                                      review: result.restaurant.customerReviews[index]);
                                },
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    isClicked = !isClicked;
                                    if (isClicked) {
                                      reviewTextButton = 'View less';
                                      maxReviewLength = result.restaurant.customerReviews.length;
                                    } else {
                                      reviewTextButton = 'Click here to view more';
                                      maxReviewLength = 3;
                                    }
                                  });
                                },
                                child: Text(
                                  reviewTextButton,
                                  style:
                                  Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                              Text(
                                'Ulasanmu',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              ChangeNotifierProvider<ReviewProvider>(
                                create: (_) => ReviewProvider(apiService: ApiService(), id: result.restaurant.id),
                                child: Consumer<ReviewProvider>(
                                  builder: (context, state, _) {
                                    final providerReview = Provider.of<ReviewProvider>(context);
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          TextField(
                                            controller: _reviewerController,
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Ketik namamu di sini'
                                            ),
                                            onChanged: (
                                                String name) => providerReview.updateName(name),
                                          ),
                                          TextField(
                                            controller: _reviewController,
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Ketik ulasanmu di sini'
                                            ),
                                            onChanged: (
                                                String reviewed) => providerReview.updateReviews(reviewed),
                                          ),
                                          ElevatedButton(onPressed: () { providerReview.postReview(result.restaurant.id, providerReview.name, providerReview.review); }, child: Text(
                                              'Tambahkan Ulasan', style: Theme.of(context).textTheme.labelLarge,
                                          ))
                                        ],
                                      ),
                                    );
                                  }
                                ),
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
