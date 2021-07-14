import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zure/models/segment_model.dart';
import 'package:zure/themes/dimens.dart';
import 'package:zure/utils/constants.dart';
import 'package:zure/utils/params.dart';
import 'package:zure/widget/common_widget.dart';
import 'package:zure/sevices/extensions.dart';

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

    Timer.run(() {
      _asyncData();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _asyncData() {
    scale = 1.0;

    segments.clear();
    for (var json in jsonData1) {
      var segment = SegmentModel.fromMap(json);
      segments.add(segment);
    }

    allItems.clear();
    hasSubItems.clear();
    for (var segment in segments) {
      getAllItems(segment);
    }

    for (var segment in segments) {
      segment.resetLinearPosition(
        size: segments.length,
        index: segments.indexOf(segment),
      );
    }

    print('[MIN : MAX] : [$minPosX , $minPosY] [$maxPosX , $maxPosY]');

    maxPosX = maxPosX - minPosX + 110.0;
    maxPosY = maxPosY - minPosY + 90.0;

    final screenX = MediaQuery.of(context).size.width / 2.0;
    final screenY = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom) /
        2.0;

    var scaleX = maxPosX / (screenX * 2);
    var scaleY = maxPosY / (screenY * 2);

    scale = max(scaleX, scaleY);

    print('[ALL] segment count: ${allItems.length}');
    for (var segment in allItems) {
      segment.offSet(minPosX, (minPosY + maxPosY) / 2 - screenY);
      if (segment.sub.isNotEmpty) {
        hasSubItems.add(segment);
      }
    }

    originTarget = Offset(segments[0].posSX, segments[0].posSY);
    setControllerScale(originTarget.dx, originTarget.dy);
  }

  void setAnimationScale() {
    if (step > 0) {
      step = step - 1;

      Offset delta = target - originTarget;
      Offset centerOffset =
          target - delta * step.toDouble() / animationStep.toDouble();
      setControllerScale(centerOffset.dx, centerOffset.dy);
      Timer(Duration(milliseconds: 300 ~/ animationStep),
              () => setAnimationScale());
    } else {
      Timer(Duration(milliseconds: 100), () {
        step = animationStep;
        originTarget = target;
      });
    }
  }

  void setControllerScale(double centerX, double centerY) {
    final screenX = MediaQuery.of(context).size.width / 2.0;
    final screenY = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom) /
        2.0;

    final w = max(0.0, centerX - screenX);
    final h = max(0.0, centerY - screenY);

    print('[OFFSET] values: [$w , $h]');

    final initialTransform =
        Transform.translate(offset: Offset(-w, -h)).transform;
    controller =
        TransformationController(initialTransform.clone()..scale(scale));
    setState(() {});
  }

  void getAllItems(SegmentModel segmentModel) {
    allItems.add(segmentModel);
    for (var subSegment in segmentModel.sub) {
      getAllItems(subSegment);
    }
  }




  @override
  Widget build(BuildContext context) {
    final screenX = MediaQuery.of(context).size.width / 2.0;
    final screenY = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom) /
        2.0;

    return SafeArea(
      child: InteractiveViewer(
        maxScale: scale,
        transformationController: controller,
        scaleEnabled: false,
        child: segments.isNotEmpty? Stack(
          children: [
            if (isShownBased)
              MainLinearDrawWidget(
                models: segments,
                scale: scale,
              ),
            for (var hasSubSegment in hasSubItems)
              if (hasSubSegment.isExpanded)
                MainLinearDrawWidget(
                  scale: scale,
                  models: hasSubSegment.sub,
                  color: hasSubSegment.color.toColor(),
                ),
            for (var i = 0; i < allItems.length; i++)
              allItems[allItems.length - 1 - i].circleWidget(scale, action: () {
                setState(() {
                  allItems[allItems.length - 1 - i].setChangeExpanded(
                      !allItems[allItems.length - 1 - i].isExpanded);
                  if (allItems[allItems.length - 1 - i].isExpanded) {
                    List<SegmentModel> friendSegments =
                    SegmentModel.getFriendSegment(
                        allItems[allItems.length - 1 - i], allItems);
                    print('[Friends] length: ${friendSegments.length}');
                    if (friendSegments.isEmpty) {
                      friendSegments = segments;
                    }
                    for (var item in friendSegments) {
                      if (item.id == allItems[allItems.length - 1 - i].id) {
                        continue;
                      }
                      item.setChangeExpanded(false);
                    }
                    target = Offset(
                        max(screenX, allItems[allItems.length - 1 - i].posX),
                        max(screenY, allItems[allItems.length - 1 - i].posY));
                    setAnimationScale();
                  }
                });
              }),
            Positioned(
              top: (segments[0].posSY - itemHeight / 2) / scale,
              left: (segments[0].posSX - itemWidth / 2) / scale,
              child: InkWell(
                onTap: () {
                  isShownBased = !isShownBased;
                  for (var segment in segments) {
                    segment.setChangeVisible(isShownBased);
                  }
                  target = Offset(max(screenX, (segments[0].posSX)),
                      max(screenY, (segments[0].posSY)));
                  setAnimationScale();
                },
                child: Container(
                  width: itemWidth / scale,
                  height: itemHeight / scale,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 0.5),
                    borderRadius: BorderRadius.all(
                        Radius.circular(itemHeight / 3.0 / scale)),
                  ),
                  child: Center(
                    child: Text(
                      'PHYSICS',
                      style: TextStyle(
                          fontSize: fontNormal - scale, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ) : Container(),
      ),
    );
  }
}
