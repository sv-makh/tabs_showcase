import 'package:flutter/material.dart';

class TabTooltipLeading extends StatelessWidget {
  String? tooltip;
  Color color;

  TabTooltipLeading({super.key, this.tooltip, required this.color});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.only(right: 4),
        child: Icon(Icons.circle, size: 5, color: color,),
      ),
    );
  }
}
