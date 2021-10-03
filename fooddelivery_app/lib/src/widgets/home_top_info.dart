import 'package:flutter/material.dart';
import 'package:fooddelivery_app/src/Scoped_model/main_model.dart';
import 'package:fooddelivery_app/src/models/user_info_model.dart';
import 'package:scoped_model/scoped_model.dart';
import '../pages/sign_Up_page.dart';

class HomeTopInfo extends StatelessWidget {
  final textStyle = TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      // UserInfo userInfo;
       UserInfo userInfo = model.getUserDetails(model.authenticateUser.id);
      return Container(
        margin: EdgeInsets.only(bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Welcome ${userInfo.username}!"),
                Text(
                  "What would",
                  style: textStyle,
                ),
                Text(
                  "you like to eat?",
                  style: textStyle,
                )
              ],
            ),
          ],
        ),
      );
    });
  }
}
