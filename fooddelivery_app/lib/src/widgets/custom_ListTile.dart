import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String text;
  final IconData icon;
  CustomListTile({this.text, this.icon});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: <Widget>[
          Icon(icon, color: Colors.blue),
          SizedBox(
            width: 15.0,
          ),
          Text("$text", style: TextStyle(fontSize: 16.0))
        ],
      ),
    );
  }
}
