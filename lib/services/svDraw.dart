import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zure/scripts/scConstants.dart';

class ZureLineDotDraw extends CustomPainter {
  final Offset oP1;
  final Offset oP2;
  final Color cColor;

  ZureLineDotDraw(
    this.oP1,
    this.oP2, {
    this.cColor = Colors.black,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = cColor
      ..strokeWidth = cdStroke;

    Offset deltaP = oP2 - oP1;
    double stepX = deltaP.dx / (100 / (cdLineDotWidth + cdLineDotSpace));
    double stepY = deltaP.dy / (100 / (cdLineDotWidth + cdLineDotSpace));
    for (var i = 0; i < 100 / (cdLineDotWidth + cdLineDotSpace); i++) {
      Offset op1 = Offset(oP1.dx + stepX * i, oP1.dy + stepY * i);
      Offset op2 = Offset(
          oP1.dx +
              stepX * i +
              stepX / (cdLineDotWidth + cdLineDotSpace) * cdLineDotWidth,
          oP1.dy +
              stepY * i +
              stepY / (cdLineDotWidth + cdLineDotSpace) * cdLineDotWidth);
      canvas.drawLine(op1, op2, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

class ZureCircleDotDraw extends CustomPainter {
  final Offset oPosition;
  final Color cColor;
  final double dScale;

  ZureCircleDotDraw(
    this.oPosition, {
    this.cColor = Colors.black,
    this.dScale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = cColor.withOpacity(0.2)
      ..strokeWidth = 0.5;

    double stepDegree = 2 * pi / (628 / (cdLineDotWidth + cdLineDotSpace));
    double radius = cdCircleRadius / dScale;
    for (var i = 0; i < 628 / (cdLineDotWidth + cdLineDotSpace); i++) {
      double startDegree = i * stepDegree;
      double endDegree = startDegree +
          stepDegree / (cdLineDotWidth + cdLineDotSpace) * cdLineDotWidth;

      Offset op1 = Offset(oPosition.dx + radius * cos(startDegree),
          oPosition.dy + radius * sin(startDegree));
      Offset op2 = Offset(oPosition.dx + radius * cos(endDegree),
          oPosition.dy + radius * sin(endDegree));

      canvas.drawLine(op1, op2, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

class ZureLineDraw extends CustomPainter {
  final Offset oP1;
  final Offset oP2;
  final Color cColor;

  ZureLineDraw(
    this.oP1,
    this.oP2, {
    this.cColor = Colors.black,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = cColor
      ..strokeWidth = 1.0;

    canvas.drawLine(oP1, oP2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
