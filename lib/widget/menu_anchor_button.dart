import 'package:flutter/material.dart';

class MenuAnchorButton extends StatelessWidget {
  double size;
  List<String> tabs;
  TabController controller;

  MenuAnchorButton({super.key, required this.size, required this.tabs, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: MenuAnchor(
        builder: (BuildContext context, MenuController menuController,
            Widget? child) {
          return IconButton(
            onPressed: () {
              if (menuController.isOpen) {
                menuController.close();
              } else {
                menuController.open();
              }
            },
            icon: const Icon(Icons.more_vert),
            tooltip: 'All tabs',
          );
        },
        menuChildren: tabs.map((e) {
          return MenuItemButton(
            child: SizedBox(
              width: 300,
              child: Text(
                e,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            onPressed: () {
              controller.animateTo(tabs.indexOf(e));
            },
          );
        }).toList(),
      ),
    );
  }
}
