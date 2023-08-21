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

  List<TabData> _closedTabs = [];

  late OverlayEntry? _overlayEntry;
  OverlayState? overlayState; // = Overlay.of(context);
  double _overlayMenuWidth = 300;

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
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                  if (_overlayEntry != null) {
                    _rebuildOverlayMenu();
                  }
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
            //_rebuildOverlayMenu();
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
    if (_overlayEntry != null) {
      _rebuildOverlayMenu();
    }
    setState(() {});
  }

  void _showOverlayMenu(BuildContext context) {
    overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(builder: (context) {
      return Stack(children: [
        ModalBarrier(
          onDismiss: () {
            _closeOverlayMenu();
          },
        ),
        Positioned(
          left: MediaQuery.of(context).size.width - _overlayMenuWidth - 5,
          top: 100,
          child: Material(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(5),
              width: _overlayMenuWidth,
              height: MediaQuery.of(context).size.height - 200,
              child: _menu(),
            ),
          ),
        ),
      ]);
    });
    overlayState!.insert(_overlayEntry!);
  }

  Widget _menu() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(hintText: 'Search tabs', hintStyle: TextStyle(fontSize: 12)),
          ),
          _divider(),
          Text('Open tabs'),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _controller.tabs.length,
            itemBuilder: (BuildContext context, int index) {
              return MenuItemButton(
                trailingIcon: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    TabData tabToRemove = _controller.getTabByIndex(index);
                    _controller.removeTab(index);
                    _onClose(tabToRemove);
                  },
                ),
                onPressed: () {
                  _controller.selectedIndex = index;
                  _closeOverlayMenu();
                },
                child: SizedBox(
                  width: _overlayMenuWidth - 80,
                  child: Text(
                    (_controller.tabs[index].content as TabContent)
                        .fullTabTitle,
                    style: TextStyle(fontSize: 12),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
              );
            },
          ),
          _divider(),
          Text('Recently closed'),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _closedTabs.length,
            itemBuilder: (BuildContext context, int index) {
              return MenuItemButton(
                child: SizedBox(
                  width: _overlayMenuWidth - 80,
                  child: Text(
                      (_closedTabs[index].content as TabContent).fullTabTitle,
                    style: TextStyle(fontSize: 12),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const SizedBox(height: 10,);
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
    int charsForCorrection = 1;

    //вносим дополнительное уменьшение размера заголовков при увеличении количества вкладок
    if (tabs.length >= tabsWithoutCorrection) {
      int correction =
          charsForCorrection * (tabs.length - tabsWithoutCorrection);
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
