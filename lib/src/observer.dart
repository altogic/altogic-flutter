import 'package:flutter/cupertino.dart';

class AltogicNavigatorObserver extends NavigatorObserver {
  AltogicNavigatorObserver._();

  static final AltogicNavigatorObserver _instance =
      AltogicNavigatorObserver._();

  factory AltogicNavigatorObserver() => _instance;

  BuildContext? context;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    context = route.navigator?.context;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    context = route.navigator?.context;
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    context = route.navigator?.context;
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    context = newRoute?.navigator?.context;
  }
}
