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
  int maxTabsLeadTextClose = 1;
  int maxTabsLead = 1;

  //примерная длина вкладки, на которой иконка, 3 символа, крестик
  double leadTextCloseWidth = 80;

  //длина вкладки, на которой иконка, крестик
  double leadCloseWidth = 57;

  //длина вкладки с минимальными паддингами, на которой иконка
  double minLeadCloseWidth = 48;

  //длина вкладки, на которой иконка
  double leadWidth = 35;

  //длина вкладки с минимальными паддингами, на которой иконка
  double minLeadWidth = 20;
  double paddindDivisor = 1.5;

  //длина правой области с кнопками (добавить вкладку, показать меню)
  double buttonsAreaWidth = 80;

  //паддинг у вкладки
  double tabPadding = 10;

  //изначальный паддинг
  double startPadding = 10;
  double oldTabPadding = 0;

  double currentDelta = 0;

  bool tabsInitializing = true;

  @override
  void initState() {
    super.initState();

    _controller = TabbedViewController(initTabs(tabTitles, tabViews));
    tabsInitializing = false;
  }

  List<TabData> initTabs(List<String> tabTitles, List<Widget> tabViews) {
    tabsInitializing = true;
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
    calculateMaxTabs(MediaQuery.of(context).size.width);

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

  void calculateMaxTabs(double tabViewWidth) {
    //длина области, в которой находятся вкладки
    double tabsAreaWidth = tabViewWidth - buttonsAreaWidth;

    maxTabs = (tabsAreaWidth - minLeadCloseWidth) ~/ minLeadWidth + 1;
    maxTabsLead = (tabsAreaWidth - leadCloseWidth) ~/ leadWidth + 1;
    maxTabsLeadTextClose = tabsAreaWidth ~/ leadTextCloseWidth;

  }

  bool isTabsClosable(int numOfTabs) {
    bool closable = true;
    if ((numOfTabs > maxTabsLeadTextClose)) {
      closable = false;
    }
    return closable;
  }

  void _onSelect(int? index) {
    if ((index != null) && (_controller.tabs.length > maxTabsLeadTextClose)) {
      for (int i = 0; i < _controller.tabs.length; i++) {
        _controller.tabs[i].closable = (i == index) ? true : false;
      }
    }
  }

  void _onAdd() {
    List<String> tabsList = _controller.tabs
        .map((element) => (element.content as TabContent).fullTabTitle)
        .toList();
    String newTabTitle =
        'new ${tabsList.length.toString()}th tab ${DateTime.now().millisecond}';
    tabsList.add(newTabTitle);
    Color color =
        Colors.primaries[(tabsList.length - 1) % Colors.primaries.length];

    for (int i = 0; i < _controller.tabs.length; i++) {
      _controller.tabs[i].text = _calculateTitle(
          (_controller.tabs[i].content as TabContent).fullTabTitle, tabsList);
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
      _calculateTabPadding(tabsList.length);
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

    if (tabsList.length - 1 < maxTabs) _controller.addTab(newTabData);

    setState(() {});
  }

  void _calculateTabPadding(int numOfTabs) {
    if (tabPadding >= 1) {
      currentDelta = (((numOfTabs - 1 - maxTabsLead) /
          ((maxTabs - maxTabsLead) / startPadding) +
          2)) /
          paddindDivisor;
      oldTabPadding = tabPadding;
      tabPadding = startPadding - currentDelta;
      if (tabPadding < 0) tabPadding = 0;
    }
  }

  void _onClose(TabData tabData) {
    _closedTabs.add(tabData);

    List<String> tabsList = _controller.tabs
        .map((element) => (element.content as TabContent).fullTabTitle)
        .toList();
    for (int i = 0; i < _controller.tabs.length; i++) {
      _controller.tabs[i].text = _calculateTitle(
          (_controller.tabs[i].content as TabContent).fullTabTitle, tabsList);
    }

    if (_controller.tabs.length <= maxTabsLeadTextClose) {
      for (int i = 0; i < _controller.tabs.length; i++) {
        _controller.tabs[i].closable = true;
      }
    }

    if (_controller.tabs.length >= maxTabsLead) {
      _calculateTabPadding(tabsList.length);
      if (tabPadding > 10) tabPadding = 10;
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

  //для запоминания длины заголовка вкладок перед тем, как с них будут убраны
  //кнопки для удаления (это произойдёт при tabs.length = maxTabsLeadTextClose)
  int fullTabLength = 0;

  //возвращаем заголовок для вкладки
  String _calculateTitle(String title, List<String> tabs) {
    int median = _calculateMedian(tabs);
    String result = '';

    if ((tabs.length <= maxTabsLeadTextClose) || tabsInitializing) {
      //уменьшение размера заголовка
      result = _correction(
          title: title,
          numOfTabs: tabs.length,
          croppedLength: median,
          tabsWithoutCorrection: 5,
          charsForCorrection: 2);

      //запоминаем длину заголовка вкладок
      fullTabLength = result.length;
    } else if ((tabs.length > maxTabsLeadTextClose)) {
      //убирание кнопки закрытия вкладок компенсируется тем, что обрезаем
      //заголовок на 3 символа меньше
      int startLength = fullTabLength + 3;

      result = _correction(
        title: title,
        numOfTabs: tabs.length,
        croppedLength: startLength,
        tabsWithoutCorrection: maxTabsLeadTextClose,
        charsForCorrection: 1,
      );
    }
    return result;
  }

  //обрезка строки в зависимости от заданных параметров
  String _correction({
    required String title,
    required int numOfTabs,
    required int croppedLength,
    required int tabsWithoutCorrection,
    required int charsForCorrection,
  }) {
    String result = '';
    int correction = 0;

    //учёт увеличения количества вкладок
    if (numOfTabs >= tabsWithoutCorrection) {
      correction = charsForCorrection * (numOfTabs - tabsWithoutCorrection);
      if ((croppedLength - correction) >= 0) {
        croppedLength -= correction;
      } else {
        croppedLength = 0;
      }
    }

    if (title.length <= croppedLength) {
      //при необходимости добавляем пробелы
      //а если длина заголовка = длине обреза, просто обрезаем
      result = title.padRight(croppedLength - title.length);
    } else {
      if (croppedLength >= 3) {
        result = '${title.substring(0, croppedLength - 2)}..';
      } else if (croppedLength == 2) {
        result = '${title.substring(0, croppedLength - 1)}.';
      } else if (croppedLength == 1) {
        if (maxTabsLead - numOfTabs > 3) {
          result = '${title.substring(0, 1)}.';
        } else {
        result = title.substring(0, croppedLength); }
      } else {
        if (maxTabsLead - numOfTabs > 3) {
          result = title.substring(0, 1);
        } else {
          result = '';
        }
      }
    }

    return result;
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
