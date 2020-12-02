import 'dart:io';

import 'package:awesome_flutter/public/config/index.dart';
import 'package:awesome_flutter/public/factory/index.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/widgets.dart';

import '../ui/behavior/over_scroll_behavior.dart';

mixin UITools<T extends StatefulWidget> on State<T> implements _RouteGenerator, _NavigateActor, HandleRouteNavigate, RouteAware {

  ///屏幕宽度
  double screenWidth = ScreenUtil.getInstance().screenWidth;

  ///屏幕高度
  double screenHeight = ScreenUtil.getInstance().screenHeight;

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

//////////////////////////////////////////////////////
  ///页面出/入 监测
  //////////////////////////////////////////////////////
  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    handleDidPush();
  }

  @override
  void didPop() {
    handleDidPop();
  }

  @override
  void didPopNext() {
    handleDidPopNext();
  }

  @override
  void didPushNext() {
    handleDidPushNext();
  }

  /// [routeName]  => 你的页面类名
  @override
  PageRoute<T> buildRoute<T>(Widget page, String routeName,
      {PageAnimation animation = PageAnimation.Non, Object args}) {
    assert(routeName != null && routeName.isNotEmpty,
    'route name must be not empty !');
    var r = RouteSettings(name: routeName, arguments: args);

    switch (animation) {
      case PageAnimation.Fade:
        return pageBuilder.wrapWithFadeAnim(page, r);
      case PageAnimation.Scale:
        return pageBuilder.wrapWithScaleAnim(page, r);
      case PageAnimation.Slide:
        return pageBuilder.wrapWithSlideAnim(page, r);
      case PageAnimation.Non:
        return pageBuilder.wrapWithNoAnim(page, r);
      default:
        if(Platform.isAndroid){
          return pageBuilder.wrapWithAndroid(page, r);
        }else if(Platform.isIOS || Platform.isMacOS) {
          return pageBuilder.wrapWithIos(page, r);
        }else{
          return pageBuilder.wrapWithNoAnim(page, r);
        }
    }
  }

  ///@param animation : page transition's animation
  ///see details in [PageAnimationBuilder]
  @override
  Future push<T extends Widget>(T targetPage, {PageAnimation animation}) {
    assert(targetPage != null, 'the target page must not null !');
    FocusScope.of(context)?.unfocus();
    return Navigator.of(context).push(buildRoute(
        targetPage, targetPage.runtimeType.toString(),
        animation: animation));
  }

  @override
  Future pushReplacement<T extends Object, TO extends Widget>(TO targetPage,
      {PageAnimation animation, T result}) {
    assert(targetPage != null, 'the target page must not null !');
    FocusScope.of(context)?.unfocus();
    return Navigator.of(context).pushReplacement(
        buildRoute(
            targetPage, targetPage.runtimeType.toString(),
            animation: animation),
        result: result);
  }

  @override
  Future pushAndRemoveUntil<T extends Widget>(T targetPage,
      {PageAnimation animation, RoutePredicate predicate}) {
    assert(targetPage != null, 'the target page must not null !');
    FocusScope.of(context)?.unfocus();
    return Navigator.of(context).pushAndRemoveUntil(
        buildRoute(
            targetPage, targetPage.runtimeType.toString(),
            animation: animation),
        predicate ?? (route) => false);
  }

  @override
  void pop<T extends Object>({T result}) {
    FocusScope.of(context)?.unfocus();
    Navigator.of(context).pop(result);
  }

  @override
  void popUntil({RoutePredicate predicate}) {
    FocusScope.of(context)?.unfocus();
    Navigator.of(context).popUntil(predicate ?? (route) => false);
  }

  @override
  bool canPop() {
    return Navigator.of(context).canPop();
  }

  @override
  void handleDidPop() {
    debugPrint("已经pop的页面 ${this.runtimeType}");
  }

  @override
  void handleDidPush() {
    debugPrint("push后,显示的页面 ${this.runtimeType}");
  }

  @override
  void handleDidPopNext() {
    debugPrint("pop后，将要显示的页面 ${this.runtimeType}");
  }

  @override
  void handleDidPushNext() {
    debugPrint("push后，被遮挡的页面 ${this.runtimeType}");
  }

}


///构建 route

abstract class _RouteGenerator {
  PageRoute<T> buildRoute<T>(Widget page, String routeName,
      {PageAnimation animation, Object args});
}

///路由操作
abstract class _NavigateActor {
  Future push<T extends Widget>(T targetPage, {PageAnimation animation});

  Future pushAndRemoveUntil<T extends Widget>(T targetPage,
      {PageAnimation animation, RoutePredicate predicate});

  Future pushReplacement<T extends Object, TO extends Widget>(TO targetPage,
      {PageAnimation animation, T result});

  void pop<T extends Object>({
    T result,
  });

  void popUntil({RoutePredicate predicate});

  bool canPop();
}

abstract class HandleRouteNavigate {
  void handleDidPush();

  void handleDidPop();

  void handleDidPopNext();

  void handleDidPushNext();
}