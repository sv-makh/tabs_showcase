import 'package:flutter/material.dart';
import 'package:reorderable_tabbar/reorderable_tabbar.dart';
import 'package:tabs_showcase/data/data.dart';
import 'package:tabs_showcase/widget/tab_filling.dart';

import '../widget/tab_filling_sized.dart';

//https://pub.dev/packages/reorderable_tabbar

class ReorderableTabBarPage extends StatefulWidget {
  const ReorderableTabBarPage({Key? key}) : super(key: key);

  @override
  State<ReorderableTabBarPage> createState() => _ReorderableTabBarPageState();
}

class _ReorderableTabBarPageState extends State<ReorderableTabBarPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _controller;

  List<String> tabs = List.from(tabTitles);
  List<Icon> views = List.from(tabViews);

  bool isScrollable = false;
  bool tabSizeIsLabel = false;

  String initialValue = tabTitles[0];

  double menuButtonSize = 35;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("reorderable_tabbar"),
      ),
      body: Column(
        children: [
          Stack(children: [
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
            ReorderableTabBar(
              controller: _controller,
              buildDefaultDragHandles: false,
              tabs: tabs
                  .map((e) => ReorderableDragStartListener(
                        index: tabs.indexOf(e),
                        child: TabFillingSized(
                          width:
                              MediaQuery.of(context).size.width / tabs.length,
                          height: menuButtonSize,
                          title: e,
                          onDelete: () {
                            _deleteTab(e);
                          },
                        ),
                      ))
                  .toList(),
              padding: EdgeInsets.only(right: 2 * menuButtonSize),
              labelPadding: EdgeInsets.all(8),
              indicatorSize: tabSizeIsLabel ? TabBarIndicatorSize.label : null,
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
          ]),
          SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            child: TabBarView(
              controller: _controller,
              children: views.toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteTab(String tab) {
    int index = tabs.indexOf(tab);
    tabs.removeAt(index);
    views.removeAt(index);
    _controller = TabController(length: tabs.length, vsync: this);
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
          _controller = TabController(length: tabs.length, vsync: this);
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
              _controller.animateTo(tabs.indexOf(e));
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _menuPopup() {
    return SizedBox(
      width: menuButtonSize,
      height: menuButtonSize,
      child: PopupMenuButton(
        tooltip: 'All tabs',
        itemBuilder: (context) => tabs.map((e) {
          return PopupMenuItem(
            value: e,
            child: Text(
              e,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onSelected: (value) {
          _controller.animateTo(tabs.indexOf(value));
        },
      ),
    );
  }
}
