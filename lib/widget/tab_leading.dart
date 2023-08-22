import 'package:flutter/material.dart';

class TabLeading extends StatelessWidget {
  Color color;
  TabLeading({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 4),
      child: Icon(Icons.circle, size: 6, color: color,),
    );
  }
}
