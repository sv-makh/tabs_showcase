import 'package:flutter/material.dart';

class OverlayMenuItem extends StatelessWidget {
  double menuWidth;
  String text;
  VoidCallback? onPressed;
  VoidCallback? onPressedClose;
  
  OverlayMenuItem({super.key, required this.menuWidth, required this.text, this.onPressed, this.onPressedClose});

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      trailingIcon: (onPressedClose != null) ? IconButton(
        icon: Icon(Icons.close),
        onPressed: onPressedClose,
      ) : null,
      onPressed: onPressed,
      child: SizedBox(
        width: menuWidth - 80,
        child: Text(
          text,
          style: TextStyle(fontSize: 12),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
      ),
    );
  }
}
