import 'package:flutter/material.dart';
import 'package:zure/pages/pSetting.dart';
import 'package:zure/pages/subs/pCircleType.dart';
import 'package:zure/pages/subs/pLinearType.dart';
import 'package:zure/services/svNavigator.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // You can change this value with manual, so that you can test the different type screen mode.
  var bCircleType = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Zure',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
            ),
            onPressed: () {
              NavigatorService(context).pushToWidget(
                  wiScreen: SettingScreen(),
                  fPop: (val) {
                    setState(() {
                      // bCircleType = !bCircleType;
                    });
                  });
            },
          ),
        ],
      ),
      body: bCircleType? CircleTypeScreen() : LinearTypeScreen(),
    );
  }
}
