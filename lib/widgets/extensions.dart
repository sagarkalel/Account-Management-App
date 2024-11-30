import 'package:flutter/material.dart';

extension NumExtensions on num {
  Duration get second => Duration(seconds: round());
  Duration get microSec => Duration(microseconds: round());
  Duration get milliSec => Duration(milliseconds: round());
}

extension WidgetExtensions on Widget {
  Widget get expand => Expanded(child: this);
  Widget get padXX16 =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: this);
  Widget padYY(double y) =>
      Padding(padding: EdgeInsets.symmetric(vertical: y), child: this);

  Widget padRight(double x) =>
      Padding(padding: EdgeInsets.only(right: x), child: this);
  Widget padLeft(double x) =>
      Padding(padding: EdgeInsets.only(left: x), child: this);
  Widget padTop(double x) =>
      Padding(padding: EdgeInsets.only(top: x), child: this);
  Widget padBottom(double x) =>
      Padding(padding: EdgeInsets.only(bottom: x), child: this);

  Widget padAll(double v) => Padding(padding: EdgeInsets.all(v), child: this);
}

extension StyleExtensions on TextStyle {
  TextStyle get makeBold => copyWith(fontWeight: FontWeight.w600);
}
