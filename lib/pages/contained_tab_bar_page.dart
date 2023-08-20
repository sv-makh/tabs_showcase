import 'package:contained_tab_bar_view_with_custom_page_navigator/contained_tab_bar_view_with_custom_page_navigator.dart';
import 'package:flutter/material.dart';
import 'package:tabs_showcase/widget/tab_filling_sized.dart';

import '../data/data.dart';

//https://pub.dev/packages/contained_tab_bar_view_with_custom_page_navigator
//аналогичен более старому https://pub.dev/packages/contained_tab_bar_view

class ContainedTabBarPage extends StatefulWidget {
  const ContainedTabBarPage({super.key});

  @override
  State<ContainedTabBarPage> createState() => _ContainedTabBarPageState();
}

class _ContainedTabBarPageState extends State<ContainedTabBarPage> {
  List<String> tabs = List.from(tabTitles);
  List<Icon> views = List.from(tabViews);

  double menuButtonSize = 35;

  GlobalKey<ContainedTabBarViewState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double tabTitleWidth = MediaQuery.of(context).size.width / tabs.length - 16;
    double tabTitleHeight = 60;

    //GlobalKey<ContainedTabBarViewState> key = GlobalKey();

    String initialValue = tabTitles[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('contained_tab_bar_view_with_custom_page_navigator'),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Positioned(
                right: 0,
                top: 5,
                child: Row(
                  children: [
                    _addButton(),
                    _menuAnchor(),
                  ],
                ),
              ),
              SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: ContainedTabBarView(
                key: key,
                tabs: tabs
                    .map((e) => TabFillingSized(
                          title: e,
                          width: tabTitleWidth,
                          height: tabTitleHeight,
                          onDelete: () {
                            _deleteTab(e);
                          },
                        ))
                    .toList(),
                tabBarProperties: TabBarProperties(
                  padding: EdgeInsets.only(right: menuButtonSize * 2),
                  width: MediaQuery.of(context).size.width,
                  height: tabTitleHeight,
                  position: TabBarPosition.top,
                ),
                views: views,
                onChange: (index) => print(index),
              ),
            ),]
          ),
        ],
      ),
    );
  }

  void _deleteTab(String tab) {
    int index = tabs.indexOf(tab);
    tabs.removeAt(index);
    views.removeAt(index);
    setState(() {});
  }

  Widget _addButton() {
    return SizedBox(
      width: menuButtonSize,
      height: menuButtonSize,
      child: IconButton(
        onPressed: () {
          tabs.add('${(tabs.length + 1).toString()}th tab');
          views.add(const Icon(
            Icons.add,
            size: 60,
          ));
          //_controller = TabController(length: tabs.length, vsync: this);
          setState(() {});
        },
        icon: Icon(Icons.add),
      ),
    );
  }

  Widget _menuAnchor() {
    return SizedBox(
      width: menuButtonSize,
      height: menuButtonSize,
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
              key.currentState?.animateTo(tabs.indexOf(e));
            },
          );
        }).toList(),
      ),
    );
  }
}
