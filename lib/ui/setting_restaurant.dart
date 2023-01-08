import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:restaurant/widgets/multi_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../provider/provider_preferences.dart';
import '../provider/provider_schedulling.dart';
import '../widgets/teks.dart';

class SettingsRestaurant extends StatelessWidget {
  static const String settingsTitle = 'Settings';

  const SettingsRestaurant({Key? key}) : super(key: key);

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(settingsTitle),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(settingsTitle),
      ),
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, provider, child) {
        return ListView(
          children: [
            Material(
              child: ListTile(
                title: const Text('Mode Hemat'),
                trailing: Switch.adaptive(
                  value: false,
                  onChanged: (value) {
                    defaultTargetPlatform == TargetPlatform.iOS
                        ? showCupertinoDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: const Text('Coming Soon!!'),
                          content: const Text(
                              'Fitur sedang proses'),
                          actions: [
                            CupertinoDialogAction(
                              child: const Text('baik'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    )
                        : showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Coming Soon!!'),
                          content: const Text(
                              'Fitur sedang proses'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('baik'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Material(
              child: ListTile(
                title: const Text('Dark Mode'),
                trailing: Switch.adaptive(
                  value: provider.isDarkTheme,
                  onChanged: (value) {
                    provider.enableDarkTheme(value);
                  },
                ),
              ),
            ),
            Material(
              child: ListTile(
                title: const Text('Scheduling Restaurant'),
                trailing: Consumer<SchedulingProvider>(
                  builder: (context, scheduled, _) {
                    return Switch.adaptive(
                      value: provider.isDailyRestaurantActive,
                      onChanged: (value) async {
                        if (Platform.isIOS) {
                          teksDialog(context);
                        } else {
                          scheduled.scheduledRestaurant(value);
                          provider.enableDailyRestaurant(value);
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
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
