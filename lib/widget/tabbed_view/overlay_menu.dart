import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';
import 'package:tabs_showcase/widget/tabbed_view/overlay_menu_item.dart';
import 'package:tabs_showcase/widget/tabbed_view/overlay_text_item.dart';
import 'package:tabs_showcase/widget/tabbed_view/tab_content.dart';

class OverlayMenu extends StatelessWidget {
  double menuWidth;
  List<TabData> closedTabs;
  TabbedViewController controller;
  void Function(TabData) closeTab;
  VoidCallback closeOverlay;
  VoidCallback rebuildOverlay;
  int maxTabs;

  OverlayMenu({
    super.key,
    required this.menuWidth,
    required this.closedTabs,
    required this.controller,
    required this.closeTab,
    required this.closeOverlay,
    required this.rebuildOverlay,
    required this.maxTabs,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ModalBarrier(
          onDismiss: () {
            closeOverlay();
          },
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
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              width: menuWidth,
              height: MediaQuery.of(context).size.height - 200,
              child: _menu(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _menu() {
    int selectedIndex = controller.selectedIndex!;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.search, size: 18),
                hintText: 'Search tabs',
                hintStyle: TextStyle(fontSize: 12),
              ),
            ),
          ),
          const Divider(),
          OverlayTextItem(text: 'OPEN TABS'),
          OverlayMenuItem(
            currentTab: true,
            menuWidth: menuWidth,
            text: (controller.tabs[selectedIndex].content as TabContent)
                .fullTabTitle,
            onPressed: () {
              controller.selectedIndex = selectedIndex;
              closeOverlay();
            },
            onPressedClose: () {
              TabData tabToRemove = controller.getTabByIndex(selectedIndex);
              controller.removeTab(selectedIndex);
              closeTab(tabToRemove);
            },
            leadingColor:
                (controller.tabs[selectedIndex].content as TabContent).color,
            rebuildOverlay: () {
              rebuildOverlay();
            },
            closeOverlay: () {
              closeOverlay();
            },
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.tabs.length,
            itemBuilder: (BuildContext context, int index) {
              return (index == selectedIndex)
                  ? Container()
                  : OverlayMenuItem(
                      currentTab: index == controller.selectedIndex,
                      menuWidth: menuWidth,
                      text: (controller.tabs[index].content as TabContent)
                          .fullTabTitle,
                      onPressed: () {
                        controller.selectedIndex = index;
                        closeOverlay();
                      },
                      onPressedClose: () {
                        TabData tabToRemove = controller.getTabByIndex(index);
                        controller.removeTab(index);
                        closeTab(tabToRemove);
                      },
                      leadingColor:
                          (controller.tabs[index].content as TabContent).color,
                      rebuildOverlay: () {
                        rebuildOverlay();
                      },
                      closeOverlay: () {
                        closeOverlay();
                      },
                    );
            },
          ),
          OverlayTextItem(text: 'RECENTLY CLOSED'),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: closedTabs.length,
            itemBuilder: (BuildContext context, int index) {
              return OverlayMenuItem(
                currentTab: false,
                menuWidth: menuWidth,
                text: (closedTabs[index].content as TabContent).fullTabTitle,
                leadingColor: (closedTabs[index].content as TabContent).color,
                rebuildOverlay: () {
                  rebuildOverlay();
                },
                closeOverlay: () {
                  closeOverlay();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
