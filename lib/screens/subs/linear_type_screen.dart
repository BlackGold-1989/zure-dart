import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zure/models/segment_model.dart';
import 'package:zure/sevices/draw_service.dart';
import 'package:zure/themes/dimens.dart';
import 'package:zure/utils/constants.dart';
import 'package:zure/utils/params.dart';
import 'package:zure/widget/common_widget.dart';

class LinearTypeScreen extends StatefulWidget {
  const LinearTypeScreen({Key key}) : super(key: key);

  @override
  _LinearTypeScreenState createState() => _LinearTypeScreenState();
}

class _LinearTypeScreenState extends State<LinearTypeScreen> {
  List<SegmentModel> segments = [];
  List<SegmentModel> allItems = [];
  List<SegmentModel> hasSubItems = [];

  var isShownBased = false;

  var scale = 1.0;

  var controller = TransformationController();

  var step = animationStep;
  Offset originTarget = Offset.zero;
  Offset target = Offset.zero;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [

        ],
      ),
    );
  }
}
