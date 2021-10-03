import 'package:flutter/material.dart';
import 'package:fooddelivery_app/src/Pages/food_detail_page.dart';
import 'package:fooddelivery_app/src/widgets/food_category.dart';
import 'package:fooddelivery_app/src/widgets/search_field.dart';
import 'widgets/home_top_info.dart';
import 'widgets/bought_foods.dart';

// Data
import 'data/food_data.dart';
//Model
import 'models/food_model.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Food> _foods = foods;

  Widget _buildFoodItems(Food food) {
  return GestureDetector(
    onTap: (){
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=> FoodDetailPage()));
    },
      child: Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: BoughtFoods(
        id: food.id,
        name: food.name,
        imagePath: food.imagePath.toString(),
        category: food.category,
        discount: food.discount,
        prices: food.prices,
        ratings: food.ratings
      ),
   
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
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
          Column(
            children: _foods.map(_buildFoodItems).toList(),
          ),
        ],
      ),
    );
  }
}


