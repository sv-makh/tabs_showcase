import 'package:flutter/material.dart';

class TabLeading extends StatelessWidget {
  double rightPadding;
  Color color;
  TabLeading({super.key, required this.color, this.rightPadding = 4});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: rightPadding),
      child: Icon(Icons.circle, size: 10, color: color,),
    );
  }
}
