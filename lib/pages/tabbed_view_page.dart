import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';
import 'package:tabs_showcase/widget/tab_content.dart';

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
      var tabData = TabData(
        text: _calculateTitle(tabTitles[i], tabTitles),
        content: TabContent(content: tabViews[i], fullTabTitle: tabTitles[i]),
      );
      tabs.add(tabData);
    }

    _controller = TabbedViewController(tabs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('tabbed_view'),
      ),
      body: TabbedViewTheme(
        data: TabbedViewThemeData.mobile(),
        child: TabbedView(
          controller: _controller,
          tabsAreaButtonsBuilder: (context, tabsCount) {
            List<TabButton> buttons = [];
            buttons.add(
              TabButton(
                icon: IconProvider.data(Icons.add),
                onPressed: () {
                  List<String> tabsList = _controller.tabs
                      .map((element) =>
                          (element.content as TabContent).fullTabTitle)
                      .toList();
                  String newTabTitle =
                      'new ${tabsList.length.toString()}th tab';
                  tabsList.add(newTabTitle);
                  for (var tab in _controller.tabs) {
                    tab.text = _calculateTitle(
                        (tab.content as TabContent).fullTabTitle, tabsList);
                  }
                  _controller.addTab(
                    TabData(
                      text: _calculateTitle(newTabTitle, tabsList),
                      content: TabContent(
                        content: const Icon(
                          Icons.add,
                          size: 60,
                        ),
                        fullTabTitle: newTabTitle,
                      ),
                    ),
                  );
                  setState(() {});
                },
              ),
            );
            buttons.add(
              TabButton(
                icon: IconProvider.data(Icons.arrow_downward),
                onPressed: () {},
              ),
            );
            return buttons;
          },
          onTabClose: (index, tabData) {
            List<String> tabsList = _controller.tabs
                .map((element) => (element.content as TabContent).fullTabTitle)
                .toList();
            for (var tab in _controller.tabs) {
              tab.text = _calculateTitle(
                  (tab.content as TabContent).fullTabTitle, tabsList);
            }
            setState(() {});
          },
        ),
      ),
    );
  }

  //возвращаем заголовок для вкладки
  String _calculateTitle(String title, List<String> tabs) {
    int median = _calculateMedian(tabs);

    int croppedLength = median;

    if (tabs.length >= 5) {
      int correction = 1 * (tabs.length - 5);
      if ((croppedLength - correction) > 0) {
        croppedLength -= correction;
      }
    }

    if (title.length <= croppedLength) {
      return title;
    } else {
      return '${title.substring(0, croppedLength)}...';
    }
  }

  //вычислениие медианной длины для списка заголовков вкладок
  int _calculateMedian(List<String> tabs) {
    if (tabs.isEmpty) return 0;

    List<String> tabsSorted = List.from(tabs);
    tabsSorted.sort((a, b) => a.length.compareTo(b.length));

    int medianLength = 0;
    int middle = tabsSorted.length ~/ 2;
    if (tabsSorted.length % 2 == 1) {
      medianLength = tabsSorted[middle].length;
    } else {
      medianLength =
          ((tabsSorted[middle - 1].length + tabsSorted[middle].length) / 2.0)
              .round();
    }

    return medianLength;
  }
}
