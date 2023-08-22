import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

TabbedViewThemeData themeData() {
  TabbedViewThemeData themeData = TabbedViewThemeData();

  BorderSide tabsAreaBorderSide =
      const BorderSide(color: Color(0xffE8EAED), width: 3);

  Color hoverColor = const Color(0xffF0F2F4);
  Color borderColor = const Color(0xff919598);

  themeData.tabsArea
    ..buttonsAreaPadding = const EdgeInsets.only(right: 3)
    ..buttonIconSize = 18
    ..buttonPadding = const EdgeInsets.only(right: 3, left: 3, bottom: 3)
    ..border = Border(top: tabsAreaBorderSide, bottom: tabsAreaBorderSide)
    ..middleGap = 1
    ..color = const Color(0xffE8EAED);

  Radius radius = const Radius.circular(5.0);
  BorderRadiusGeometry? tabBorderRadius =
      BorderRadius.only(topLeft: radius, topRight: radius);

  themeData.tab
    ..textStyle = const TextStyle(fontSize: 13)
    ..padding = const EdgeInsets.fromLTRB(10, 4, 10, 4)
    ..buttonsOffset = 8
    ..decoration = BoxDecoration(
      border: Border(
        right: BorderSide(color: borderColor, width: 1),
      ),
      shape: BoxShape.rectangle,
      color: const Color(0xffE8EAED),
    )
    ..selectedStatus.decoration = BoxDecoration(
        color: const Color(0xffFFFFFF), borderRadius: tabBorderRadius)
    ..highlightedStatus.decoration =
        BoxDecoration(color: hoverColor, borderRadius: tabBorderRadius);

  themeData.menu
    ..border = Border.all(color: borderColor, width: 1)
    ..dividerColor = borderColor
    ..ellipsisOverflowText = false
    ..margin = const EdgeInsets.all(5)
    ..hoverColor = hoverColor
    ..menuItemPadding = const EdgeInsets.all(5);

  return themeData;
}
