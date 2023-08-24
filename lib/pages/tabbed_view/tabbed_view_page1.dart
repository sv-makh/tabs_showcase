import 'package:flutter/material.dart';
import 'dart:ui';
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

  int maxTabs = 1;
  int maxTabsLeadClose = 1;
  int maxTabsLead = 1;

  int leadCloseWidth = 53;
  int minLeadCloseWidth = 34;
  int leadWidth = 31;
  int minLeadWidth = 13;
  int areaButtonsWidth = 100;
  int tabViewWidth = 0;
  List<TabData> additionalTabs = [];

  double tabPadding = 10;
  double oldTabPadding = 0;

  double currentDelta = 0;



  @override
  void initState() {
    super.initState();

    _controller = TabbedViewController(initTabs(tabTitles, tabViews));
  }

  List<TabData> initTabs(List<String> tabTitles, List<Widget> tabViews) {
    List<TabData> tabs = [];

    for (int i = 0; i < tabTitles.length; i++) {
      Color color = Colors.primaries[i % Colors.primaries.length];
      var tabData = TabData(
        closable: true,
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

    return tabs;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    calculateMaxTabs(MediaQuery.of(context).size.width.round());

    return Scaffold(
      appBar: AppBar(
        title: Text('new tabbed_view'),
      ),
      body: TabbedViewTheme(
        data:
            themeData(leftTabPadding: tabPadding, rightTabPadding: tabPadding),
        child: TabbedView(
          controller: _controller,
          onTabSelection: (index) {
            _onSelect(index);
          },
          tabsAreaButtonsBuilder: (context, tabsCount) {
            List<TabButton> buttons = [];
            buttons.add(
              TabButton(
                icon: IconProvider.data(Icons.add),
                onPressed: () {
                  _onAdd();
                },
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

  void calculateMaxTabs(int tabViewWidth) {
    maxTabs =
        (tabViewWidth - areaButtonsWidth - minLeadCloseWidth) ~/ minLeadWidth +
            1;
    maxTabsLeadClose = (tabViewWidth - areaButtonsWidth) ~/ leadCloseWidth;
    maxTabsLead =
        (tabViewWidth - areaButtonsWidth - leadCloseWidth) ~/ leadWidth + 1;

    print(
        'maxTabsLeadClose=$maxTabsLeadClose maxTabsLead=$maxTabsLead maxTabs=$maxTabs');
  }

  bool isTabsClosable(int numOfTabs) {
    bool closable = true;
    if (numOfTabs > maxTabsLeadClose) {
      closable = false;
    }
    return closable;
  }

  void _onSelect(int? index) {
    if ((index != null) && (_controller.tabs.length > maxTabsLeadClose)) {
      for (int i = 0; i < _controller.tabs.length; i++) {
        _controller.tabs[i].closable = (i == index) ? true : false;
      }
    }
  }

  void _onAdd() {
    List<String> tabsList = _controller.tabs
        .map((element) =>
    (element.content as TabContent).fullTabTitle)
        .toList();
    String newTabTitle =
        'new ${tabsList.length.toString()}th tab ${DateTime.now().millisecond}';
    tabsList.add(newTabTitle);
    Color color = Colors.primaries[
    (tabsList.length - 1) % Colors.primaries.length];

    for (var tab in _controller.tabs) {
      tab.text = _calculateTitle(
          (tab.content as TabContent).fullTabTitle, tabsList);
    }

    bool closable = isTabsClosable(tabsList.length);
    if (closable == false) {
      for (int i = 0; i < _controller.tabs.length; i++) {
        if (i == _controller.selectedIndex) {
          _controller.tabs[i].closable = true;
        } else {
          _controller.tabs[i].closable = closable;
        }
      }
    }

    if (_controller.tabs.length >= maxTabsLead) {
      if (tabPadding >= 1) {
        currentDelta = ((tabsList.length - 1 - maxTabsLead) /
            ((maxTabs - maxTabsLead) / 10) +
            2);
        oldTabPadding = tabPadding;
        tabPadding = 10 - currentDelta;
        if (tabPadding < 0) tabPadding = 0;
        print('add tabPadding=$tabPadding currentDelta=$currentDelta');
      }
    }

    TabData newTabData = TabData(
      closable: closable,
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
    );

    if (tabsList.length - 1 < maxTabs) {
      _controller.addTab(newTabData);
    } else {
      additionalTabs.add(newTabData);
    }

    setState(() {});
  }

  void _onClose(TabData tabData) {
    _closedTabs.add(tabData);

    print('tabs.length=${_controller.tabs.length} ');

    if ((_controller.tabs.length < maxTabs) && (additionalTabs.isNotEmpty)) {
      _controller.addTab(additionalTabs[0]);
      additionalTabs.removeAt(0);
    }

    List<String> tabsList = _controller.tabs
        .map((element) => (element.content as TabContent).fullTabTitle)
        .toList();
    for (var tab in _controller.tabs) {
      tab.text =
          _calculateTitle((tab.content as TabContent).fullTabTitle, tabsList);
    }

    if (_controller.tabs.length <= maxTabsLeadClose) {
      for (int i = 0; i < _controller.tabs.length; i++) {
        _controller.tabs[i].closable = true;
      }
    }

    if (_controller.tabs.length >= maxTabsLead) {
      tabPadding = oldTabPadding;
      //tabPadding += currentDelta;
      if (tabPadding > 10) tabPadding = 10;
      //oldTabPadding = tabPadding;
      print('delete tabPadding=$tabPadding currentDelta=$currentDelta');
    }

    if (_controller.tabs.isNotEmpty) _controller.selectedIndex = 0;
    _controller.tabs[0].closable = true;

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
          additionalTabs: additionalTabs,
          maxTabs: maxTabs,
        );
      },
    );
    overlayState!.insert(_overlayEntry!);
  }

  void _closeOverlayMenu() {
    if (_overlayEntry != null && _overlayEntry!.mounted)
      _overlayEntry!.remove();
    _overlayEntry = null;
    setState(() {});
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
