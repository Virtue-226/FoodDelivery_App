import 'package:flutter/material.dart';
import 'package:fooddelivery_app/src/Scoped_model/main_model.dart';
import 'package:fooddelivery_app/src/models/user_info_model.dart';
import 'package:fooddelivery_app/src/widgets/custom_ListTile.dart';
import 'package:fooddelivery_app/src/widgets/small_button.dart';
import 'package:scoped_model/scoped_model.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  bool turnOnNotifiaction = false;
  bool turnOnLocation = false;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      UserInfo userInfo = model.getUserDetails(model.authenticateUser.id);
      return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 120.0,
                          width: 120.0,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(60.0),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 3.0,
                                    offset: Offset(5.0, 0.0),
                                    color: Colors.black38),
                              ],
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/picture.png"),
                                  fit: BoxFit.cover)),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${userInfo.username}",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "${userInfo.email}",
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            SmallButton(
                              btn: "Edit",
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      "Account",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30.0),
                    Card(
                        elevation: 3.0,
                        child: Padding(
                          padding: EdgeInsets.all(
                            16.0,
                          ),
                          child: Column(
                            children: <Widget>[
                              CustomListTile(
                                  icon: Icons.location_on, text: "Location"),
                              Divider(height: 10.0, color: Colors.grey),
                              CustomListTile(
                                  icon: Icons.visibility, text: "Password"),
                              Divider(height: 10.0, color: Colors.grey),
                              CustomListTile(
                                  icon: Icons.shopping_cart, text: "Shopping"),
                              Divider(height: 10.0, color: Colors.grey),
                              CustomListTile(
                                  icon: Icons.payment, text: "Payment"),
                              Divider(height: 10.0, color: Colors.grey),
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      "Notification",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30.0),
                    Card(
                        elevation: 3.0,
                        child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("App Notification",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        )),
                                    Switch(
                                      value: turnOnNotifiaction,
                                      onChanged: (bool value) {
                                        setState(() {
                                          turnOnNotifiaction = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Divider(height: 10.0, color: Colors.grey),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Location Tracking",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        )),
                                    Switch(
                                      value: turnOnLocation,
                                      onChanged: (bool value) {
                                        setState(() {
                                          turnOnLocation = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Divider(height: 10.0, color: Colors.grey),
                              ],
                            ))),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      "Other",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30.0),
                    Card(
                        child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Language",
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Divider(height: 10.0, color: Colors.grey),
                                  Text(
                                    "Currency",
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Divider(height: 10.0, color: Colors.grey),
                                ],
                              ),
                            )))
                  ]),
            ),
          ));
    });
  }
}
