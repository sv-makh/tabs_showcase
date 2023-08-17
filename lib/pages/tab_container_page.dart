import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';
import 'package:tabs_showcase/data/data.dart';
import 'package:tabs_showcase/widget/tab_filling.dart';

class TabContainerPage extends StatefulWidget {
  const TabContainerPage({super.key});

  @override
  State<TabContainerPage> createState() => _TabContainerPageState();
}

class _TabContainerPageState extends State<TabContainerPage> {
  late final TabContainerController _controller;

  @override
  void initState() {
    _controller = TabContainerController(length: tabTitles.length);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String initialValue = tabTitles[0];
    
    return Scaffold(
      appBar: AppBar(
        title: Text('tab_container'),
      ),
      body: Column(
        children: [
          Row(children: [
            IconButton(
              onPressed: () {
                _controller.prev();
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
            IconButton(
                onPressed: () {
                  _controller.next();
                },
                icon: Icon(Icons.arrow_forward_ios)),
            Spacer(),
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
                  _controller.jumpTo(tabTitles.indexOf(value));
                },
              ),
            ),
          ],),
          SizedBox(height: 10,),
          Container(
            height: MediaQuery.of(context).size.height - 200,
            child: TabContainer(
              controller: _controller,
              radius: 0,
              color: Colors.blueGrey,
              tabDuration: const Duration(seconds: 0),
              isStringTabs: false,
              tabs: List.generate(
                tabTitles.length,
                (index) => TabFilling(title: tabTitles[index]),
              ),
              children: tabViews,
            ),
          ),
        ],
      ),
    );
  }
}
