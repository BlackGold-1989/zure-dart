import 'package:flutter/material.dart';
import 'package:zure/themes/thDimens.dart';
import 'package:zure/components/cCommon.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var dSelectedScreen = 0;
  var dSelectedData = 0;

  var jScreenData = [
    'Circle Theme',
    'Linear Theme',
  ];

  var jStructureData = [
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
        padding: EdgeInsets.symmetric(horizontal: tdFontBase, vertical: tdFontMd),
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
              height: tdOffsetSm,
            ),
            for (var item in jScreenData)
              ZureSettingItemWidget(
                sTitle: item,
                bSelected: dSelectedScreen == jScreenData.indexOf(item),
                fAction: () {
                  setState(() {
                    dSelectedScreen = jScreenData.indexOf(item);
                  });
                },
              ),
            SizedBox(
              height: tdOffsetMd,
            ),
            Text(
              'Select Data',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: tdOffsetSm,
            ),
            for (var item in jStructureData)
              ZureSettingItemWidget(
                sTitle: item,
                bSelected: dSelectedData == jStructureData.indexOf(item),
                fAction: () {
                  setState(() {
                    dSelectedData = jStructureData.indexOf(item);
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}
