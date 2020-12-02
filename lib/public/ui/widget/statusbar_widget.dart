import 'dart:ui';

import 'package:flutter/material.dart';
/// 封装沉浸式状态下, 设置标题栏下移状态栏高度
/// 以Colum纵向排列
/// 包含一个Child
class StatusBarWidget extends StatelessWidget {
  final Widget child;
  final CrossAxisAlignment crossAxisAlignment;
  const StatusBarWidget(
      {Key key,
      @required this.child,

      this.crossAxisAlignment = CrossAxisAlignment.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQueryData.fromWindow(window).padding.top;
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: <Widget>[
        Container(
          height: statusBarHeight,
        ),
        child
      ],
    );
  }
}
