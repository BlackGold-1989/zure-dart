import 'package:flutter/material.dart';
import 'package:zure/models/segment_model.dart';
import 'package:zure/sevices/draw_service.dart';
import 'package:zure/themes/dimens.dart';
import 'package:zure/utils/constants.dart';
import 'package:zure/utils/params.dart';
import 'package:zure/sevices/extensions.dart';

class SettingItemWidget extends Container {
  SettingItemWidget({
    String title,
    bool isSelected = false,
    Function() action,
  }) : super(
          padding: EdgeInsets.all(offsetBase),
          child: InkWell(
            onTap: () => action(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        );
}

class MainDrawWidget extends StatelessWidget {
  final List<SegmentModel> models;
  final double scale;

  const MainDrawWidget({
    Key key,
    @required this.models,
    @required this.scale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var centerPosX = (-minPosX + itemDelta) / scale;
    var centerPosY = (-minPosY + itemDelta) / scale;

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          CustomPaint(
            painter: CircleDraw(
              Offset(centerPosX, centerPosY),
            ),
          ),
          for (var segment in models)
            CustomPaint(
              painter: LineDraw(
                Offset(centerPosX, centerPosY),
                Offset((segment.posX) / scale, (segment.posY) / scale),
              ),
            ),
        ],
      ),
    );
  }
}

class SegmentDrawWidget extends StatelessWidget {
  final double scale;
  final SegmentModel segment;

  const SegmentDrawWidget({
    Key key,
    this.scale,
    this.segment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          CustomPaint(
            painter: CircleDraw(
              Offset(segment.posX / scale, segment.posY / scale),
              color: segment.color.toColor(),
            ),
          ),
          for (var seg in segment.sub)
            CustomPaint(
              painter: LineDraw(
                Offset(segment.posX / scale, segment.posY / scale),
                Offset((seg.posX) / scale, (seg.posY) / scale),
                color: segment.color.toColor(),
              ),
            ),
        ],
      ),
    );
  }
}
