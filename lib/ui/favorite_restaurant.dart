import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/provider_database.dart';
import 'package:restaurant/utils/result.dart';
import 'package:restaurant/widgets/card_restaurant.dart';
import 'package:restaurant/widgets/multi_platform.dart';


class FavoriteRestoPage extends StatelessWidget {
  static const String favoriteTitle = 'Favorite';

  const FavoriteRestoPage({Key? key}) : super(key: key);

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(favoriteTitle),
      ),
      body: _buildList(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(favoriteTitle),
      ),
      child: _buildList(),
    );
  }

  Widget _buildList() {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        if (provider.state == ResultState.hasData) {
          return ListView.builder(
            itemCount: provider.favorite.length,
            itemBuilder: (context, index) {
              return CardRestaurant(restaurant: provider.favorite[index]);
            },
          );
        } else {
          return Center(
            child: Material(
              child: Text(
                provider.message,
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiPlatform(
      androidStyle: _buildAndroid,
      iosStyle: _buildIos,
    );
  }
}
