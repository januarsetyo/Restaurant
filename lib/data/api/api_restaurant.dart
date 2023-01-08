import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:restaurant/data/model/restaurants.dart';

class ApiRestaurant {
  final Client client;
  ApiRestaurant(this.client);

  Future<RestaurantResult> daftarRestaurant() async {
    final response =
    await client.get(Uri.parse('https://restaurant-api.dicoding.dev/list'));
    if (response.statusCode == 200) {
      return RestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal Load API');
    }
  }

  Future<DetailRestaurant> detailMenu(String id) async {
    final response = await client
        .get(Uri.parse('https://restaurant-api.dicoding.dev/detail/$id'));
    if (response.statusCode == 200) {
      return DetailRestaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal Load API Detail');
    }
  }

  Future<SearchRestaurant> searchRestaurant(query) async {
    final response = await client
        .get(Uri.parse('https://restaurant-api.dicoding.dev/search?q=$query'));

    if (response.statusCode == 200) {
      return SearchRestaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal load API Search');
    }
  }
}
