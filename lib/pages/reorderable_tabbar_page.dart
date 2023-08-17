import 'package:flutter/material.dart';
import 'package:reorderable_tabbar/reorderable_tabbar.dart';
import 'package:tabs_showcase/data/data.dart';
import 'package:tabs_showcase/widget/tab_filling.dart';

//https://pub.dev/packages/reorderable_tabbar

class ReorderableTabBarPage extends StatefulWidget {
  const ReorderableTabBarPage({Key? key}) : super(key: key);

  @override
  State<ReorderableTabBarPage> createState() => _ReorderableTabBarPageState();
}

class _ReorderableTabBarPageState extends State<ReorderableTabBarPage> {
  PageController pageController = PageController();

  List<String> tabs = List.from(tabTitles);
  List<Icon> views = List.from(tabViews);

  bool isScrollable = false;
  bool tabSizeIsLabel = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("reorderable_tabbar"),
          bottom: ReorderableTabBar(
            buildDefaultDragHandles: false,
            tabs: tabs.map((e) => ReorderableDragStartListener(
              index: tabs.indexOf(e),
              child: TabFilling(title: e),
            )).toList(),
            indicatorSize: tabSizeIsLabel ? TabBarIndicatorSize.label : null,
            isScrollable: isScrollable,
            reorderingTabBackgroundColor: Colors.black45,
            indicatorWeight: 5,
            tabBorderRadius: const BorderRadius.vertical(
              top: Radius.circular(8),
            ),
            onReorder: (oldIndex, newIndex) async {
              String temp = tabs.removeAt(oldIndex);
              Icon tempIcon = views.removeAt(oldIndex);
              tabs.insert(newIndex, temp);
              views.insert(newIndex, tempIcon);
              setState(() {});
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            tabs.add((tabs.length + 1).toString());
            views.add(Icon(Icons.add, size: 60,));
            setState(() {});
          },
        ),
        body: TabBarView(
          children: views,
        ),
      ),
    );
  }
}
