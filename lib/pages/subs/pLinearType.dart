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
  var dShowScale = 1.0;

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
    bShownBased = false;

    cpMinPosX = 0.0;
    cpMinPosY = 0.0;
    cpMaxPosX = 0.0;
    cpMaxPosY = 0.0;

    lSegments.clear();
    for (var json in jData1) {
      var segment = ZureSegmentModel.fromMap(json);
      lSegments.add(segment);
    }

    for (var segment in lSegments) {
      segment.zureResetLinearPosition(
        dSize: lSegments.length,
        dIndex: lSegments.indexOf(segment),
      );
    }

    lAllItems.clear();
    lHasSubItems.clear();
    for (var segment in lSegments) {
      getAllItems(segment);
    }

    cpMinPosX = cpMinPosX - cdItemDelta;
    cpMinPosY = cpMinPosY - cdItemDelta;
    cpMaxPosX = cpMaxPosX + cdItemDelta;
    cpMaxPosY = cpMaxPosY + cdItemDelta;

    var dPanelWidth = cpMaxPosX - cpMinPosX;
    var dPanelHeight = cpMaxPosY - cpMinPosY;

    var dRealWidth = MediaQuery.of(context).size.width;
    var dRealHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    var scaleX = dPanelWidth / dRealWidth;
    var scaleY = dPanelHeight / dRealHeight;

    dScale = max(scaleX, scaleY);
    dShowScale = dScale;

    cpWidth = dScale * dRealWidth;
    cpHeight = dScale * dRealHeight;

    Offset oCenter = Offset((cpWidth - dPanelWidth) / 2.0 - cpMinPosX,
        (cpHeight - dPanelHeight) / 2.0 - cpMinPosY);

    for (var segment in lAllItems) {
      segment.zureOffSet(-oCenter.dx, -oCenter.dy);
      if (segment.sub.isNotEmpty) {
        lHasSubItems.add(segment);
      }
    }

    oOriginTarget = Offset(-lSegments[0].posSX, -lSegments[0].posSY) +
        Offset(dRealWidth / 2.0, dRealHeight / 2.0);
    setControllerScale(oOriginTarget.dx, oOriginTarget.dy);
  }

  void setAnimationScale() {
    if (dStep > 0) {
      dStep = dStep - 1;

      Offset delta = (oTarget - oOriginTarget);
      Offset centerOffset =
          oTarget - delta * dStep.toDouble() / cdAnimationStep.toDouble();
      setControllerScale((centerOffset.dx), (centerOffset.dy));
      Timer(Duration(milliseconds: 300 ~/ cdAnimationStep),
          () => setAnimationScale());
    } else {
      Timer(Duration(milliseconds: 100), () {
        dStep = cdAnimationStep;
        oOriginTarget = oTarget;
      });
    }
  }

  void setControllerScale(double dx, double dy) {
    final initialTransform =
        Transform.translate(offset: Offset(dx, dy)).transform;
    controller =
        TransformationController(initialTransform.clone()..scale(dShowScale));

    setState(() {});
  }

  void getAllItems(ZureSegmentModel segmentModel) {
    lAllItems.add(segmentModel);
    for (var subSegment in segmentModel.sub) {
      getAllItems(subSegment);
    }
  }

  void setControllerParams() {
    dShowScale = double.parse(controller.value.row0.toString().split(',')[0]);
    var dOffsetX = double.parse(controller.value.row0.toString().split(',')[3]);
    var dOffsetY = double.parse(controller.value.row1.toString().split(',')[3]);
    oOriginTarget = Offset(dOffsetX, dOffsetY);
  }

  @override
  Widget build(BuildContext context) {
    final screenX = MediaQuery.of(context).size.width / 2.0;
    final screenY = (MediaQuery.of(context).size.height -
            AppBar().preferredSize.height -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).padding.bottom) /
        2.0;

    return Stack(
      children: [
        SafeArea(
          child: InteractiveViewer(
            maxScale: dScale * 2,
            minScale: dScale,
            onInteractionEnd: (detail) => setControllerParams(),
            transformationController: controller,
            scaleEnabled: true,
            child: Stack(
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
                  lAllItems[lAllItems.length - 1 - i].zureLinearWidget(
                    dScale,
                    fAction: () {
                      setState(
                        () {
                          lAllItems[lAllItems.length - 1 - i]
                              .zureSetChangeExpanded(
                              !lAllItems[lAllItems.length - 1 - i]
                                  .isExpanded);
                          if (lAllItems[lAllItems.length - 1 - i]
                              .isExpanded) {
                            List<ZureSegmentModel> friendSegments =
                            ZureSegmentModel.zureGetFriendSegment(
                                lAllItems[lAllItems.length - 1 - i],
                                lAllItems);
                            print(
                                '[Friends] length: ${friendSegments.length}');
                            if (friendSegments.isEmpty) {
                              friendSegments = lSegments;
                            }
                            for (var item in friendSegments) {
                              if (item.id ==
                                  lAllItems[lAllItems.length - 1 - i].id) {
                                continue;
                              }
                              item.zureSetChangeExpanded(false);
                            }
                          }

                          cpWidth = dShowScale * screenX * 2;
                          cpHeight = dShowScale * screenY * 2;
                          var posX = lAllItems[lAllItems.length - 1 - i].posX /
                              dScale *
                              dShowScale;
                          if (posX + cdItemDelta < screenX) {
                            posX = screenX;
                          }
                          if (posX + cdItemDelta > cpWidth - screenX) {
                            posX = cpWidth - screenX;
                          }
                          var posY = lAllItems[lAllItems.length - 1 - i].posY /
                              dScale *
                              dShowScale;
                          if (posY + cdItemDelta < screenY) {
                            posY = screenY;
                          }
                          if (posY + cdItemDelta > cpHeight - screenY) {
                            posY = cpHeight - screenY;
                          }
                          oTarget =
                              Offset(-posX, -posY) + Offset(screenX, screenY);
                          setControllerParams();
                          setAnimationScale();
                        },
                      );
                    },
                  ),
                if (lSegments.isNotEmpty)
                  Positioned(
                    top: (lSegments[0].posSY - cdItemHeight / 2) / dScale,
                    left: (lSegments[0].posSX - cdItemWidth / 2) / dScale,
                    child: InkWell(
                      onTap: () {
                        bShownBased = !bShownBased;
                        for (var segment in lSegments) {
                          segment.zureSetChangeVisible(bShownBased);
                        }
                        oTarget =
                            Offset(-lSegments[0].posSX, -lSegments[0].posSY) /
                                    dScale *
                                    dShowScale +
                                Offset(screenX, screenY);
                        setControllerParams();
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
                                fontSize: tdFontNormal, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Positioned(
          right: cdItemDelta / 2.0,
          top: cdItemDelta / 2.0,
          child: IconButton(
            onPressed: () {
              setState(() {
                _asyncData();
              });
            },
            icon: Icon(
              Icons.refresh,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
