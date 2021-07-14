import 'package:flutter/material.dart';
import 'package:zure/screens/setting_screen.dart';
import 'package:zure/screens/subs/circle_type_screen.dart';
import 'package:zure/screens/subs/linear_type_screen.dart';
import 'package:zure/sevices/navigator_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var isCircleType = false;

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
                  screen: SettingScreen(),
                  pop: (val) {
                    setState(() {
                      // _asyncData();
                    });
                  });
            },
          ),
        ],
      ),
      body: isCircleType? CircleTypeScreen() : LinearTypeScreen(),
    );
  }
}
