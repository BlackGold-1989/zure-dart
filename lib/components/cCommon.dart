import 'package:flutter/material.dart';
import 'package:zure/models/mSegment.dart';
import 'package:zure/services/svDraw.dart';
import 'package:zure/themes/thDimens.dart';
import 'package:zure/scripts/scConstants.dart';
import 'package:zure/scripts/scParams.dart';
import 'package:zure/services/svExtensions.dart';

class ZureSettingItemWidget extends Container {
  ZureSettingItemWidget({
    String sTitle,
    bool bSelected = false,
    Function() fAction,
  }) : super(
          padding: EdgeInsets.all(tdOffsetBase),
          child: InkWell(
            onTap: () => fAction(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  sTitle,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
                Icon(
                  bSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        );
}

class ZureMainCircleDrawWidget extends StatelessWidget {
  final List<ZureSegmentModel> lModels;
  final double dScale;

  const ZureMainCircleDrawWidget({
    Key key,
    @required this.lModels,
    @required this.dScale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var centerPosX = (lModels[0].posSX) / dScale;
    var centerPosY = (lModels[0].posSY) / dScale;

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          CustomPaint(
            painter: ZureCircleDotDraw(
              Offset(centerPosX, centerPosY),
              dScale: dScale,
            ),
          ),
          for (var segment in lModels)
            CustomPaint(
              painter: ZureLineDotDraw(
                Offset(centerPosX, centerPosY),
                Offset((segment.posX) / dScale, (segment.posY) / dScale),
              ),
            ),
        ],
      ),
    );
  }
}

class ZureSegmentCircleDrawWidget extends StatelessWidget {
  final double dScale;
  final ZureSegmentModel seModel;

  const ZureSegmentCircleDrawWidget({
    Key key,
    this.dScale,
    this.seModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          CustomPaint(
            painter: ZureCircleDotDraw(
              Offset(seModel.posX / dScale, seModel.posY / dScale),
              cColor: seModel.color.toColor(),
              dScale: dScale,
            ),
          ),
          for (var seg in seModel.sub)
            CustomPaint(
              painter: ZureLineDotDraw(
                Offset(seModel.posX / dScale, seModel.posY / dScale),
                Offset((seg.posX) / dScale, (seg.posY) / dScale),
                cColor: seModel.color.toColor(),
              ),
            ),
        ],
      ),
    );
  }
}

class ZureMainLinearDrawWidget extends StatelessWidget {
  final List<ZureSegmentModel> lModels;
  final double dScale;
  final Color cColor;

  const ZureMainLinearDrawWidget({
    Key key,
    @required this.lModels,
    @required this.dScale,
    this.cColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var centerPosX = lModels[0].posSX / dScale;
    var centerPosY = lModels[0].posSY / dScale;

    var subWidth = ((lModels.length - 1) * (cdItemWidth + cdLinearPadding)) / dScale;

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          CustomPaint(
            painter: ZureLineDotDraw(
              Offset(centerPosX, centerPosY),
              Offset(centerPosX, centerPosY + cdItemHeight / dScale),
              cColor: cColor,
            ),
          ),
          CustomPaint(
            painter: ZureLineDotDraw(
              Offset(centerPosX - subWidth / 2, centerPosY + cdItemHeight / dScale),
              Offset(centerPosX + subWidth / 2, centerPosY + cdItemHeight / dScale),
              cColor: cColor,
            ),
          ),
          for (var segment in lModels)
            CustomPaint(
              painter: ZureLineDotDraw(
                Offset((segment.posX) / dScale, (segment.posY - cdItemHeight) / dScale),
                Offset((segment.posX) / dScale, (segment.posY) / dScale),
                cColor: cColor,
              ),
            ),
        ],
      ),
    );
  }
}
