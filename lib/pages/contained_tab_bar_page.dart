import 'package:contained_tab_bar_view_with_custom_page_navigator/contained_tab_bar_view_with_custom_page_navigator.dart';
import 'package:flutter/material.dart';

import '../data/data.dart';

//https://pub.dev/packages/contained_tab_bar_view_with_custom_page_navigator

class ContainedTabBarPage extends StatelessWidget {
  const ContainedTabBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    double tabTitleWidth =
        MediaQuery
            .of(context)
            .size
            .width / tabTitles.length - 16;
    double tabTitleHeight = 60;

    GlobalKey<ContainedTabBarViewState> _key = GlobalKey();

    String initialValue = tabTitles[0];

    return Scaffold(
      appBar: AppBar(
        title: Text('contained_tab_bar_view_with_custom_page_navigator'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: initialValue,
            items: tabTitles.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, overflow: TextOverflow.ellipsis,),
              );
            }).toList(),
            onChanged: (value) {
              initialValue = value!;
              _key.currentState?.animateTo(tabTitles.indexOf(value));
            },),
          Container(
            height: MediaQuery.of(context).size.height - 200,
            child: ContainedTabBarView(
              key: _key,
              tabs: [
                ...tabTitles
                    .map(
                      (e) =>
                      Tooltip(
                        message: e,
                        child: Container(
                          width: tabTitleWidth,
                          height: tabTitleHeight,
                          padding: EdgeInsets.only(left: 4, right: 4),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.grey[600]!),
                            borderRadius: BorderRadius.all(
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
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
      )
      ,
    );
  }
}
