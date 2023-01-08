import 'dart:async';
import 'package:restaurant/provider/provider_searchrestaurant.dart';
import 'package:restaurant/widgets/search_restaurant.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

class SearchRestaurantPage extends StatefulWidget {
  static const routeName = '/search_resto_page';
  static const String searchTitle = 'Search';
  const SearchRestaurantPage({Key? key}) : super(key: key);
  @override
  State<SearchRestaurantPage> createState() => _SearchRestaurantPageState();
}
class _SearchRestaurantPageState extends State<SearchRestaurantPage> {
  late TextEditingController textEditingController;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> subscription;
  Future<void> initConnectivity() async {
    late ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
    textEditingController.dispose();
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();

    final SearchProvider searchProvider =
    Provider.of<SearchProvider>(context, listen: false);

    textEditingController = TextEditingController(text: searchProvider.query);
    subscription = Connectivity().onConnectivityChanged.listen((event) {
      setState(() {
        _connectionStatus = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_connectionStatus != ConnectivityResult.none) {
      return Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.search),
          title: Consumer<SearchProvider>(
            builder: (context, state, _) => TextField(
              controller: textEditingController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search restaurant',
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: const TextStyle(
                color: Colors.black,
              ),
              cursorColor: Colors.black,
              onChanged: (value) {
                Provider.of<SearchProvider>(context, listen: false)
                    .restoSearch(value);
              },
            ),
          ),
        ),
        body: Consumer<SearchProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.loading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(
                      color: Color.fromARGB(255, 56, 82, 155),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Finding Restaurant'),
                  ],
                ),
              );
            } else if (state.state == ResultState.hasData) {
              return ListView.builder(
                itemCount: state.search.founded.toInt(),
                itemBuilder: (context, index) {
                  final restaurantFound = state.search.restaurants[index];
                  return SearchWidget(restaurantFound: restaurantFound);
                },
              );
            } else if (state.state == ResultState.noData) {
              return Center(
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 56, 82, 155),
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text(
                  'Search Restaurant ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 56, 82, 155),
                  ),
                ),
              );
            }
          },
        ),
      );
    } else {
      return const Center(
        child: Text('No Connection!'),
      );
    }
  }
}
