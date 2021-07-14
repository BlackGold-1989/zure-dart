import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zure/utils/constants.dart';

class LineDotDraw extends CustomPainter {
  final Offset p1;
  final Offset p2;
  final Color color;

  LineDotDraw(
    this.p1,
    this.p2, {
    this.color = Colors.black,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = stroke;

    Offset deltaP = p2 - p1;
    double stepX = deltaP.dx / (100 / (lineDotWidth + lineDotSpace));
    double stepY = deltaP.dy / (100 / (lineDotWidth + lineDotSpace));
    for (var i = 0; i < 100 / (lineDotWidth + lineDotSpace); i++) {
      Offset op1 = Offset(p1.dx + stepX * i, p1.dy + stepY * i);
      Offset op2 = Offset(
          p1.dx +
              stepX * i +
              stepX / (lineDotWidth + lineDotSpace) * lineDotWidth,
          p1.dy +
              stepY * i +
              stepY / (lineDotWidth + lineDotSpace) * lineDotWidth);
      canvas.drawLine(op1, op2, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

class CircleDotDraw extends CustomPainter {
  final Offset p;
  final Color color;

  CircleDotDraw(
    this.p, {
    this.color = Colors.black,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.2)
      ..strokeWidth = 0.5;

    double stepDegree = 2 * pi / (628 / (lineDotWidth + lineDotSpace));
    double radius = circleRadius - itemDelta;
    for (var i = 0; i < 628 / (lineDotWidth + lineDotSpace); i++) {
      double startDegree = i * stepDegree;
      double endDegree = startDegree +
          stepDegree / (lineDotWidth + lineDotSpace) * lineDotWidth;

      Offset op1 = Offset(p.dx + radius * cos(startDegree),
          p.dy + radius * sin(startDegree));
      Offset op2 = Offset(p.dx + radius * cos(endDegree),
          p.dy + radius * sin(endDegree));

      canvas.drawLine(op1, op2, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

class LineDraw extends CustomPainter {
  final Offset p1;
  final Offset p2;
  final Color color;

  LineDraw(
      this.p1,
      this.p2, {
        this.color = Colors.black,
      });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
