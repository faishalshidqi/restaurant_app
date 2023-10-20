import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_in_list.dart';
import 'package:restaurant_app/provider/restaurants_provider.dart';
import 'package:restaurant_app/ui/home_page.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';
import 'package:restaurant_app/ui/search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RestaurantsProvider(apiService: ApiService()),
      child: MaterialApp(
        title: 'Restaurant Catalog',
        theme: ThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: primaryColor,
              onPrimary: Colors.black,
              secondary: secondaryColor),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          textTheme: restaurantTextTheme,
          appBarTheme: const AppBarTheme(elevation: 5),
        ),
        home: EasySplashScreen(
          logo: Image.network(
              'https://cdn0.iconfinder.com/data/icons/school-73/128/lunch_dining_room_kitchen_restaurant_food_cutleryschool-512.png'),
          title: Text(
            'Restaurant Catalog',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          backgroundColor: secondaryColor50,
          showLoader: true,
          loadingText: const Text('Loading'),
          navigator: const HomePage(),
          durationInSeconds: 5,
        ),
        initialRoute: '/',
        routes: {
          HomePage.routeName: (context) => const HomePage(),
          RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
              restaurant: ModalRoute.of(context)?.settings.arguments
                  as RestaurantInList),
          SearchPage.routeName: (context) => const SearchPage()
        },
      ),
    );
  }
}
