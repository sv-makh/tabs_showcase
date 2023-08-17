import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:tabs_showcase/data/data.dart';
import 'package:tabs_showcase/widget/tab_filling.dart';

//https://pub.dev/packages/extended_tabs

class ExtendedTabsPage extends StatelessWidget {
  const ExtendedTabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabTitles.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('extended_tabs'),
          bottom: ExtendedTabBar(
            labelColor: Colors.black,
            indicator: const ColorTabIndicator(Colors.blue),
            scrollDirection: Axis.horizontal,
            tabs: List.generate(
              tabTitles.length,
              (index) => ExtendedTab(
                scrollDirection: Axis.horizontal,
                child: TabFilling(
                  title: tabTitles[index],
                ),
              ),
            ),
          ),
        ),
        body: ExtendedTabBarView(
          scrollDirection: Axis.horizontal,
          children: tabViews,
        ),
      ),
    );
  }
}
