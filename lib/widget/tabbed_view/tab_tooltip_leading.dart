import 'package:flutter/material.dart';
import 'package:tabs_showcase/widget/tabbed_view/tab_leading.dart';

class TabTooltipLeading extends StatelessWidget {
  String tooltip;
  Color color;
  double rightPadding;

  TabTooltipLeading({super.key, required this.tooltip, required this.color, this.rightPadding = 4});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: TabLeading(color: color, rightPadding: rightPadding,),
    );
  }
}
