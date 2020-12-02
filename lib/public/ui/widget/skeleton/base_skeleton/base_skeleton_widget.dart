/*
* Author : LiJiqqi
* Date : 2020/4/24
*/

import 'package:awesome_flutter/public/widget_state/index.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

///骨架屏 建议用stateless

abstract class BaseSkeletonWidget extends BaseStatelessWidget {

  ///确保全局骨架 颜色一致
  final Color skeletonColor = Color.fromRGBO(221, 221, 221, 1);
  final Color baseColor = Color(0xFFE0E0E0);
  final Color highLightColor = Color(0xFFF5F5F5);

  bool _enabled = true;

  ///自动给child 增加 闪闪亮特效！
  Widget getShimmer(Widget child) {
    return Shimmer(
      gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            baseColor,
            baseColor,
            highLightColor,
            baseColor,
            baseColor
          ],
          stops: const <double>[
            0.0,
            0.35,
            0.5,
            0.65,
            1.0
          ]),
      enabled: _enabled,
      child: child,
    );
  }
}
