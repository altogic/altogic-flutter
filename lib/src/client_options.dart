part of altogic;

/// Client options for Flutter.
class ClientOptions extends dart.ClientOptions {
  /// In addition to [ClientOptions], this class adds [BuildContext] to
  /// [signInRedirect].
  ///
  /// If [AltogicState] is used above [MaterialApp] or [WidgetsApp] etc., and
  /// [AltogicState.navigatorObserver] is used, the [BuildContext] will be
  /// automatically set.
  ///
  /// If [AltogicState] is not used, the [BuildContext] will be null.
  ClientOptions(
      {super.apiKey,
      super.localStorage,
      super.realtime,
      void Function(BuildContext? context)? signInRedirect})
      : super(
          signInRedirect: signInRedirect == null
              ? null
              : () {
                  signInRedirect(AltogicNavigatorObserver().context);
                },
        );
}
