import 'package:flustars/flustars.dart';

/// 屏幕适配封装
extension SizeExtension on num {
  ///[ScreenUtil.getWidth]
  num get w => ScreenUtil().getWidth(this.toDouble());

  ///[ScreenUtil.getHeight]
  num get h => ScreenUtil().getHeight(this.toDouble());

  ///[ScreenUtil.getSp]
  num get sp => ScreenUtil().getSp(this.toDouble());
}
