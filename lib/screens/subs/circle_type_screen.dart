import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zure/models/segment_model.dart';
import 'package:zure/sevices/draw_service.dart';
import 'package:zure/themes/dimens.dart';
import 'package:zure/utils/constants.dart';
import 'package:zure/utils/params.dart';
import 'package:zure/widget/common_widget.dart';

class CircleTypeScreen extends StatefulWidget {
  const CircleTypeScreen({Key key}) : super(key: key);

  @override
  _CircleTypeScreenState createState() => _CircleTypeScreenState();
}

class _CircleTypeScreenState extends State<CircleTypeScreen> {
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
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Timer.run(() {
      _asyncData();
    });
  }

  void _asyncData() {
    scale = 1.0;

    segments.clear();
    for (var json in jsonData1) {
      var segment = SegmentModel.fromMap(json);
      segments.add(segment);
    }

    for (var segment in segments) {
      segment.resetPosition(
        size: segments.length,
        isFull: true,
        index: segments.indexOf(segment),
      );
    }

    allItems.clear();
    hasSubItems.clear();
    for (var segment in segments) {
      getAllItems(segment);
    }

    maxPosX = maxPosX - minPosX + 110.0;
    maxPosY = maxPosY - minPosY + 90.0;

    var scaleX = maxPosX / MediaQuery.of(context).size.width;
    var scaleY = maxPosY / MediaQuery.of(context).size.height;

    scale = max(scaleX, scaleY);

    print('[ALL] segment count: ${allItems.length}');
    for (var segment in allItems) {
      segment.offSet(minPosX, minPosY);
      if (segment.sub.isNotEmpty) {
        hasSubItems.add(segment);
      }
    }

    originTarget = Offset(-minPosX + itemDelta, -minPosX + itemDelta);
    setControllerScale((-minPosX + itemDelta), (-minPosX + itemDelta));
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

  Widget getDrawLines(SegmentModel model) {
    if (!model.isExpanded) return null;
    if (model.sub.isEmpty) return null;
    return Stack(
      children: [
        for (var item in model.sub)
          CustomPaint(
            painter: LineDraw(
                Offset(model.posX, model.posY), Offset(item.posX, item.posY)),
          ),
      ],
    );
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
        child: Stack(
          children: [
            if (isShownBased)
              MainDrawWidget(
                models: segments,
                scale: scale,
              ),
            for (var hasSubSegment in hasSubItems)
              if (hasSubSegment.isExpanded)
                SegmentDrawWidget(
                  scale: scale,
                  segment: hasSubSegment,
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
              top: (-minPosY + itemDelta - itemHeight / 2.0) / scale,
              left: (-minPosX + itemDelta - itemWidth / 2.0) / scale,
              child: InkWell(
                onTap: () {
                  isShownBased = !isShownBased;
                  for (var segment in segments) {
                    segment.setChangeVisible(isShownBased);
                  }
                  target = Offset(max(screenX, (-minPosX + itemDelta)),
                      max(screenY, (-minPosX + itemDelta)));
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
        ),
      ),
    );
  }
}
