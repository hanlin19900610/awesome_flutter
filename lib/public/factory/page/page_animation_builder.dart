import 'package:awesome_flutter/public/ui/anim/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///后期对此扩建

final PageAnimationBuilder pageBuilder = PageAnimationBuilder.getInstance();

enum PageAnimation { Fade, Scale, Slide, iOS, Android, Non }

class PageAnimationBuilder {
  static PageAnimationBuilder singleton;

  static PageAnimationBuilder getInstance() {
    if (singleton == null) {
      singleton = PageAnimationBuilder._();
    }
    return singleton;
  }

  PageAnimationBuilder._();

  /// ios
  Route<dynamic> wrapWithIos(Widget page, RouteSettings routeSettings) {
    return CupertinoPageRoute(builder: (context) => page, settings: routeSettings);
  }

  /// android
  Route<dynamic> wrapWithAndroid(Widget page, RouteSettings routeSettings) {
    return MaterialPageRoute(builder: (context) => page, settings: routeSettings);
  }

  ///
  Route<dynamic> wrapWithNoAnim(Widget page, RouteSettings routeSettings) {
    return NoAnimRouteBuilder(page, routeSettings);
  }

  ///fade
  Route<dynamic> wrapWithFadeAnim(Widget page, RouteSettings routeSettings) {
    return FadeRouteBuilder(page, routeSettings);
  }

  ///slide
  Route<dynamic> wrapWithSlideAnim(Widget page, RouteSettings routeSettings) {
    return SlideRightRouteBuilder(page, routeSettings);
  }

  Route<dynamic> wrapWithSlideTopAnim(
      Widget page, RouteSettings routeSettings) {
    return SlideTopRouteBuilder(page, routeSettings);
  }

  ///scale
  Route<dynamic> wrapWithScaleAnim(Widget page, RouteSettings routeSettings) {
    return ScaleRouteBuilder(page, routeSettings);
  }
}
