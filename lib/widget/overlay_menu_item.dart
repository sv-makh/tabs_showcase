import 'package:flutter/material.dart';
import 'package:tabs_showcase/widget/tab_leading.dart';

class OverlayMenuItem extends StatefulWidget {
  double menuWidth;
  String text;
  VoidCallback? onPressed;
  VoidCallback? onPressedClose;
  Color leadingColor;
  bool openTab;
  bool currentTab;
  VoidCallback rebuildOverlay;

  OverlayMenuItem({
    super.key,
    required this.menuWidth,
    required this.text,
    required this.leadingColor,
    this.onPressed,
    this.onPressedClose,
    required this.openTab,
    required this.currentTab,
    required this.rebuildOverlay,
  });

  @override
  State<OverlayMenuItem> createState() => _OverlayMenuItemState();
}

class _OverlayMenuItemState extends State<OverlayMenuItem> {

  bool showTrailing = false;

  @override
  Widget build(BuildContext context) {

    return MenuItemButton(
      leadingIcon: TabLeading(
        color: widget.leadingColor,
      ),
      trailingIcon: (showTrailing || widget.currentTab)
          ? IconButton(
              icon: Icon(Icons.close),
              onPressed: widget.onPressedClose,
            )
          : null,
      onPressed: widget.onPressed,
      onHover: (hover) {
        if (hover) {
          showTrailing = true;
          widget.rebuildOverlay();
        } else {
          showTrailing = false;
          widget.rebuildOverlay();
        }
      },
      child: SizedBox(
        width: widget.menuWidth - 95,
        child: Text(
          widget.text,
          style: TextStyle(fontSize: 12),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
      ),
    );
  }
}