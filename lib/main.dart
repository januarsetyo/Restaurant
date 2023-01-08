import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:restaurant/common/navigation.dart';
import 'package:restaurant/data/api/api_restaurant.dart';
import 'package:restaurant/data/database/database_helper.dart';
import 'package:restaurant/provider/provider_database.dart';
import 'package:restaurant/provider/provider_preferences.dart';
import 'package:restaurant/provider/provider_schedulling.dart';
import 'package:restaurant/ui/search_restaurant.dart';
import 'package:restaurant/utils/background_service.dart';
import 'package:restaurant/utils/notification_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/ui/restaurant_detail_page.dart';
import 'package:restaurant/ui/home_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/preferences/preferences_helper.dart';
import 'provider/provider_restaurant.dart';
import 'provider/provider_searchrestaurant.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();
  service.initializeIsolate();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<RestaurantProvider>(
            create: (_) => RestaurantProvider(
              apiService: ApiRestaurant(Client()),
            ),
          ),
          ChangeNotifierProvider<SearchProvider>(
            create: (_) => SearchProvider(
              apiService: ApiRestaurant(Client()),
            ),
          ),
          ChangeNotifierProvider<SchedulingProvider>(
            create: (_) => SchedulingProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => PreferencesProvider(
              preferencesHelper: PreferencesHelper(
                sharedPreferences: SharedPreferences.getInstance(),
              ),
            ),
          ),
          ChangeNotifierProvider<DatabaseProvider>(
            create: (_) => DatabaseProvider(
              databaseHelper: DatabaseHelper(),
            ),
          ),
        ],
        child: Consumer<PreferencesProvider>(
          builder: (context, provider, child) {
            return MaterialApp(
              title: 'My Restaurant',
              theme: provider.themeData,
              builder: (context, child) {
                return CupertinoTheme(
                  data: CupertinoThemeData(
                    brightness: provider.isDarkTheme
                        ? Brightness.dark : Brightness.light,
                  ),
                  child: Material(
                    child: child,
                  ),
                );
              },
              navigatorKey: navigatorKey,
              initialRoute: HomeRestaurant.routeName,
              routes: {
                HomeRestaurant.routeName: (context) => const HomeRestaurant(),
                DetailResto.routeName: (context) => DetailResto(
                  id: ModalRoute.of(context)?.settings.arguments as String,
                ),
                SearchRestaurantPage.routeName: (context) => const SearchRestaurantPage(),
              },
            );
          },
        ));
  }
}
