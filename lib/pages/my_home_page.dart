import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/default');
              },
              child: const Text('default tabs'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/tabbed_view');
              },
              child: const Text('tabbed_view'),
            ),
            TextButton(onPressed: () {
              Navigator.pushNamed(context, '/contained_tab_bar_view_with_custom_page_navigator');
            }, child: const Text('contained_tab_bar_view_with_custom_page_navigator')),
            TextButton(onPressed: () {
              Navigator.pushNamed(context, '/reorderable_tabbar');
            }, child: const Text('reorderable_tabbar')),
            TextButton(onPressed: () {
              Navigator.pushNamed(context, '/extended_tabs');
            }, child: const Text('extended_tabs')),
          ],
        ),
      ),
    );
  }
}
