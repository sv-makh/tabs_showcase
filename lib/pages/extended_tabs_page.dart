import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:tabs_showcase/data/data.dart';
import 'package:tabs_showcase/widget/menu_anchor_button.dart';
import 'package:tabs_showcase/widget/tab_filling.dart';

//https://pub.dev/packages/extended_tabs

class ExtendedTabsPage extends StatefulWidget {
  const ExtendedTabsPage({super.key});

  @override
  State<ExtendedTabsPage> createState() => _ExtendedTabsPageState();
}

class _ExtendedTabsPageState extends State<ExtendedTabsPage>
    with TickerProviderStateMixin {
  late TabController _controller;

  List<String> tabs = List.from(tabTitles);
  List<Icon> views = List.from(tabViews);

  double menuButtonSize = 35;

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
      appBar: AppBar(title: const Text('extended_tabs')),
      body: Column(
        children: [
          Stack(children: [
            Positioned(
              right: 0,
              top: 5,
              child: Row(
                children: [
                  _addButton(),
                  MenuAnchorButton(
                    size: menuButtonSize,
                    tabs: tabs,
                    controller: _controller,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 2 * menuButtonSize),
              child: ExtendedTabBar(
                controller: _controller,
                labelColor: Colors.black,
                indicator: const ColorTabIndicator(Colors.blue),
                scrollDirection: Axis.horizontal,
                tabs: List.generate(
                  tabs.length,
                  (index) => ExtendedTab(
                    scrollDirection: Axis.horizontal,
                    child: TabFilling(
                        title: tabs[index],
                        onDelete: () {
                          _deleteTab(tabs[index]);
                        }),
                  ),
                ),
              ),
            ),
          ]),
          SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            child: ExtendedTabBarView(
              controller: _controller,
              scrollDirection: Axis.horizontal,
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
        icon: const Icon(Icons.add),
      ),
    );
  }
}
