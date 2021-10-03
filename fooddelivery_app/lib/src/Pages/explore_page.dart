import 'package:flutter/material.dart';
import 'package:fooddelivery_app/src/Scoped_model/main_model.dart';
import 'package:fooddelivery_app/src/admin/pages/add_food_items.dart';
import 'package:fooddelivery_app/src/models/food_model.dart';
import 'package:fooddelivery_app/src/widgets/Food_Item_Card.dart';
import 'package:fooddelivery_app/src/widgets/small_button.dart';
import 'package:fooddelivery_app/src/Scoped_model/main_model.dart';
import 'package:scoped_model/scoped_model.dart';

class FavoritePage extends StatefulWidget {
  final MainModel model;
  FavoritePage({this.model});
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  GlobalKey<ScaffoldState> exploreScaffoldkey = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.model.fetchFoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: exploreScaffoldkey,
      backgroundColor: Colors.white,
      body: ScopedModelDescendant<MainModel>(
        builder: (BuildContext stx, Widget child, MainModel model) {
          // model.fetchFoods();
          // List<Food> foods = model.foods;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: RefreshIndicator(
              onRefresh: model.fetchFoods,
              child: ListView.builder(
                itemCount: model.foodLength,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      final bool response =
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => AddFoodItem(
                                    food: model.foods[index],
                                  )));
                      if (response) {
                        SnackBar snackBar = SnackBar(
                          duration: Duration(seconds: 2),
                          backgroundColor: Theme.of(context).primaryColor,
                          content: Text(
                            "Food item successfully updated.",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        );
                        exploreScaffoldkey.currentState.showSnackBar(snackBar);
                      }
                    },
                    child: FoodItemCard(
                   
                      model.foods[index].name,
                      model.foods[index].description,
                      model.foods[index].prices.toString(),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
