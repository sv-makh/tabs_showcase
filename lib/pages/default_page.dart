import 'package:flutter/material.dart';
import 'package:tabs_showcase/widget/menu_anchor_button.dart';

import '../data/data.dart';
import '../widget/tab_filling.dart';

class DefaultPage extends StatefulWidget {
  const DefaultPage({super.key});

  @override
  State<DefaultPage> createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage>
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
      appBar: AppBar(
        title: const Text('default'),
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
              child: TabBar(
                controller: _controller,
                tabs: List.generate(
                  tabs.length,
                  (index) => Tab(
                    child: TabFilling(
                      title: tabs[index],
                      onDelete: () {
                        _deleteTab(tabs[index]);
                      },
                    ),
                  ),
                ),
              ),
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
        icon: const Icon(Icons.add),
      ),
    );
  }
}
