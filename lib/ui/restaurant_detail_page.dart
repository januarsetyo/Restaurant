import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/common/styles.dart';
import 'package:restaurant/provider/provider_detailrestaurant.dart';
import 'package:restaurant/data/api/api_restaurant.dart';

class DetailResto extends StatelessWidget {
  static const routeName = '/detail_resto';

  final String id;

  const DetailResto({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailRestaurantsProvider>(
      create: (_) => DetailRestaurantsProvider(apiService: ApiRestaurant(Client()), id: id),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Restaurants'),
        ),
        body: SafeArea(
          child: Consumer<DetailRestaurantsProvider>(
            builder: (context, state, _) {
              if (state.state == ResultState.loading) {
                return const Center(
                    child: CircularProgressIndicator(
                      color: secondaryColor,
                    ));
              } else if (state.state == ResultState.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.network(
                          "https://restaurant-api.dicoding.dev/images/large/${state.result.restaurant.pictureId}"),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.result.restaurant.name,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            const Divider(
                              color: secondaryColor,
                            ),
                            Text(
                              state.result.restaurant.description,
                              style: Theme.of(context).textTheme.bodyText2, maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Divider(
                              color: secondaryColor,
                            ),
                            Text("Kategori : ",
                                style: Theme.of(context).textTheme.headline5),

                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                              state.result.restaurant.categories.length,
                              itemBuilder: (context, index) {
                                return Text(state
                                    .result.restaurant.categories[index].name);
                              },
                            ),

                            const Divider(
                              color: secondaryColor,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    const Icon(Icons.location_on),
                                    Text(
                                      state.result.restaurant.city,
                                      style:
                                      Theme.of(context).textTheme.caption,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Icon(Icons.star),
                                    Text(
                                      state.result.restaurant.rating.toString(),
                                      style:
                                      Theme.of(context).textTheme.caption,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const Divider(
                              color: secondaryColor,
                            ),
                            const Text("Menu Makanan : " ,
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const Divider(
                              color: secondaryColor,
                            ),
                            const SizedBox(height: 10),

                            Container(
                              padding: const EdgeInsets.only(left: 9,right: 9,bottom: 9),
                              height: 50,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: state.result.restaurant.menus.foods.length,
                                  itemBuilder: (BuildContext context,int index){
                                    return Card(
                                      child: Center(
                                        child: Text(state.result.restaurant.menus.foods[index].name),
                                      ),
                                    );
                                  }
                              ),
                            ),
                            const Divider(
                              color: secondaryColor,
                            ),
                            const Text("Menu Minuman : " ,
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Container(
                              padding: const EdgeInsets.only(left: 9,right: 9,bottom: 9),
                              height: 50,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: state.result.restaurant.menus.drinks.length,
                                  itemBuilder: (BuildContext context,int index){
                                    return Card(
                                      child: Center(
                                        child: Text(state.result.restaurant.menus.drinks[index].name),
                                      ),
                                    );
                                  }
                              ),
                            ),
                            const Divider(
                              color: secondaryColor,
                            ),
                            Text("Review Customer: ",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const Divider(
                              color: secondaryColor,
                            ),
                            GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20),
                                itemCount: state
                                    .result.restaurant.customerReviews.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: darkPrimaryColor,
                                            blurRadius: 0.5,
                                            spreadRadius: 0.1,
                                            offset: Offset(
                                              1.0,
                                              1.0,
                                            ),
                                          )
                                        ]),
                                    child: Text(
                                      "${state.result.restaurant
                                          .customerReviews[index].date}\n${state.result.restaurant
                                              .customerReviews[index].name}\n${state.result.restaurant
                                              .customerReviews[index].review}",
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }),
                        ],
                      ),
                      ),
                    ],
                  ),
                );
              } else if (state.state == ResultState.noData ||
                  state.state == ResultState.error) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(height: 8),
                      Text(state.message),
                      const SizedBox(height: 8),
                      const Center(child: Text('Data Tidak Dapat Ditampilkan')),
                    ],
                  ),
                );
              } else {
                return const Center(
                    child: Text('Anda belum terkoneksi ke intrernet'));
              }
            },
          ),
        ),
      ),
    );
  }
}


