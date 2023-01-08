import 'package:restaurant/data/api/api_restaurant.dart';
import 'package:restaurant/data/model/restaurants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('Cek Api Restaurant', () {
    test('Return List Restaurant', () async {
      final client = MockClient();

      when(client.get(Uri.parse('https://restaurant-api.dicoding.dev/list')))
          .thenAnswer((_) async => http.Response(
          '{"error":false,"message":"success","count":20,"restaurants":[]}',
          200));

      expect(await ApiRestaurant(client).daftarRestaurant(), isA<RestaurantResult>());
    });
  });
}