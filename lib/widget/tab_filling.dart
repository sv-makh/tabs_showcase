import 'package:flutter/material.dart';

class TabFilling extends StatelessWidget {
  String title;
  VoidCallback? onDelete;

  TabFilling({super.key, required this.title, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: title,
      child: ListTile(
        title: Text(title, overflow: TextOverflow.ellipsis),
        trailing: IconButton(onPressed: onDelete, icon: Icon(Icons.sunny),),// Icon(Icons.close),
      ),
    );
  }
}