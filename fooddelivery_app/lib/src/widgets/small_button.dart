import "package:flutter/material.dart";

class SmallButton extends StatelessWidget {
  final String btn;
  SmallButton({this.btn});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.0,
      width: 60.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Center(
          child: Text(
        "$btn",
        style: TextStyle(color: Colors.blue, fontSize: 12.0, fontWeight: FontWeight.bold ,),
      )),
    );
  }
}
