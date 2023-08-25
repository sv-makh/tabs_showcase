import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

TabbedViewThemeData themeData({double leftTabPadding = 10, double rightTabPadding = 10}) {
  TabbedViewThemeData themeData = TabbedViewThemeData();

  BorderSide tabsAreaBorderSide =
      const BorderSide(color: Color(0xffE8EAED), width: 5);

  Color hoverColor = const Color(0xffF0F2F4);
  Color borderColor = const Color(0xff919598);
  Color selectedColor = const Color(0xffFFFFFF);
  Color tabsColor = const Color(0xffE8EAED);

  themeData.tabsArea
    ..buttonsAreaPadding = const EdgeInsets.only(right: 3)
    ..buttonIconSize = 18
    ..buttonPadding = const EdgeInsets.only(right: 3, left: 3, bottom: 3)
    ..border = Border(top: tabsAreaBorderSide)
    ..middleGap = 0
    ..color = tabsColor;

  themeData.contentArea.decoration = BoxDecoration(color: selectedColor);

  Radius radius = const Radius.circular(5.0);
  BorderRadiusGeometry? tabBorderRadius =
      BorderRadius.only(topLeft: radius, topRight: radius);

  themeData.tab
    ..textStyle = const TextStyle(fontSize: 13)
    ..padding = EdgeInsets.fromLTRB(leftTabPadding, 4, rightTabPadding, 4)
    ..buttonsOffset = 8
    ..decoration = BoxDecoration(
      border: Border(
        right: BorderSide(color: borderColor, width: 1),
      ),
      shape: BoxShape.rectangle,
      color: tabsColor,
    )
    ..selectedStatus.decoration = BoxDecoration(
        color: selectedColor, borderRadius: tabBorderRadius)
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
