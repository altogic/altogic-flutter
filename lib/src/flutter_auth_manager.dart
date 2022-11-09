part of altogic;

/// AuthManager for Flutter
///
/// This class is used to manage deep linking.
class FlutterAuthManager extends AuthManager {
  FlutterAuthManager(super.client);

  /// Sign in with a provider using Flutter
  ///
  /// This method will open a browser window to sign in with the provider.
  ///
  /// [provider] is the provider to sign in with.
  ///
  /// If you want to open it manually, you can get the link by using
  /// [signInWithProvider].
  ///
  /// [completer] is the completer to complete when the url launching is done.
  @override
  String signInWithProvider(String provider, [Completer<bool>? completer]) {
    var link = signInWithProvider(provider);
    launchUrl(Uri.parse(link),
            webOnlyWindowName: '_self',
            mode: LaunchMode.externalApplication,
            webViewConfiguration: const WebViewConfiguration(
                headers: {'OverrideUserAgent': 'Mozilla/5.0 Google'}))
        .then((value) {
      completer?.complete(value);
    }).onError((error, stackTrace) {
      completer?.completeError(error ?? Exception(), stackTrace);
    });
    return link;
  }

  /// [getAuthGrant] using Flutter
  ///
  /// This methods checks if application is opened with a link. If it is, it
  /// will get the auth grant and return it.
  ///
  /// Also checks auth grant was already gotten with the same accessToken. So,
  /// if you call this method twice with the same accessToken, it will return
  /// the same result.
  ///
  /// Even if [AltogicClient.restoreAuthSession] was gotten auth grant,
  /// "AuthState.onX" will still be executed. In this case, re-granting auth
  /// may cause this secondary call. In both these cases this method will return
  /// the same result if the same access_token is used.
  @override
  Future<UserSessionResult> getAuthGrant([String? accessToken]) async {
    if (_authGrantUsed == accessToken && currentState.isLoggedIn) {
      return UserSessionResult(
          user: currentState.user, session: currentState.session);
    }

    if (accessToken != null) {
      _authGrantUsed = accessToken;
      return super.getAuthGrant(accessToken);
    }

    var redirect =
        Redirect._fromRoute(await AppLinks().getInitialAppLinkString());

    if (redirect is RedirectWithToken && redirect.error == null) {
      if (_authGrantUsed == redirect.token && currentState.isLoggedIn) {
        return UserSessionResult(
            user: currentState.user, session: currentState.session);
      }
      _authGrantUsed = redirect.token;
      return super.getAuthGrant(redirect.token);
    }

    return super.getAuthGrant();
  }

  String? _authGrantUsed;
}
