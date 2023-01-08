import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:restaurant/common/styles.dart';
import 'package:restaurant/ui/restaurant_detail_page.dart';
import 'package:restaurant/utils/notification_helper.dart';
import 'package:restaurant/widgets/multi_platform.dart';
import 'package:restaurant/ui/list_restaurant.dart';
import 'package:restaurant/ui/search_restaurant.dart';
import 'package:restaurant/ui/setting_restaurant.dart';
import 'favorite_restaurant.dart';

class HomeRestaurant extends StatefulWidget {
  static const routeName = '/home_resto';
  const HomeRestaurant({Key? key}) : super(key: key);
  @override
  State<HomeRestaurant> createState() => _HomeRestaurantState();
}
class _HomeRestaurantState extends State<HomeRestaurant> {
  int _bottomNavIndex = 0;
  static const String _headlineText = 'Home';

  final NotificationHelper _notificationHelper = NotificationHelper();

  final List<Widget> _listWidget = [
    const ListRestaurant(),
    const SettingsRestaurant(),
    const SearchRestaurantPage(),
    const FavoriteRestoPage(),
  ];

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(
          Platform.isIOS ? CupertinoIcons.square_grid_2x2 : Icons.food_bank),
      label: _headlineText,
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.settings : Icons.settings),
      label: SettingsRestaurant.settingsTitle,
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.info : Icons.search),
      label: SearchRestaurantPage.searchTitle,
    ),
    BottomNavigationBarItem(
      icon: Icon(
          Platform.isIOS ? CupertinoIcons.square_favorites : Icons.favorite),
      label: FavoriteRestoPage.favoriteTitle,
    ),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  Widget _androidStyle(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: secondaryColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: _onBottomNavTapped,
      ),
    );
  }

  Widget _iosStyle(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: _bottomNavBarItems,
        activeColor: secondaryColor,
      ),
      tabBuilder: (context, index) {
        return _listWidget[index];
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(DetailResto.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiPlatform(
      androidStyle: _androidStyle,
      iosStyle: _iosStyle,
    );
  }
}
