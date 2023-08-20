import 'package:contained_tab_bar_view_with_custom_page_navigator/contained_tab_bar_view_with_custom_page_navigator.dart';
import 'package:flutter/material.dart';

import '../data/data.dart';

//https://pub.dev/packages/contained_tab_bar_view_with_custom_page_navigator
//аналогичен более старому https://pub.dev/packages/contained_tab_bar_view

class ContainedTabBarPage extends StatefulWidget {
  const ContainedTabBarPage({super.key});

  @override
  State<ContainedTabBarPage> createState() => _ContainedTabBarPageState();
}


class _ContainedTabBarPageState extends State<ContainedTabBarPage> {

  @override
  Widget build(BuildContext context) {
    double tabTitleWidth =
        MediaQuery.of(context).size.width / tabTitles.length - 16;
    double tabTitleHeight = 60;

    GlobalKey<ContainedTabBarViewState> key = GlobalKey();

    String initialValue = tabTitles[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('contained_tab_bar_view_with_custom_page_navigator'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  key.currentState?.previous();
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              IconButton(
                  onPressed: () {
                    key.currentState?.next();
                  },
                  icon: const Icon(Icons.arrow_forward_ios)),
              const Spacer(),
              SizedBox(
                width: 300,
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: initialValue,
                  items: tabTitles.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        overflow: TextOverflow.visible,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    initialValue = value!;
                    key.currentState?.animateTo(tabTitles.indexOf(value));
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            child: ContainedTabBarView(
              key: key,
              tabs: [
                ...tabTitles
                    .map(
                      (e) => Tooltip(
                        message: e,
                        child: Container(
                          width: tabTitleWidth,
                          height: tabTitleHeight,
                          padding: const EdgeInsets.only(left: 4, right: 4),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.grey[600]!),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(4.0),
                            ),
                          ),
                          child: Center(
                              child: Text(
                            e,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )),
                        ),
                      ),
                    )
                    .toList(),
              ],
              tabBarProperties: TabBarProperties(
                width: MediaQuery.of(context).size.width,
                height: tabTitleHeight + 10,
                position: TabBarPosition.top,
                background: Container(
                  color: Colors.lightBlueAccent,
                ),
                labelColor: Colors.white,
                indicator: ContainerTabIndicator(
                  width: tabTitleWidth,
                  height: tabTitleHeight,
                  radius: BorderRadius.circular(4.0),
                  color: Colors.blue,
                ),
              ),
              views: tabViews,
              onChange: (index) => print(index),
            ),
          ),
        ],
      ),
    );
  }
}
