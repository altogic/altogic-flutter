import 'package:flutter/cupertino.dart';

/// Altogic navigator observer to track route changes and get the current
/// route's context.
///
/// When AltogicState is defined above Application(MaterialApp,CupertinoApp
/// etc.), AltogicState's context does not contain a Router. Therefore, the
/// static Navigator.of method will not find a Navigator and will throw an
/// error.
class AltogicNavigatorObserver extends NavigatorObserver {
  AltogicNavigatorObserver._();

  static final AltogicNavigatorObserver _instance =
      AltogicNavigatorObserver._();

  factory AltogicNavigatorObserver() => _instance;

  /// Current route's context
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
