import 'package:flutter/material.dart';

class TabContent extends StatelessWidget {
  String fullTabTitle;
  Widget content;
  Color color;

  TabContent({super.key, required this.content, required this.fullTabTitle, required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Text(fullTabTitle),
      Center(child: content)]);
  }
}
