import 'package:flutter/material.dart';
import 'package:reorderable_tabbar/reorderable_tabbar.dart';
import 'package:tabs_showcase/data/data.dart';
import 'package:tabs_showcase/widget/tab_filling.dart';

//https://pub.dev/packages/reorderable_tabbar

class ReorderableTabBarPage extends StatefulWidget {
  const ReorderableTabBarPage({Key? key}) : super(key: key);

  @override
  State<ReorderableTabBarPage> createState() => _ReorderableTabBarPageState();
}

class _ReorderableTabBarPageState extends State<ReorderableTabBarPage>
    with TickerProviderStateMixin {
  late TabController _controller;
  int _selectedIndex = 0;

  List<String> tabs = List.from(tabTitles);
  List<Icon> views = List.from(tabViews);

  bool isScrollable = false;
  bool tabSizeIsLabel = false;

  String initialValue = tabTitles[0];

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //String initialValue = tabs[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text("reorderable_tabbar"),
        /*bottom: ReorderableTabBar(
          controller: _controller,
          buildDefaultDragHandles: false,
          tabs: tabs
              .map((e) => ReorderableDragStartListener(
                    index: tabs.indexOf(e),
                    child: TabFilling(title: e),
                  ))
              .toList(),
          indicatorSize: tabSizeIsLabel ? TabBarIndicatorSize.label : null,
          isScrollable: isScrollable,
          reorderingTabBackgroundColor: Colors.black45,
          indicatorWeight: 5,
          tabBorderRadius: const BorderRadius.vertical(
            top: Radius.circular(8),
          ),
          onReorder: (oldIndex, newIndex) async {
            String temp = tabs.removeAt(oldIndex);
            Icon tempIcon = views.removeAt(oldIndex);
            tabs.insert(newIndex, temp);
            views.insert(newIndex, tempIcon);
            setState(() {});
          },
        ),*/
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          tabs.add('${(tabs.length + 1).toString()}th tab');
          views.add(const Icon(
            Icons.add,
            size: 60,
          ));
          setState(() {});
        },
      ),
      body: Column(
        children: [
          Row(children: [
            IconButton(
              onPressed: () {
                //_controller.prev();
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
            IconButton(
                onPressed: () {
                  //_controller.next();
                },
                icon: const Icon(Icons.arrow_forward_ios),),
            IconButton(onPressed: () {
              setState(() {
                tabs.removeAt(_controller.index);
                views.removeAt(_controller.index);
                _controller = TabController(length: tabs.length, vsync: this);
              });
            }, icon: Icon(Icons.delete),),
            const Spacer(),
            SizedBox(
              width: 300,
              child: DropdownButton<String>(
                isExpanded: true,
                value: initialValue,
                items: tabs.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  initialValue = value!;
                  _controller.animateTo(tabs.indexOf(value));
                  setState(() {});
                  //_controller.jumpTo(tabTitles.indexOf(value));
                },
              ),
            ),
          ],),
          ReorderableTabBar(
            controller: _controller,
            buildDefaultDragHandles: false,
            tabs: tabs
                .map((e) => ReorderableDragStartListener(
              index: tabs.indexOf(e),
              child: TabFilling(title: e),
            ))
                .toList(),
            indicatorSize: tabSizeIsLabel ? TabBarIndicatorSize.label : null,
            isScrollable: isScrollable,
            reorderingTabBackgroundColor: Colors.black45,
            indicatorWeight: 5,
            tabBorderRadius: const BorderRadius.vertical(
              top: Radius.circular(8),
            ),
            onReorder: (oldIndex, newIndex) async {
              String temp = tabs.removeAt(oldIndex);
              Icon tempIcon = views.removeAt(oldIndex);
              tabs.insert(newIndex, temp);
              views.insert(newIndex, tempIcon);
              setState(() {});
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 300,
            child: TabBarView(
              controller: _controller,
              children: views,
            ),
          ),
        ],
      ),
    );
  }
}
