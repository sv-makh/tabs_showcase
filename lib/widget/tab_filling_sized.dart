import 'package:flutter/material.dart';

class TabFillingSized extends StatelessWidget {
  String title;
  VoidCallback? onDelete;
  double width;
  double height;

  TabFillingSized({
    super.key,
    required this.title,
    required this.width,
    required this.height,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: title,
      child: SizedBox(
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(child: Text(title, overflow: TextOverflow.ellipsis)),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
    );
  }
}
