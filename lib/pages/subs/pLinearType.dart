import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zure/models/mSegment.dart';
import 'package:zure/themes/thDimens.dart';
import 'package:zure/scripts/scConstants.dart';
import 'package:zure/scripts/scParams.dart';
import 'package:zure/components/cCommon.dart';
import 'package:zure/services/svExtensions.dart';

class LinearTypeScreen extends StatefulWidget {
  const LinearTypeScreen({Key key}) : super(key: key);

  @override
  _LinearTypeScreenState createState() => _LinearTypeScreenState();
}

class _LinearTypeScreenState extends State<LinearTypeScreen> {
  List<ZureSegmentModel> lSegments = [];
  List<ZureSegmentModel> lAllItems = [];
  List<ZureSegmentModel> lHasSubItems = [];

  var bShownBased = false;

  var dScale = 1.0;

  var controller = TransformationController();

  var dStep = cdAnimationStep;
  Offset oOriginTarget = Offset.zero;
  Offset oTarget = Offset.zero;

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
    dScale = 1.0;

    lSegments.clear();
    for (var json in jData1) {
      var segment = ZureSegmentModel.fromMap(json);
      lSegments.add(segment);
    }

    lAllItems.clear();
    lHasSubItems.clear();
    for (var segment in lSegments) {
      getAllItems(segment);
    }

    for (var segment in lSegments) {
      segment.zureResetLinearPosition(
        dSize: lSegments.length,
        dIndex: lSegments.indexOf(segment),
      );
    }

    print('[MIN : MAX] : [$cpMinPosX , $cpMinPosY] [$cpMaxPosX , $cpMaxPosY]');

    cpMaxPosX = cpMaxPosX - cpMinPosX + 110.0;
    cpMaxPosY = cpMaxPosY - cpMinPosY + 90.0;

    final screenX = MediaQuery.of(context).size.width / 2.0;
    final screenY = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom) /
        2.0;

    var scaleX = cpMaxPosX / (screenX * 2);
    var scaleY = cpMaxPosY / (screenY * 2);

    dScale = max(scaleX, scaleY);

    print('[ALL] segment count: ${lAllItems.length}');
    for (var segment in lAllItems) {
      segment.zureOffSet(cpMinPosX, (cpMinPosY + cpMaxPosY) / 2 - screenY);
      if (segment.sub.isNotEmpty) {
        lHasSubItems.add(segment);
      }
    }

    oOriginTarget = Offset(lSegments[0].posSX, lSegments[0].posSY);
    setControllerScale(oOriginTarget.dx, oOriginTarget.dy);
  }

  void setAnimationScale() {
    if (dStep > 0) {
      dStep = dStep - 1;

      Offset delta = oTarget - oOriginTarget;
      Offset centerOffset =
          oTarget - delta * dStep.toDouble() / cdAnimationStep.toDouble();
      setControllerScale(centerOffset.dx, centerOffset.dy);
      Timer(Duration(milliseconds: 300 ~/ cdAnimationStep),
              () => setAnimationScale());
    } else {
      Timer(Duration(milliseconds: 100), () {
        dStep = cdAnimationStep;
        oOriginTarget = oTarget;
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
        TransformationController(initialTransform.clone()..scale(dScale));
    setState(() {});
  }

  void getAllItems(ZureSegmentModel segmentModel) {
    lAllItems.add(segmentModel);
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
        maxScale: dScale,
        transformationController: controller,
        scaleEnabled: false,
        child: lSegments.isNotEmpty? Stack(
          children: [
            if (bShownBased)
              ZureMainLinearDrawWidget(
                lModels: lSegments,
                dScale: dScale,
              ),
            for (var hasSubSegment in lHasSubItems)
              if (hasSubSegment.isExpanded)
                ZureMainLinearDrawWidget(
                  dScale: dScale,
                  lModels: hasSubSegment.sub,
                  cColor: hasSubSegment.color.toColor(),
                ),
            for (var i = 0; i < lAllItems.length; i++)
              lAllItems[lAllItems.length - 1 - i].zureLinearWidget(dScale, fAction: () {
                setState(() {
                  lAllItems[lAllItems.length - 1 - i].zureSetChangeExpanded(
                      !lAllItems[lAllItems.length - 1 - i].isExpanded);
                  if (lAllItems[lAllItems.length - 1 - i].isExpanded) {
                    List<ZureSegmentModel> friendSegments =
                    ZureSegmentModel.zureGetFriendSegment(
                        lAllItems[lAllItems.length - 1 - i], lAllItems);
                    print('[Friends] length: ${friendSegments.length}');
                    if (friendSegments.isEmpty) {
                      friendSegments = lSegments;
                    }
                    for (var item in friendSegments) {
                      if (item.id == lAllItems[lAllItems.length - 1 - i].id) {
                        continue;
                      }
                      item.zureSetChangeExpanded(false);
                    }
                    oTarget = Offset(
                        max(screenX, lAllItems[lAllItems.length - 1 - i].posX),
                        max(screenY, lAllItems[lAllItems.length - 1 - i].posY));
                    setAnimationScale();
                  }
                });
              }),
            Positioned(
              top: (lSegments[0].posSY - cdItemHeight / 2) / dScale,
              left: (lSegments[0].posSX - cdItemWidth / 2) / dScale,
              child: InkWell(
                onTap: () {
                  bShownBased = !bShownBased;
                  for (var segment in lSegments) {
                    segment.zureSetChangeVisible(bShownBased);
                  }
                  oTarget = Offset(max(screenX, (lSegments[0].posSX)),
                      max(screenY, (lSegments[0].posSY)));
                  setAnimationScale();
                },
                child: Container(
                  width: cdItemWidth / dScale,
                  height: cdItemHeight / dScale,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 0.5),
                    borderRadius: BorderRadius.all(
                        Radius.circular(cdItemHeight / 3.0 / dScale)),
                  ),
                  child: Center(
                    child: Text(
                      'PHYSICS',
                      style: TextStyle(
                          fontSize: tdFontNormal - dScale, color: Colors.black),
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
