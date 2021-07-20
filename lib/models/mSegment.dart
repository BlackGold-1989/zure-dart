import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zure/themes/thDimens.dart';
import 'package:zure/scripts/scConstants.dart';
import 'package:zure/scripts/scParams.dart';
import 'package:zure/services/svExtensions.dart';

class ZureSegmentModel {
  // That field name should be same with backend field name. So that can't change that.
  // If you want to change that fields, you need to change the server key also.
  String id;
  String title;
  String color;
  List<ZureSegmentModel> sub = [];

  bool isExpanded = false;
  bool isShow = false;
  double posX = 0.0;
  double posY = 0.0;
  double posSX = 0.0;
  double posSY = 0.0;

  ZureSegmentModel({
    this.id,
    this.title,
    this.color,
    this.sub,
  });

  // That function is used like override function, but not override function. So that I recommend to not change for that function name.
  factory ZureSegmentModel.fromMap(Map<String, dynamic> map) {
    var jsonArray = map['sub'];
    List<ZureSegmentModel> models = [];
    for (var json in jsonArray) {
      var model = ZureSegmentModel.fromMap(json);
      models.add(model);
    }
    return new ZureSegmentModel(
      id: map['id'] as String,
      title: map['title'] as String,
      color: map['color'] as String,
      sub: models,
    );
  }

  // That function is used like override function, but not override function. So that I recommend to not change for that function name.
  Map<String, dynamic> toMap() {
    var jsonArray = [];
    for (var segment in sub) {
      jsonArray.add(segment.toMap());
    }
    return {
      'id': this.id,
      'title': this.title,
      'color': this.color,
      'sub': jsonArray,

      'isExpanded': this.isExpanded,
      'posX': this.posX,
      'posY': this.posY,
      'posSX': this.posSX,
      'posSY': this.posSY,
    };
  }

  // That function is used like override function, but not override function. So that I recommend to not change for that function name.
  Map<String, dynamic> toDataMap() {
    return {
      'id': this.id,
      'title': this.title,
      'color': this.color,
      'isExpanded': this.isExpanded,
      'posX': this.posX,
      'posY': this.posY,
      'posSX': this.posSX,
      'posSY': this.posSY,
    };
  }

  void zureResetCirclePosition({
    double dPosX = 0.0,
    double dPosY = 0.0,
    int dIndex = 0,
    bool bFull = false,
    @required int dSize,
    double dStartDegree = 0.0,
  }) {
    posSX = dPosX;
    posSY = dPosY;
    double degree = 0.0;
    if (bFull) {
      degree = -pi / 2 + dIndex * (2 * pi / dSize);
    } else {
      degree = dStartDegree + dIndex * (pi / dSize) + pi / 2.0 / dSize;
    }
    this.posX = posSX + cos(degree) * cdCircleRadius;
    this.posY = posSY + sin(degree) * cdCircleRadius;

    double angle = atan((posSX - this.posX) / (this.posY - posSY));
    if (angle > 0) {
      if (this.posY < posSY) {
        angle = angle + pi;
      }
    } else {
      if (posSY > this.posY) {
        angle = angle + pi;
      }
    }

    if (cpMinPosX > this.posX) {
      cpMinPosX = this.posX;
    }
    if (cpMinPosY > this.posY) {
      cpMinPosY = this.posY;
    }
    if (cpMaxPosX < this.posX) {
      cpMaxPosX = this.posX;
    }
    if (cpMaxPosY < this.posY) {
      cpMaxPosY = this.posY;
    }

    for (var segment in sub) {
      segment.zureResetCirclePosition(
        dPosX: this.posX,
        dPosY: this.posY,
        dIndex: sub.indexOf(segment),
        dSize: sub.length,
        dStartDegree: angle,
      );
    }
  }

  void zureResetLinearPosition({
    double dPosX = 0.0,
    double dPosY = 0.0,
    int dIndex = 0,
    @required int dSize,
  }) {
    posSX = dPosX;
    posSY = dPosY;
    double subWidth = (cdLinearPadding + cdItemWidth) * dSize;
    double subHeight = cdItemHeight;

    this.posX = posSX - subWidth / 2 + cdLinearPadding / 2 + cdItemWidth / 2 + dIndex * (cdItemWidth + cdLinearPadding);
    this.posY = posSY + subHeight + cdItemHeight;

    if (cpMinPosX > this.posX) {
      cpMinPosX = this.posX;
    }
    if (cpMinPosY > this.posY) {
      cpMinPosY = this.posY;
    }
    if (cpMaxPosX < this.posX) {
      cpMaxPosX = this.posX;
    }
    if (cpMaxPosY < this.posY) {
      cpMaxPosY = this.posY;
    }

    for (var segment in sub) {
      segment.zureResetLinearPosition(
        dPosX: this.posX,
        dPosY: this.posY,
        dIndex: sub.indexOf(segment),
        dSize: sub.length,
      );
    }
  }

  void zureOffSet(double x, double y) {
    posX = posX - x;
    posY = posY - y;
    posSX = posSX - x;
    posSY = posSY - y;
  }

  void zureSetChangeVisible(bool flag) {
    isShow = flag;
    if (!isShow) {
      zureSetChangeExpanded(false);
    }
  }

  void zureSetChangeExpanded(bool flag) {
    isExpanded = flag;
    for (var segment in sub) {
      segment.isShow = flag;
      if (!flag) {
        segment.zureSetChangeExpanded(false);
      }
    }
  }

  static List<ZureSegmentModel> zureGetFriendSegment(ZureSegmentModel mSegment, List<ZureSegmentModel> lAllItems) {
    print('[Segment] selected id: ${mSegment.toDataMap()}');
    if (mSegment.id.length == 1) {
      return [];
    }
    String parentId = mSegment.id.substring(0, mSegment.id.length - 1);
    print('[Segment] parent id: $parentId');
    var parentSegment = ZureSegmentModel();
    for (var segment in lAllItems) {
      if (segment.id == parentId) {
        parentSegment = segment;
        break;
      }
    }
    return parentSegment.sub;
  }

  Widget zureCircleWidget(double dScale, {Function() fAction,}) {
    return AnimatedPositioned(
      top: isShow
          ? (posY - cdItemHeight / 2.0) / dScale
          : (posSY - cdItemHeight / 2.0) / dScale,
      left: isShow
          ? (posX - cdItemWidth / 2.0) / dScale
          : (posSX - cdItemWidth / 2.0) / dScale,
      duration: Duration(milliseconds: isShow? cdDuringAnimation : 0),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: isShow? cdDuringAnimation : 0),
        opacity: isShow? 1: 0,
        child: InkWell(
          onTap: () => isShow? fAction() : null,
          child: Container(
            width: cdItemWidth / dScale,
            height: cdItemHeight / dScale,
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: color.toColor(),
              border: Border.all(color: Colors.black, width: 0.5),
              borderRadius: BorderRadius.all(
                  Radius.circular(cdItemHeight / 3.0 / dScale)),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: tdFontNormal - dScale,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget zureLinearWidget(double dScale, {Function() fAction,}) {
    return Positioned(
      top: (posY - cdItemHeight / 2.0) / dScale,
      left: (posX - cdItemWidth / 2.0) / dScale,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: isShow? cdDuringAnimation : 0),
        opacity: isShow? 1: 0,
        child: InkWell(
          onTap: () => isShow? fAction() : null,
          child: Container(
            width: cdItemWidth / dScale,
            height: cdItemHeight / dScale,
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: color.toColor(),
              border: Border.all(color: Colors.black, width: 0.5),
              borderRadius: BorderRadius.all(
                  Radius.circular(cdItemHeight / 3.0 / dScale)),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: tdFontNormal - dScale,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

}
