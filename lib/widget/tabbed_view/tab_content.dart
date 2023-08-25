import 'package:flutter/material.dart';

//класс для содержимого вкладок
class TabContent extends StatelessWidget {
  //хранится полное имя вкладки - для использования при пересчёте заголовка,
  //который будет показан
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
