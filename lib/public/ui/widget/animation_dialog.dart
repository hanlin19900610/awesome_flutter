import 'package:flutter/material.dart';

enum TransitionType {
  inFromLeft,
  inFromRight,
  inFromTop,
  inFromBottom,
  scale,
  fade,
  rotation,
  size,
}

Future<T> showAnimationDialog<T>({
  @required BuildContext context,
  bool barrierDismissible = true,
  @Deprecated('') Widget child,
  WidgetBuilder builder,
  bool useRootNavigator = true,
  RouteSettings routeSettings,
  TransitionType transitionType,
}) {
  assert(child == null || builder == null);
  assert(useRootNavigator != null);
  assert(debugCheckHasMaterialLocalizations(context));

  final ThemeData theme = Theme.of(context, shadowThemeOnly: true);
  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      final Widget pageChild = child ?? Builder(builder: builder);
      return SafeArea(
        child: Builder(builder: (BuildContext context) {
          return theme != null
              ? Theme(data: theme, child: pageChild)
              : pageChild;
        }),
      );
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 200),
    transitionBuilder: (context, animation1, animation2, child) {
      return _buildDialogTransitions(
          context, animation1, animation2, child, transitionType);
    },
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
  );
}

Widget _buildDialogTransitions(
    BuildContext context,
    Animation<double> animaton1,
    Animation<double> secondaryAnimation,
    Widget child,
    TransitionType type) {
  if (type == TransitionType.fade) {
    // 渐变效果
    return FadeTransition(
      // 从0开始到1
      opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        // 传入设置的动画
        parent: animaton1,
        // 设置效果，快进漫出   这里有很多内置的效果
        curve: Curves.fastOutSlowIn,
      )),
      child: child,
    );
  } else if (type == TransitionType.scale) {
    return ScaleTransition(
      scale: Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animaton1, curve: Curves.fastOutSlowIn)),
      child: child,
    );
  } else if (type == TransitionType.rotation) {
    // 旋转加缩放动画效果
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animaton1,
        curve: Curves.fastOutSlowIn,
      )),
      child: ScaleTransition(
        scale: Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animaton1, curve: Curves.fastOutSlowIn)),
        child: child,
      ),
    );
  } else if (type == TransitionType.inFromLeft) {
    // 左右滑动动画效果
    return SlideTransition(
      position: Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))
          .animate(
              CurvedAnimation(parent: animaton1, curve: Curves.fastOutSlowIn)),
      child: child,
    );
  } else if (type == TransitionType.inFromRight) {
    return SlideTransition(
      position: Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
          .animate(
              CurvedAnimation(parent: animaton1, curve: Curves.fastOutSlowIn)),
      child: child,
    );
  } else if (type == TransitionType.inFromTop) {
    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))
          .animate(
              CurvedAnimation(parent: animaton1, curve: Curves.fastOutSlowIn)),
      child: child,
    );
  } else if (type == TransitionType.inFromBottom) {
    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
          .animate(
              CurvedAnimation(parent: animaton1, curve: Curves.fastOutSlowIn)),
      child: child,
    );
  } else if (type == TransitionType.size) {
    return SizeTransition(
      child: child,
      sizeFactor: Tween<double>(begin: 0.1, end: 1.0)
          .animate(CurvedAnimation(parent: animaton1, curve: Curves.linear)),
    );
  } else {
    return child;
  }
}
