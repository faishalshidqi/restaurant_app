import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/provider/restaurants_provider.dart';

void main() {
  group('API Test', () {
    test('Restaurant List API Response should contain all restaurants from API',
        () async {
      RestaurantsProvider restaurantsProvider =
          RestaurantsProvider(apiService: ApiService());
      int totalRestaurants = 20;
      var response = await restaurantsProvider.apiService.getRestaurants();
      var restaurants = response.restaurants.length;
      expect(restaurants, totalRestaurants);
    });
  });
}
