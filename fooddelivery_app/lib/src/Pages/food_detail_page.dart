import 'package:flutter/material.dart';
import 'package:fooddelivery_app/colors.dart';
import 'package:fooddelivery_app/src/Scoped_model/main_model.dart';
import 'package:fooddelivery_app/src/Scoped_model/user_scoped_model.dart';
import 'package:fooddelivery_app/src/models/food_model.dart';
import 'package:fooddelivery_app/src/screens/main-screen.dart';
import 'package:fooddelivery_app/src/widgets/button.dart';
import 'package:scoped_model/scoped_model.dart';

class FoodDetailPage extends StatelessWidget {
  var _meduimspace = SizedBox(
    height: 10.0,
  );

  var _smallSpace = SizedBox(
    height: 10.0,
  );

  var _largeSpace = SizedBox(
    height: 50.0,
  );
  final Food food;
  FoodDetailPage({this.food});
  GlobalKey<ScaffoldState> fooddetailScaffoldkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScopedModelDescendant(
          builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          key: fooddetailScaffoldkey,
          appBar: AppBar(
            elevation: 0.0,
            title: Text(
              "Food Details",
              style: TextStyle(fontSize: 16.0, color: Colors.black),
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 200.0,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "assets/images/lunch.jpeg",
                    fit: BoxFit.cover,
                  ),
                ),
                _meduimspace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      food.name,
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                    Text(
                      "\u{20b5} ${food.prices}",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
                _meduimspace,
                Text(
                  "Description :",
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                _smallSpace,
                Text(food.description, textAlign: TextAlign.justify),
                _meduimspace,
                Divider(thickness: 2, color: AppColor.placeholder),
                _meduimspace,
                // Text(
                //   "customize your Order",
                //   style: TextStyle(fontSize: 16.0, color: Colors.black),
                // ),
                // _meduimspace,
                // Container(
                //   height: 50,
                //   width: double.infinity,
                //   padding: EdgeInsets.only(left: 30.0,right: 10.0),
                //   decoration:ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),color:AppColor.placeholder),
                //   child: DropdownButtonHideUnderline(
                //       child: DropdownButton(
                //         hint: Row(children: [
                //           // SizedBox(width: 20.0,),

                //           Text("-Select the type of proportion")
                //         ] ),
                //     value: "default",
                //     onChanged: (_) {},
                //     items: [
                //       DropdownMenuItem(
                //         child: Text("Select the size of proportion -"),
                //         value: "default",
                //       )
                //     ],
                //   )),
                // ),
                // SizedBox(height: 5,),
                // Container(
                //   height: 50,
                //   width: double.infinity,
                //   padding: EdgeInsets.only(left: 30.0,right: 10.0),
                //   decoration:ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),color:AppColor.placeholder),
                //   child: DropdownButtonHideUnderline(
                //       child: DropdownButton(
                //         hint: Row(children: [
                //           // SizedBox(width: 20.0,),

                //           Text("-Select the type of Ingredient")
                //         ] ),
                //     value: "default",
                //     onChanged: (_) {},
                //     items: [
                //       DropdownMenuItem(
                //         child: Text("-Select the  type of ingredient -"),
                //         value: "default",
                //       )
                //     ],
                //     icon: Image.asset("assets/images/noimage.png"),
                //   )),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () async {
                          model.addToCart(food);

                          bool response = await model.fetchFood();
                          
                          if (response == null) {
                            SnackBar snackBar = SnackBar(
                              duration: Duration(seconds: 2),
                              backgroundColor: Theme.of(context).primaryColor,
                              content: Text(
                                "Added to your Orders Successfully",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            );
                            fooddetailScaffoldkey.currentState
                                .showSnackBar(snackBar);
                          }
                        },
                        icon: Icon(Icons.add_circle)),
                    SizedBox(
                      width: 14.0,
                    ),
                    Text(
                      "${model.foodleng}",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(
                      width: 14.0,
                    ),
                    IconButton(
                        onPressed: () {
                          model.removeToCart(food);
                        },
                        icon: Icon(Icons.remove_circle)),
                  ],
                ),
                _largeSpace,
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => MainScreen()));
                  },
                  child: Button(
                    btnText: "Add to cart",
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
