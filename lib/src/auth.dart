import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../altogic_flutter.dart';
import 'observer.dart';

abstract class AltogicState<T extends StatefulWidget> extends State<T> {
  NavigatorObserver get navigatorObserver => AltogicNavigatorObserver();

  void onMagicLink(BuildContext? context, MagicLinkRedirect redirect) {}

  void onEmailVerificationLink(
      BuildContext? context, EmailVerificationRedirect redirect) {}

  void onPasswordResetLink(
      BuildContext? context, PasswordResetRedirect redirect) {}

  void onOauthProviderLink(BuildContext? context, OauthRedirect redirect) {}

  void onEmailChangeLink(BuildContext? context, ChangeEmailRedirect redirect) {}

  String? get webRedirectUrl => null;

  void _listenInitialLinks(LinkConfiguration configuration) async {
    var initialLink = await AppLinks().getInitialAppLink();
    if (initialLink != null) {
      _handleLink(initialLink, configuration);
    }
    AppLinks().uriLinkStream.listen((e) {
      _handleLink(e, configuration);
    });
  }

  @mustCallSuper
  @override
  void initState() {
    _listenInitialLinks(LinkConfiguration(
        onMagicLink: onMagicLink,
        onEmailVerificationLink: onEmailVerificationLink,
        onPasswordResetLink: onPasswordResetLink,
        onOauthProviderLink: onOauthProviderLink,
        onChangeEmailLink: onEmailChangeLink,
        webRedirectUrl: webRedirectUrl));
    super.initState();
  }

  Redirect? getWebRedirect(String? route) {
    var event = Redirect.fromRoute(route);
    if (event != null &&
        webRedirectUrl != null &&
        !event.url.startsWith(webRedirectUrl!)) {
      return event;
    }
    return null;
  }
}

void _handleLink(Uri uri, LinkConfiguration configuration) {
  if (kIsWeb) {
    return;
  }
  var context = AltogicNavigatorObserver().context;
  var e = Redirect.fromUri(uri);
  switch (e.action) {
    case RedirectAction.emailConfirm:
      configuration.onEmailVerificationLink
          ?.call(context, e as EmailVerificationRedirect);
      break;
    case RedirectAction.provider:
      configuration.onOauthProviderLink?.call(context, e as OauthRedirect);
      break;
    case RedirectAction.passwordReset:
      configuration.onPasswordResetLink
          ?.call(context, e as PasswordResetRedirect);
      break;
    case RedirectAction.magicLink:
      configuration.onMagicLink?.call(context, e as MagicLinkRedirect);
      break;
    case RedirectAction.changeEmail:
      configuration.onChangeEmailLink?.call(context, e as ChangeEmailRedirect);
      break;
  }
}

class LinkConfiguration {
  LinkConfiguration(
      {this.onMagicLink,
      this.onEmailVerificationLink,
      this.onPasswordResetLink,
      this.onOauthProviderLink,
      required this.onChangeEmailLink,
      this.webRedirectUrl});

  final String? webRedirectUrl;

  void Function(BuildContext? context, MagicLinkRedirect redirect)? onMagicLink;
  void Function(BuildContext? context, PasswordResetRedirect redirect)?
      onPasswordResetLink;
  void Function(BuildContext? context, EmailVerificationRedirect redirect)?
      onEmailVerificationLink;
  void Function(BuildContext? context, OauthRedirect redirect)?
      onOauthProviderLink;
  void Function(BuildContext? context, ChangeEmailRedirect redirect)?
      onChangeEmailLink;
}

enum RedirectAction {
  magicLink('magic-link'),
  emailConfirm('email-confirm'),
  passwordReset('reset-pwd'),
  provider('oauth-signin'),
  changeEmail('change-email');

  const RedirectAction(this.actionName);

  final String actionName;
}

abstract class Redirect {
  Redirect(this.url) : _queryParameters = Uri.parse(url).queryParameters;

  Redirect._fromUri(Uri uri)
      : url = uri.toString(),
        _queryParameters = uri.queryParameters;

  factory Redirect.fromUri(Uri uri) {
    switch (uri.queryParameters['action']) {
      case 'magic-link':
        return MagicLinkRedirect(uri);
      case 'email-confirm':
        return EmailVerificationRedirect(uri);
      case 'reset-pwd':
        return PasswordResetRedirect(uri);
      case 'oauth-signin':
        return OauthRedirect(uri);
      case 'change-email':
        return ChangeEmailRedirect(uri);
    }
    throw ArgumentError('Invalid redirect action');
  }

  static Redirect? fromRoute(String? route) {
    if (route == null) return null;
    var uri = Uri.parse(route);
    if (uri.queryParameters.containsKey('action')) {
      return Redirect.fromUri(uri);
    }
    return null;
  }

  final String url;
  final Map<String, dynamic> _queryParameters;

  RedirectAction get action => RedirectAction.values.firstWhere(
      (e) => e.actionName == _queryParameters['action'],
      orElse: () => RedirectAction.magicLink);

  String? get error => _queryParameters['error'] as String?;

  String get status => _queryParameters['status'] as String;
}

class RedirectWithToken extends Redirect {
  RedirectWithToken(Uri url) : super._fromUri(url);

  String get token => _queryParameters['access_token'] as String;
}

class OauthRedirect extends RedirectWithToken {
  OauthRedirect(Uri url) : super(url);
}

class MagicLinkRedirect extends RedirectWithToken {
  MagicLinkRedirect(Uri url) : super(url);
}

class EmailVerificationRedirect extends RedirectWithToken {
  EmailVerificationRedirect(Uri url) : super(url);
}

class PasswordResetRedirect extends RedirectWithToken {
  PasswordResetRedirect(Uri url) : super(url);
}

class ChangeEmailRedirect extends Redirect {
  ChangeEmailRedirect(Uri url) : super._fromUri(url);
}
