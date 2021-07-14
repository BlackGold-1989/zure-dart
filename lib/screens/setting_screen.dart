import 'package:flutter/material.dart';
import 'package:zure/themes/dimens.dart';
import 'package:zure/widget/common_widget.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var selectedScreen = 0;
  var selectedData = 0;

  var jsonScreenData = [
    'Circle Theme',
    'Linear Theme',
  ];

  var jsonStructureData = [
    'Data 1',
    'Data 2',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Setting',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: fontBase, vertical: fontMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Screen',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: offsetSm,
            ),
            for (var item in jsonScreenData)
              SettingItemWidget(
                title: item,
                isSelected: selectedScreen == jsonScreenData.indexOf(item),
                action: () {
                  setState(() {
                    selectedScreen = jsonScreenData.indexOf(item);
                  });
                },
              ),
            SizedBox(
              height: offsetMd,
            ),
            Text(
              'Select Data',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: offsetSm,
            ),
            for (var item in jsonStructureData)
              SettingItemWidget(
                title: item,
                isSelected: selectedData == jsonStructureData.indexOf(item),
                action: () {
                  setState(() {
                    selectedData = jsonStructureData.indexOf(item);
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}
