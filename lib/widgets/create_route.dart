import 'package:flutter/material.dart';

///Constructing page route builder in order to navigate to other [Route] with
///custom [SlideTransition] animation instead of default animation.
Route<String> createRoute(Widget widget) {
  return PageRouteBuilder(
    pageBuilder: (_, animation, secondaryAnimation) => widget,
    transitionsBuilder: (_, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      var curve = Curves.bounceInOut;
      final tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
