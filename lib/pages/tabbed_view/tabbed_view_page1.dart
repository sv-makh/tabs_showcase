import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';
import 'package:tabs_showcase/widget/tabbed_view/overlay_menu.dart';
import 'package:tabs_showcase/widget/tabbed_view/tab_content.dart';
import 'package:tabs_showcase/widget/tabbed_view/tab_tooltip_leading.dart';

import '../../data/data.dart';
import '../../data/tabbed_view/tabbed_theme_data.dart';

//https://pub.dev/packages/tabbed_view

class TabbedViewPage1 extends StatefulWidget {
  const TabbedViewPage1({super.key});

  @override
  State<TabbedViewPage1> createState() => _TabbedViewPage1State();
}

class _TabbedViewPage1State extends State<TabbedViewPage1> {
  late TabbedViewController _controller;

  List<TabData> _closedTabs = [];

  late OverlayEntry? _overlayEntry;
  OverlayState? overlayState;
  double _overlayMenuWidth = 300;

  @override
  void initState() {
    super.initState();

    List<TabData> tabs = [];

    for (int i = 0; i < tabTitles.length; i++) {
      Color color = Colors.primaries[i % Colors.primaries.length];
      var tabData = TabData(
        text: _calculateTitle(tabTitles[i], tabTitles),
        leading: (context, status) => TabTooltipLeading(
          tooltip: tabTitles[i],
          color: color,
        ),
        content: TabContent(
          content: tabViews[i],
          fullTabTitle: tabTitles[i],
          color: color,
        ),
      );
      tabs.add(tabData);
    }

    _controller = TabbedViewController(tabs);
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
        title: const Text('new tabbed_view'),
      ),
      body: TabbedViewTheme(
        data: themeData(),
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
                  Color color = Colors.primaries[
                      (tabsList.length - 1) % Colors.primaries.length];
                  _controller.addTab(
                    TabData(
                      text: _calculateTitle(newTabTitle, tabsList),
                      leading: (context, status) => TabTooltipLeading(
                        tooltip: newTabTitle,
                        color: color,
                      ),
                      content: TabContent(
                        content: const Icon(
                          Icons.add,
                          size: 60,
                        ),
                        fullTabTitle: newTabTitle,
                        color: color,
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
                menuBuilder: (context) {
                  return _controller.tabs.map((element) {
                    return TabbedViewMenuItem(
                      text: (element.content as TabContent).fullTabTitle,
                      onSelection: () {
                        _controller.selectedIndex = element.index;
                      },
                    );
                  }).toList();
                },
                onPressed: () {},
              ),
            );
            buttons.add(
              TabButton(
                icon: IconProvider.data(Icons.keyboard_arrow_down),
                onPressed: () {
                  _showOverlayMenu(context);
                },
              ),
            );
            return buttons;
          },
          onTabClose: (index, tabData) {
            _onClose(tabData);
          },
        ),
      ),
    );
  }

  void _onClose(TabData tabData) {
    _closedTabs.add(tabData);
    List<String> tabsList = _controller.tabs
        .map((element) => (element.content as TabContent).fullTabTitle)
        .toList();
    for (var tab in _controller.tabs) {
      tab.text =
          _calculateTitle((tab.content as TabContent).fullTabTitle, tabsList);
    }
    setState(() {});
  }

  void _showOverlayMenu(BuildContext context) {
    overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return OverlayMenu(
          menuWidth: _overlayMenuWidth,
          closedTabs: _closedTabs,
          controller: _controller,
          closeTab: (TabData tabData) {
            _onClose(tabData);
          },
          closeOverlay: _closeOverlayMenu,
          rebuildOverlay: () {
            _rebuildOverlayMenu();
          },
        );
      },
    );
    overlayState!.insert(_overlayEntry!);
  }

  void _closeOverlayMenu() {
    if (_overlayEntry != null && _overlayEntry!.mounted)
      _overlayEntry!.remove();
    _overlayEntry = null;
  }

  void _rebuildOverlayMenu() {
    _overlayEntry!.markNeedsBuild();
  }

  //возвращаем заголовок для вкладки
  String _calculateTitle(String title, List<String> tabs) {
    int median = _calculateMedian(tabs);

    int croppedLength = median;
    int tabsWithoutCorrection = 5;
    int charsForCorrection = 2;

    //вносим дополнительное уменьшение размера заголовков при увеличении количества вкладок
    if (tabs.length >= tabsWithoutCorrection) {
      int correction =
          charsForCorrection * (tabs.length - tabsWithoutCorrection);
      if ((croppedLength - correction) >= 0) {
        croppedLength -= correction;
      } else {
        croppedLength = 0;
      }
    }

    if (title.length <= croppedLength) {
      return title.padRight(croppedLength - title.length);
    } else {
      if (croppedLength >= 3) {
        return '${title.substring(0, croppedLength - 3)}...';
      } else if (croppedLength == 2) {
        return '..';
      } else if (croppedLength == 1) {
        return '.';
      } else {
        return '';
      }
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
