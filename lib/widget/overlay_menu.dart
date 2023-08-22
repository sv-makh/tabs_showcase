import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';
import 'package:tabs_showcase/widget/overlay_menu_item.dart';
import 'package:tabs_showcase/widget/tab_content.dart';

class OverlayMenu extends StatelessWidget {
  double menuWidth;
  List<TabData> closedTabs;
  TabbedViewController controller;
  void Function(TabData) closeTab;
  VoidCallback closeOverlay;

  OverlayMenu({
    super.key,
    required this.menuWidth,
    required this.closedTabs,
    required this.controller,
    required this.closeTab,
    required this.closeOverlay,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ModalBarrier(
        onDismiss: () { closeOverlay(); },
      ),
      Positioned(
          left: MediaQuery.of(context).size.width - menuWidth - 5,
          top: 100,
          child: Material(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(5),
              width: menuWidth,
              height: MediaQuery.of(context).size.height - 200,
              child: _menu(),
            ),
          )),
    ]);
  }

  Widget _menu() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
                hintText: 'Search tabs', hintStyle: TextStyle(fontSize: 12)),
          ),
          _divider(),
          Text('Open tabs'),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.tabs.length,
            itemBuilder: (BuildContext context, int index) {
              return OverlayMenuItem(
                menuWidth: menuWidth,
                text:
                    (controller.tabs[index].content as TabContent).fullTabTitle,
                onPressed: () {
                  controller.selectedIndex = index;
                  closeOverlay();
                },
                onPressedClose: () {
                  TabData tabToRemove = controller.getTabByIndex(index);
                  controller.removeTab(index);
                  closeTab(tabToRemove);
                },
              );
            },
          ),
          _divider(),
          Text('Recently closed'),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: closedTabs.length,
            itemBuilder: (BuildContext context, int index) {
              return OverlayMenuItem(
                menuWidth: menuWidth,
                text: (closedTabs[index].content as TabContent).fullTabTitle,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const SizedBox(
      height: 10,
    );
  }
}
