import 'package:flutter/material.dart';
import 'package:fooddelivery_app/src/Pages/food_detail_page.dart';
import 'package:fooddelivery_app/src/Scoped_model/main_model.dart';
import 'package:fooddelivery_app/src/widgets/food_category.dart';
import 'package:fooddelivery_app/src/widgets/search_field.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/home_top_info.dart';
import '../widgets/bought_foods.dart';

// Data
import '../data/food_data.dart';
//Model
import '../models/food_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<Food> _foods = foods;
  @override
  void initstate() {
    // widget.mainModel.fetchFoods();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        children: <Widget>[
          HomeTopInfo(),
          FoodCategory(),
          SizedBox(height: 20.0),
          SearchField(),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Frequently Bought Foods",
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              GestureDetector(
                  onTap: () {},
                  child: Text("View All",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.orangeAccent))),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          // Column(
          //   children: widget.foodModel.foods.map(_buildFoodItems).toList(),
          // ),
          ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
            return Column(
              children: model.foods.map(_buildFoodItems).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFoodItems(Food food) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => FoodDetailPage(food : food)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        child: BoughtFoods(
            id: food.id,
            name: food.name,
            imagePath: "assets/images/lunch.jpeg",
            category: food.category,
            discount: food.discount,
            prices: food.prices,
            ratings: food.ratings),
      ),
    );
  }
}
