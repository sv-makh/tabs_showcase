import 'package:flutter/material.dart';
import 'package:tabs_showcase/widget/tabbed_view/tab_leading.dart';

class OverlayMenuItem extends StatefulWidget {
  double menuWidth;
  String text;
  VoidCallback? onPressed;
  VoidCallback? onPressedClose;
  Color leadingColor;
  bool currentTab;
  VoidCallback rebuildOverlay;
  VoidCallback closeOverlay;

  OverlayMenuItem({
    super.key,
    required this.menuWidth,
    required this.text,
    required this.leadingColor,
    this.onPressed,
    this.onPressedClose,
    required this.currentTab,
    required this.rebuildOverlay,
    required this.closeOverlay,
  });

  @override
  State<OverlayMenuItem> createState() => _OverlayMenuItemState();
}

class _OverlayMenuItemState extends State<OverlayMenuItem> {
  bool showTrailing = false;

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      leadingIcon: TabLeading(color: widget.leadingColor),
      trailingIcon: (showTrailing || widget.currentTab)
          ? IconButton(
              icon: Icon(
                Icons.close,
                size: 14,
              ),
              onPressed: () {
                if (widget.onPressedClose != null) {
                  widget.onPressedClose!();
                  widget.closeOverlay();
                }
              },
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
