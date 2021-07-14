import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zure/themes/dimens.dart';
import 'package:zure/utils/constants.dart';
import 'package:zure/utils/params.dart';
import 'package:zure/sevices/extensions.dart';

class SegmentModel {
  String id;
  String title;
  String color;
  List<SegmentModel> sub = [];

  bool isExpanded = false;
  bool isShow = false;
  double posX = 0.0;
  double posY = 0.0;
  double posSX = 0.0;
  double posSY = 0.0;

  SegmentModel({
    this.id,
    this.title,
    this.color,
    this.sub,
  });

  factory SegmentModel.fromMap(Map<String, dynamic> map) {
    var jsonArray = map['sub'];
    List<SegmentModel> models = [];
    for (var json in jsonArray) {
      var model = SegmentModel.fromMap(json);
      models.add(model);
    }
    return new SegmentModel(
      id: map['id'] as String,
      title: map['title'] as String,
      color: map['color'] as String,
      sub: models,
    );
  }

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

  void resetPosition({
    double posX = 0.0,
    double posY = 0.0,
    int index = 0,
    bool isFull = false,
    @required int size,
    double startDegree = 0.0,
  }) {
    posSX = posX;
    posSY = posY;
    double degree = 0.0;
    if (isFull) {
      degree = -pi / 2 + index * (2 * pi / size);
    } else {
      degree = startDegree + index * (pi / size) + pi / 2.0 / size;
    }
    this.posX = posSX + cos(degree) * circleRadius;
    this.posY = posSY + sin(degree) * circleRadius;

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

    if (minPosX > this.posX) {
      minPosX = this.posX;
    }
    if (minPosY > this.posY) {
      minPosY = this.posY;
    }
    if (maxPosX < this.posX) {
      maxPosX = this.posX;
    }
    if (maxPosY < this.posY) {
      maxPosY = this.posY;
    }

    for (var segment in sub) {
      segment.resetPosition(
        posX: this.posX,
        posY: this.posY,
        index: sub.indexOf(segment),
        size: sub.length,
        startDegree: angle,
      );
    }
  }

  void offSet(double x, double y) {
    posX = posX - x + itemDelta;
    posY = posY - y + itemDelta;
    posSX = posSX - x + itemDelta;
    posSY = posSY - y + itemDelta;
  }

  void setChangeVisible(bool flag) {
    isShow = flag;
    if (!isShow) {
      setChangeExpanded(false);
    }
  }

  void setChangeExpanded(bool flag) {
    isExpanded = flag;
    for (var segment in sub) {
      segment.isShow = flag;
      if (!flag) {
        segment.setChangeExpanded(false);
      }
    }
  }

  static List<SegmentModel> getFriendSegment(SegmentModel model, List<SegmentModel> allItems) {
    print('[Segment] selected id: ${model.toDataMap()}');
    if (model.id.length == 1) {
      return [];
    }
    String parentId = model.id.substring(0, model.id.length - 1);
    print('[Segment] parent id: $parentId');
    var parentSegment = SegmentModel();
    for (var segment in allItems) {
      if (segment.id == parentId) {
        parentSegment = segment;
        break;
      }
    }
    return parentSegment.sub;
  }

  Widget circleWidget(double scale, {Function() action,}) {
    return AnimatedPositioned(
      top: isShow
          ? (posY - itemHeight / 2.0) / scale
          : (posSY - itemHeight / 2.0) / scale,
      left: isShow
          ? (posX - itemWidth / 2.0) / scale
          : (posSX - itemWidth / 2.0) / scale,
      duration: Duration(milliseconds: isShow? duringAnimation : 0),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: isShow? duringAnimation : 0),
        opacity: isShow? 1: 0,
        child: InkWell(
          onTap: () => isShow? action() : null,
          child: Container(
            width: itemWidth / scale,
            height: itemHeight / scale,
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: color.toColor(),
              border: Border.all(color: Colors.black, width: 0.5),
              borderRadius: BorderRadius.all(
                  Radius.circular(itemHeight / 3.0 / scale)),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: fontNormal - scale,
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
