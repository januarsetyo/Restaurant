import 'package:restaurant/data/model/restaurants.dart';
import 'package:restaurant/ui/restaurant_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/common/navigation.dart';
import 'package:restaurant/provider/provider_database.dart';

class CardRestaurant extends StatelessWidget {
  final Restaurant restaurant;

  const CardRestaurant({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isFavorited(restaurant.id),
          builder: (context, snapshot) {
            var isFavorited = snapshot.data ?? false;
            return Material(
              child: ListTile(
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                leading: Hero(
                  tag: restaurant.id,
                  child: Image.network(
                    "https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}",
                    width: 100,
                  ),
                ),
                title: Text(restaurant.name),
                subtitle: Text(
                  '${restaurant.city}'
                      '\n'
                      '${restaurant.rating}'
                      .toString(),
                ),
                trailing: isFavorited
                    ? IconButton(
                  icon: const Icon(Icons.favorite),
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () => provider.removeFavorite(restaurant.id),
                )
                    : IconButton(
                  icon: const Icon(Icons.favorite_border),
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () => provider.addFavorite(restaurant),
                ),
                onTap: () =>
                    Navigation.intentWithData(DetailResto.routeName, restaurant.id),
              ),
            );
          },
        );
      },
    );
  }
}
