import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/drink.dart';
import 'package:restaurant_app/data/model/restaurant_detail.dart';
import 'package:restaurant_app/data/model/restaurant_in_list.dart';
import 'package:restaurant_app/provider/favorite_provider.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/review_provider.dart';
import 'package:restaurant_app/widgets/platform_widget.dart';
import 'package:restaurant_app/widgets/review_card.dart';

Widget? _buildMenuTableItem(BuildContext context, Drink menu) {
  return Column(
    children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          menu.name,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
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
    return PlatformWidget(iOSBuilder: _iOSBuild, androidBuilder: _androidBuild);
  }

  Widget _androidBuild(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          RestaurantDetailProvider(apiService: ApiService(), id: restaurant.id),
      child: Consumer<RestaurantDetailProvider>(
        builder: (context, state, _) {
          int descLines = state.maxDescLines;
          if (state.state == ResultState.loading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.grey,
              ),
            );
          } else if (state.state == ResultState.hasData) {
            var result = state.restaurantDetail;
            return Scaffold(
                appBar: AppBar(
                    title: Text(
                      result.restaurant.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    actions: [
                      Consumer<FavoriteProvider>(
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
                                    icon:
                                        const Icon(CupertinoIcons.heart_fill));
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
                    ]),
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
                                maxLines: descLines,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              TextButton(
                                  onPressed: () {
                                    state.updateIsClicked(!state.isClicked);
                                    if (state.isClicked) {
                                      state.updateMaxLines(30);
                                    } else {
                                      state.updateMaxLines(6);
                                    }
                                  },
                                  child: Text(
                                    'Click here to see more or less',
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  )),
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
                              _buildAndroidReviewSection(context, result),
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

  Widget _iOSBuild(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          RestaurantDetailProvider(apiService: ApiService(), id: restaurant.id),
      child: Consumer<RestaurantDetailProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.grey,
              ),
            );
          } else if (state.state == ResultState.hasData) {
            var result = state.restaurantDetail;
            int descLines = state.maxDescLines;
            var provider = Provider.of<FavoriteProvider>(context);
            return Scaffold(
                appBar: AppBar(
                  title: Text(
                    result.restaurant.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  actions: [
                    IconButton(
                        onPressed: () async {
                          if (!provider.isInFavorite) {
                            provider.addFavorite(restaurant);
                            provider.setFavorite(true, restaurant.id);
                          } else {
                            provider.deleteFavorite(restaurant.id);
                            provider.setFavorite(false, restaurant.id);
                          }
                        },
                        icon: Icon(provider.isInFavorite
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart_slash))
                  ],
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
                                maxLines: descLines,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              TextButton(
                                  onPressed: () {
                                    state.updateIsClicked(!state.isClicked);

                                    if (state.isClicked) {
                                      state.updateMaxLines(30);
                                    } else {
                                      state.updateMaxLines(6);
                                    }
                                  },
                                  child: Text(
                                    'Click here to see more or less',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  )),
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
                              _buildIOSReviewSection(context, result),
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

  ChangeNotifierProvider<ReviewProvider> _buildIOSReviewSection(
      BuildContext context, RestaurantDetail result) {
    return ChangeNotifierProvider<ReviewProvider>(
      create: (_) =>
          ReviewProvider(apiService: ApiService(), id: result.restaurant.id),
      child: Consumer<ReviewProvider>(builder: (context, state, _) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CupertinoTextField(
                placeholder: 'Ketik namamu di sini',
                onChanged: (String name) => state.updateName(name),
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                placeholder: 'Ketik ulasanmu di sini',
                onChanged: (String reviewed) => state.updateReviews(reviewed),
              ),
              const SizedBox(height: 8),
              CupertinoButton.filled(
                  onPressed: () {
                    if (state.name == null) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text(
                                'Kolom Nama belum terisi',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'OK',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ))
                              ],
                            );
                          });
                    }
                    if (state.review == null) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text(
                                'Kolom Ulasan belum terisi',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'OK',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ))
                              ],
                            );
                          });
                    } else {
                      state
                          .postReview(
                              result.restaurant.id, state.name, state.review)
                          .whenComplete(() => showDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text(
                                    'Ulasan berhasil ditambahkan',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  content: Text(
                                    'Anda akan kembali ke halaman sebelumnya',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'OK',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ))
                                  ],
                                );
                              }));
                    }
                  },
                  child: Text(
                    'Tambahkan Ulasan',
                    style: Theme.of(context).textTheme.labelLarge,
                  ))
            ],
          ),
        );
      }),
    );
  }

  ChangeNotifierProvider<ReviewProvider> _buildAndroidReviewSection(
      BuildContext context, RestaurantDetail result) {
    return ChangeNotifierProvider<ReviewProvider>(
      create: (_) =>
          ReviewProvider(apiService: ApiService(), id: result.restaurant.id),
      child: Consumer<ReviewProvider>(builder: (context, state, _) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Ketik namamu di sini'),
                onChanged: (String name) => state.updateName(name),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Ketik ulasanmu di sini'),
                onChanged: (String reviewed) => state.updateReviews(reviewed),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                  onPressed: () {
                    if (state.name == null) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'Kolom Nama belum terisi',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'OK',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ))
                              ],
                            );
                          });
                    }
                    if (state.review == null) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'Kolom Ulasan belum terisi',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'OK',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ))
                              ],
                            );
                          });
                    } else {
                      state
                          .postReview(
                              result.restaurant.id, state.name, state.review)
                          .whenComplete(() => showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    'Ulasan berhasil ditambahkan',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  content: Text(
                                    'Anda akan kembali ke halaman sebelumnya',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'OK',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ))
                                  ],
                                );
                              }));
                    }
                  },
                  child: Text(
                    'Tambahkan Ulasan',
                    style: Theme.of(context).textTheme.labelLarge,
                  ))
            ],
          ),
        );
      }),
    );
  }
}
