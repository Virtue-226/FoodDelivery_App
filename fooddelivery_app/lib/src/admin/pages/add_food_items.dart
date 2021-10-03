import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_app/src/Scoped_model/main_model.dart';
import 'package:fooddelivery_app/src/models/category_model.dart';
import 'package:fooddelivery_app/src/models/food_model.dart';
import 'package:fooddelivery_app/src/widgets/button.dart';
import 'package:fooddelivery_app/src/widgets/showLoaing_indicator.dart';
import 'package:fooddelivery_app/src/widgets/small_button.dart';
import 'package:scoped_model/scoped_model.dart';

class AddFoodItem extends StatefulWidget {
  final Food food;
  AddFoodItem({this.food});
  @override
  _AddFoodItemState createState() => _AddFoodItemState();
}

class _AddFoodItemState extends State<AddFoodItem> {
  String title;
  String category;
  String description;
  String price;
  String discount;
  // bool indexes = false;

  GlobalKey<FormState> _foodItemFormKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          Navigator.of(context).pop(false);
          return Future.value(false);
        },
        child: ScopedModelDescendant(
          builder: (BuildContext context, Widget child, MainModel model) {
            return Scaffold(
                key: _scaffoldStateKey,
                appBar: AppBar(
                  elevation: 0.0,
                  backgroundColor: Colors.blue,
                  title: Text(
                    widget.food != null ? "Updating Food" : "Adding Food",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  centerTitle: true,
                  leading: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      }),
                ),
                // resizeToAvoidBottomInset: false,
                body: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    // width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height,
                    child: Form(
                      key: _foodItemFormKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 13.0),
                            width: MediaQuery.of(context).size.width,
                            height: 130.0,
                            decoration: BoxDecoration(
                              // color: Colors.red,
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                  image: AssetImage("assets/images/lunch.jpeg"),
                                  fit: BoxFit.cover),
                            ),
                            // child: FutureBuilder(
                            //   future: _getImage(BuildContext, 'beer'),
                            //   builder: (context, snapshot) {
                            //     if (snapshot.connectionState ==
                            //         ConnectionState.done) {
                            //       return Container(
                            //         width:
                            //             MediaQuery.of(context).size.width / 1.2,
                            //         height:
                            //             MediaQuery.of(context).size.width / 1.2,
                            //         child: snapshot.data,
                            //       );
                            //     }
                            //     if (snapshot.connectionState ==
                            //         ConnectionState.waiting) {
                            //       return Container(
                            //         width:
                            //             MediaQuery.of(context).size.width / 1.2,
                            //         height:
                            //             MediaQuery.of(context).size.width / 1.2,
                            //         child: CircularProgressIndicator(),
                            //       );
                            //     }
                            //     return Container();
                            //   },
                            // ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // model.chooseImage();
                                  // Navigator.of(context).pop();
                                },
                                child: SmallButton(
                                  btn: "Edit",
                                ),
                              ),
                            ],
                          ),
                          _buildTextFormField("Food Title"),
                          _buildTextFormField("Category"),
                          _buildTextFormField("Description", maxline: 5),
                          _buildTextFormField("Price"),
                          _buildTextFormField("Discount"),
                          SizedBox(height: 70.0),
                          ScopedModelDescendant<MainModel>(
                            builder: (BuildContext context, Widget child,
                                MainModel model) {
                              return GestureDetector(
                                onTap: () {
                                  onSubmit(model.addFood, model.updateFood);
                                  if (model.isLoading) {
                                    //show progress indicator
                                    // model.updateFood
                                    showLoadingIndicator(
                                        context,
                                        widget.food != null
                                            ? "Updating Food Item"
                                            : "Adding Food Item");
                                  }
                                },
                                child: Button(
                                    btnText: widget.food != null
                                        ? "Update Food Item"
                                        : "Add Food Item"),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
          },
        ),
      ),
    );
  }

  // Future<Widget> _getImage(BuildContext, String imageName) async {
  //   Image image;
  //   await firestorageServices.loadImage(context, imageName).then((value) {
  //     image = Image.network(value.toString(), fit: BoxFit.scaleDown);
  //   });
  //   return image;
  // }

  void onSubmit(Function addFood, Function updateFood) async {
    if (_foodItemFormKey.currentState.validate()) {
      _foodItemFormKey.currentState.save();

      if (widget.food != null) {
        //i want to update my food items
        Map<String, dynamic> updatedFoodItem = {
          "title": title,
          "category": category,
          "description": description,
          "price": double.parse(price),
          "discount": discount != null ? double.parse(discount) : 0.0,
        };
        final bool response = await updateFood(updatedFoodItem, widget.food.id);
        if (response) {
          Navigator.of(context).pop(); //To remove the alert dialog
          Navigator.of(context).pop(response); //To take us to the explore page

        } else if (!response) {
          Navigator.of(context).pop();
          SnackBar snackBar = SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
            content: Text(
              "Failed to update food item.",
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          );
          _scaffoldStateKey.currentState.showSnackBar(snackBar);
        }
      } else if (widget.food == null) {
        //add Food Item
        final Food food = Food(
          name: title,
          category: category,
          description: description,
          prices: double.parse(price),
          discount: double.parse(discount),
        );
        bool value = await addFood(food);
        if (value) {
          Navigator.of(context).pop();
          SnackBar snackBar = SnackBar(
            content: Text("Food item successfully added"),
          );
          _scaffoldStateKey.currentState.showSnackBar(snackBar);
        } else if (!value) {
          Navigator.of(context).pop();
          SnackBar snackBar = SnackBar(
            content: Text("Failed to add food item"),
          );
          _scaffoldStateKey.currentState.showSnackBar(snackBar);
        }
      }
    }
  }

  Widget _buildTextFormField(String hint, {int maxline: 1}) {
    return TextFormField(
      initialValue: widget.food != null && hint == "Food Title"
          ? widget.food.name
          : widget.food != null && hint == "Description"
              ? widget.food.description
              : widget.food != null && hint == "Category"
                  ? widget.food.category
                  : widget.food != null && hint == "Price"
                      ? widget.food.prices.toString()
                      : widget.food != null && hint == "Discount"
                          ? widget.food.discount.toString()
                          : "",
      decoration: InputDecoration(
        hintText: "$hint",
      ),
      maxLines: maxline,
      keyboardType: hint == "Price" || hint == "Discount"
          ? TextInputType.number
          : TextInputType.text,
      validator: (String value) {
        // var errorMsg;
        if (value.isEmpty && hint == "Food Title") {
          return "The food title is required";
        }
        if (value.isEmpty && hint == "Description") {
          return "The description is required";
        }
        if (value.isEmpty && hint == "Category") {
          return "The category is required";
        }
        if (value.isEmpty && hint == "Price") {
          return "The price is required";
        }
      },
      onSaved: (String value) {
        if (hint == "Food Title") {
          title = value;
        }
        if (hint == "Category") {
          category = value;
        }
        if (hint == "Description") {
          description = value;
        }
        if (hint == "Price") {
          price = value;
        }
        if (hint == "Discount") {
          discount = value;
        }
      },
    );
  }
}

// class firestorageServices extends ChangeNotifier {
//   firestorageServices();
//   static Future<dynamic> loadImage(BuildContext context, String Images) async {
//     return await FirebaseStorage.instance.ref().child(Images).getDownloadURL();
//   }
// }
