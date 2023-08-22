import 'package:flutter/material.dart';
import 'package:tabs_showcase/widget/tab_leading.dart';

class TabTooltipLeading extends StatelessWidget {
  String tooltip;
  Color color;

  TabTooltipLeading({super.key, required this.tooltip, required this.color});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: TabLeading(color: color,),
    );
  }
}
