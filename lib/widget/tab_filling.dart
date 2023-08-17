import 'package:flutter/material.dart';

class TabFilling extends StatelessWidget {
  String title;

  TabFilling({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: title,
      child: ListTile(
        title: Text(title, overflow: TextOverflow.ellipsis),
        trailing: Icon(Icons.close),
      ),
    );
  }
}