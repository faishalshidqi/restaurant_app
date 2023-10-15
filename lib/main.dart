import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/ui/home_page.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          style: Theme.of(context).textTheme.titleSmall,
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
            restaurant:
                ModalRoute.of(context)?.settings.arguments as Restaurant)
      },
    );
  }
}
