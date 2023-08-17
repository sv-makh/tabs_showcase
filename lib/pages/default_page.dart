import 'package:flutter/material.dart';

import '../data/data.dart';
import '../widget/tab_filling.dart';

class DefaultPage extends StatelessWidget {
  const DefaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabTitles.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('default'),
          bottom: TabBar(
            tabs: List.generate(
              tabTitles.length,
              (index) => Tab(
                child: TabFilling(
                  title: tabTitles[index],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: tabViews,
        ),
      ),
    );
  }
}

