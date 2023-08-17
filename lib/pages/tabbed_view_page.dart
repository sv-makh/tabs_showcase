import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

import '../data/data.dart';

//https://pub.dev/packages/tabbed_view

class TabbedViewPage extends StatefulWidget {
  const TabbedViewPage({super.key});

  @override
  State<TabbedViewPage> createState() => _TabbedViewPageState();
}

class _TabbedViewPageState extends State<TabbedViewPage> {
  late TabbedViewController _controller;

  @override
  void initState() {
    super.initState();

    List<TabData> tabs = [];

    for (int i = 0; i < tabTitles.length; i++) {
      tabs.add(TabData(
        text: tabTitles[i],
        content: Center(child: tabViews[i]),
      ));
    }

    _controller = TabbedViewController(tabs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('tabbed_view'),),
      body: TabbedViewTheme(
          data: TabbedViewThemeData.mobile(),
          child: TabbedView(controller: _controller),
      ),
    );
  }
}
