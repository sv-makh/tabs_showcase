import 'package:flutter/material.dart';
import 'package:tabs_showcase/pages/contained_tab_bar_page.dart';
import 'package:tabs_showcase/pages/default_page.dart';
import 'package:tabs_showcase/pages/extended_tabs_page.dart';
import 'package:tabs_showcase/pages/my_home_page.dart';
import 'package:tabs_showcase/pages/reorderable_tabbar_page.dart';
import 'package:tabs_showcase/pages/tab_container_page.dart';
import 'package:tabs_showcase/pages/tabbed_view_page0.dart';
import 'package:tabs_showcase/pages/tabbed_view_page1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: const MyHomePage(),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/default': (context) => const DefaultPage(),
        '/tabbed_view0': (context) => const TabbedViewPage0(),
        '/tabbed_view1': (context) => const TabbedViewPage1(),
        '/contained_tab_bar_view_with_custom_page_navigator': (context) => const ContainedTabBarPage(),
        '/reorderable_tabbar': (context) => const ReorderableTabBarPage(),
        '/extended_tabs': (context) => const ExtendedTabsPage(),
        '/tab_container': (context) => const TabContainerPage(),
      },
    );
  }
}



