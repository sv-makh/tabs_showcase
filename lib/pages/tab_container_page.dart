import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';
import 'package:tabs_showcase/data/data.dart';
import 'package:tabs_showcase/widget/tab_filling.dart';

//https://pub.dev/packages/tab_container

class TabContainerPage extends StatefulWidget {
  const TabContainerPage({super.key});

  @override
  State<TabContainerPage> createState() => _TabContainerPageState();
}

class _TabContainerPageState extends State<TabContainerPage> {
  late TabContainerController _controller;

  List<String> tabs = List.from(tabTitles);
  List<Icon> views = List.from(tabViews);

  double menuButtonSize = 35;

  @override
  void initState() {
    _controller = TabContainerController(length: tabs.length);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String initialValue = tabs[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('tab_container'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              _addButton(),
              _menuAnchor(),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            child: TabContainer(
              controller: _controller,
              radius: 0,
              color: Colors.blueGrey,
              tabDuration: const Duration(seconds: 0),
              isStringTabs: false,
              tabs: List.generate(
                tabs.length,
                (index) => TabFilling(
                  title: tabs[index],
                  onDelete: () {
                    _deleteTab(tabs[index]);
                  },
                ),
              ),
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
    _controller = TabContainerController(
        length: tabs.length); //TabController(length: tabs.length, vsync: this);
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
          _controller = TabContainerController(length: tabs.length);
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
              _controller.jumpTo(tabs.indexOf(e));
            },
          );
        }).toList(),
      ),
    );
  }
}
