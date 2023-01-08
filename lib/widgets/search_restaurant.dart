import 'package:restaurant/common/styles.dart';
import 'package:restaurant/data/model/restaurants.dart';
import 'package:restaurant/provider/provider_database.dart';
import 'package:restaurant/ui/restaurant_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchWidget extends StatelessWidget {
  final Restaurant restaurantFound;

  const SearchWidget({
    Key? key,
    required this.restaurantFound,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isFavorited(restaurantFound.id),
          builder: (context, snapshot) {
            var isFavorited = snapshot.data ?? false;
            return Material(
              child: ListTile(
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                leading: Hero(
                  tag: restaurantFound.id,
                  child: Image.network(
                    "https://restaurant-api.dicoding.dev/images/small/${restaurantFound.pictureId}",
                    width: 100,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return const CircularProgressIndicator(
                          color: secondaryColor,
                        );
                      }
                    },
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(restaurantFound.name),
                subtitle: Text(
                  '${restaurantFound.city}'
                      '\n'
                      '${restaurantFound.rating}'
                      .toString(),
                ),
                trailing: isFavorited
                    ? IconButton(
                  icon: const Icon(Icons.favorite),
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () => provider.removeFavorite(restaurantFound.id),
                )
                    : IconButton(
                  icon: const Icon(Icons.favorite_border),
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () => provider.addFavorite(restaurantFound),
                ),
                onTap: () => Navigator.pushNamed(context, DetailResto.routeName,
                    arguments: restaurantFound.id),
              ),
            );
          },
        );
      },
    );
  }
}
