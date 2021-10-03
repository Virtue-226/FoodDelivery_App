import 'package:flutter/material.dart';
import 'package:fooddelivery_app/src/Pages/landing_page.dart';
import 'package:fooddelivery_app/src/Pages/sign_in_page.dart';
import 'package:fooddelivery_app/src/admin/pages/add_food_items.dart';
// import 'package:fooddelivery_app/src/Scoped_model/food_model.dart';
import 'package:fooddelivery_app/src/Scoped_model/main_model.dart';
import 'package:fooddelivery_app/src/homescreen.dart';
import 'package:fooddelivery_app/src/screens/OTP_screen.dart';
import 'screens/main-screen.dart';
import 'package:scoped_model/scoped_model.dart';

class App extends StatelessWidget {
  final MainModel mainModel = MainModel();
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: mainModel,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Food Delivery App",
        theme: ThemeData(primaryColor: Colors.blueAccent),
        // home: MainScreen(model: mainModel),
        //  home: AddFoodItem(),
        routes: {
          "/": (BuildContext context) => LandingScreen(),
          "/sign-in": (BuildContext context) =>SignInPage(),
          "/main-screen": (BuildContext context) => MainScreen(model:mainModel),
          "/OTP": (BuildContext context)=> OTP(),

        },
      ),
    );
  }
}
