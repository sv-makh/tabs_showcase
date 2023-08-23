import 'package:flutter/material.dart';

class OverlayTextItem extends StatelessWidget {
  String text;

  OverlayTextItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
    );
  }
}
