import 'package:awesome_flutter/public/ui/behavior/index.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Stateless widget 继承此类
abstract class BaseStatelessWidget extends StatelessWidget {

  ///屏幕宽度
  final double screenWidth = ScreenUtil.getInstance().screenWidth;

  ///屏幕高度
  final double screenHeight = ScreenUtil.getInstance().screenHeight;

  ///去掉 scroll view的 水印  e.g : listView scrollView
  ///当滑动到顶部或者底部时，继续拖动出现的蓝色水印
  Widget getNoInkWellListView({@required Widget scrollView}) {
    return ScrollConfiguration(
      behavior: OverScrollBehavior(),
      child: scrollView,
    );
  }

  ///占位widget
  Widget getWidthBox(double width) {
    return SizedBox(
      width: width,
      height: 1,
    );
  }

  Widget getHeightBox(double height) {
    return SizedBox(
      width: 1,
      height: height,
    );
  }

}
