import 'package:flutter/material.dart';

class NavigatorService {
  final BuildContext bcContext;

  NavigatorService(this.bcContext);

  void pushToWidget({
    @required Widget wiScreen,
    bool bReplace = false,
    Function(dynamic) fPop,
  }) {
    if (bReplace) {
      Navigator.of(bcContext)
          .pushReplacement(
          MaterialPageRoute<Object>(builder: (context) => wiScreen))
          .then((value) => {if (fPop != null) fPop(value)});
    } else {
      Navigator.of(bcContext)
          .push(MaterialPageRoute<Object>(builder: (context) => wiScreen))
          .then((value) => {if (fPop != null) fPop(value)});
    }
  }
}