part of altogic;

/// AltogicState is a [State] class that listens to initial links and provides
/// redirect actions via overridable methods:
///
/// - [onMagicLink]
/// - [onEmailVerificationLink]
/// - [onPasswordResetLink]
/// - [onEmailChangeLink]
/// - [onOauthProviderLink]
///
///
/// The methods are called only once when the initial link is received. Each
/// method is triggered with the [Redirect] instance and the current
/// [BuildContext]. The [Redirect] instance contains the link parameters:
/// [Redirect.action], [Redirect.error], [Redirect.status], and raw URL that
/// [Redirect] created from [Redirect.url].
///
/// If [Redirect.error] is not null, the process is invalid, and the [Redirect]
/// instance contains the error message. E.g., on the oAuth provider link, if
/// the user already exists with the same e-mail, the [Redirect.error] will
/// contain the error message, and the status will be between 400 and 599.
///
/// If [Redirect.status] is between 200-299, the process is valid, and the
/// action can be completed. [ChangeEmailRedirect] does not contain additional
/// property. So If the [Redirect.status] is 200, this means that the e-mail is
/// changed successfully.
///
/// The rest of the actions contains additional property
/// [RedirectWithToken.token] that can be used to complete the process. For more
/// information on how to complete the process, please see
/// [AltogicState.onMagicLink], [AltogicState.onEmailVerificationLink],
/// [AltogicState.onPasswordResetLink], and [AltogicState.onOauthProviderLink].
abstract class AltogicState<T extends StatefulWidget> extends State<T> {
  /// [AltogicNavigatorObserver] instance to track route changes and get the
  /// current route's context.
  NavigatorObserver get navigatorObserver => AltogicNavigatorObserver();

  /// This method is called when a magic link is launched.
  ///
  /// The [MagicLinkRedirect] is a [RedirectWithToken], and
  /// [RedirectWithToken.token] can be used to complete the process.
  ///
  /// To complete the process and log in to the user, use
  /// [AuthManager.getAuthGrant].
  ///
  /// If the token is valid, the user will be logged in, and
  /// [AuthManager.getAuthGrant] returns [UserSessionResult] that have
  /// properties [User] and [Session].
  ///
  /// You can get auth grant in this method, or you can route to a new page and
  /// get auth grant on that page.
  void onMagicLink(BuildContext? context, MagicLinkRedirect redirect) {}

  /// This method is called when an email verification link is launched.
  ///
  /// The [EmailVerificationRedirect] is a [RedirectWithToken], and
  /// [RedirectWithToken.token] can be used to complete the process.
  ///
  /// To complete the process and log in to the user, use
  /// [AuthManager.getAuthGrant].
  ///
  /// If the token is valid, the user will be logged in, and
  /// [AuthManager.getAuthGrant] returns [UserSessionResult] that have
  /// properties [User] and [Session].
  ///
  /// You can get auth grant in this method, or you can route to a new page and
  /// get auth grant on that page.
  void onEmailVerificationLink(
      BuildContext? context, EmailVerificationRedirect redirect) {}

  /// This method is called when a password reset link is launched.
  ///
  /// The [PasswordResetRedirect] is a [RedirectWithToken], and
  /// [RedirectWithToken.token] can be used to complete the process.
  ///
  /// To complete the process, use [AuthManager.resetPwdWithToken].
  ///
  /// If the token is valid, the user will be logged in and
  /// [AuthManager.resetPwdWithToken] returns null, otherwise returns
  /// [APIError].
  ///
  /// After changing the password user *NOT logged in*.
  ///
  /// You can show the change password dialog in this method or route to a new
  /// page and change the password on the page.
  void onPasswordResetLink(
      BuildContext? context, PasswordResetRedirect redirect) {}

  /// This method is called when an OAuth provider link is launched.
  ///
  /// The [OauthRedirect] is a [RedirectWithToken], and
  /// [RedirectWithToken.token] can be used to complete the process.
  ///
  /// To complete the process and log in to the user, use
  /// [AuthManager.getAuthGrant].
  ///
  /// If the token is valid, the user will be logged in, and
  /// [AuthManager.getAuthGrant] returns [UserSessionResult] that have
  /// properties [User] and [Session].
  ///
  /// You can get auth grant in this method, or you can route to a new page and
  /// get auth grant on that page.
  void onOauthProviderLink(BuildContext? context, OauthRedirect redirect) {}

  /// This method is called when an email change link is launched.

  /// If the [Redirect.status] is 200, the email has been successfully changed.

  /// You can show a dialog or route to a new page to inform the user. Or
  /// nothing.
  void onEmailChangeLink(BuildContext? context, ChangeEmailRedirect redirect) {}

  void _listenInitialLinks(_LinkConfiguration configuration) async {
    var initialLink = await AppLinks().getInitialAppLink();
    if (initialLink != null) {
      //_linkHandled = false;
      _handleLink(initialLink, configuration);
    }
    AppLinks().uriLinkStream.listen((e) {
      //_linkHandled = false;
      _handleLink(e, configuration);
    });
  }

  @mustCallSuper
  @override
  void initState() {
    _listenInitialLinks(_LinkConfiguration(
        onMagicLink: onMagicLink,
        onEmailVerificationLink: onEmailVerificationLink,
        onPasswordResetLink: onPasswordResetLink,
        onOauthProviderLink: onOauthProviderLink,
        onChangeEmailLink: onEmailChangeLink));
    super.initState();
  }

  /// Creates [Redirect] from the route in [WidgetsApp.onGenerateInitialRoutes].
  ///
  /// All links that open the application are handled by [AltogicState], and
  /// [AltogicState] checks whether the link has a "status" parameter or not to
  /// get the link is Altogic redirect link or not.
  Redirect? getWebRedirect(String? route) => Redirect._fromRoute(route);

  /// Get the application's initial link redirect. This method returns
  /// [Redirect] instance if the deep link (on the initial link in the web)
  /// is Altogic redirect link.
  ///
  /// It also returns null if the application is not launched by the deep link.
  static Future<Redirect?> get applicationInitialRedirect async =>
      Redirect._fromRoute((await AppLinks().getInitialAppLink()).toString());
}

void _handleLink(Uri uri, _LinkConfiguration configuration) async {
  if (uri.queryParameters['action'] == null) return;
  var context = AltogicNavigatorObserver().context;
  var e = Redirect._factory(uri);
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

class _LinkConfiguration {
  _LinkConfiguration(
      {this.onMagicLink,
      this.onEmailVerificationLink,
      this.onPasswordResetLink,
      this.onOauthProviderLink,
      required this.onChangeEmailLink});

  final void Function(BuildContext? context, MagicLinkRedirect redirect)?
      onMagicLink;
  final void Function(BuildContext? context, PasswordResetRedirect redirect)?
      onPasswordResetLink;
  final void Function(
          BuildContext? context, EmailVerificationRedirect redirect)?
      onEmailVerificationLink;
  final void Function(BuildContext? context, OauthRedirect redirect)?
      onOauthProviderLink;
  final void Function(BuildContext? context, ChangeEmailRedirect redirect)?
      onChangeEmailLink;
}

/// Redirect Action.
enum RedirectAction {
  /// Magic link action.
  magicLink('magic-link'),

  /// Email verification action.
  emailConfirm('email-confirm'),

  /// Password reset action.
  passwordReset('reset-pwd'),

  /// Oauth provider action.
  provider('oauth-signin'),

  /// Email change action.
  changeEmail('change-email');

  const RedirectAction(this.actionName);

  /// Action raw name.
  final String actionName;
}

/// Redirect action.
///
/// Redirect is used to hold information about the link that launched the application. Redirect is created from the link.
abstract class Redirect {
  Redirect._fromUri(Uri uri)
      : url = uri.toString(),
        _queryParameters = uri.queryParameters;

  factory Redirect._factory(Uri uri) {
    switch (uri.queryParameters['action']) {
      case 'magic-link':
        return MagicLinkRedirect._(uri);
      case 'email-confirm':
        return EmailVerificationRedirect._(uri);
      case 'reset-pwd':
        return PasswordResetRedirect._(uri);
      case 'oauth-signin':
        return OauthRedirect._(uri);
      case 'change-email':
        return ChangeEmailRedirect._(uri);
    }
    throw ArgumentError('Invalid redirect action');
  }

  static Redirect? _fromRoute(String? route) {
    if (route == null) return null;
    var uri = Uri.parse(route);
    if (uri.queryParameters.containsKey('action')) {
      return Redirect._factory(uri);
    }
    return null;
  }

  /// Raw url of the link that launched the application.
  final String url;
  final Map<String, dynamic> _queryParameters;

  /// Action of the link that launched the application.
  RedirectAction get action => RedirectAction.values.firstWhere(
      (e) => e.actionName == _queryParameters['action'],
      orElse: () => RedirectAction.magicLink);

  /// Error message of the link that launched the application.
  String? get error => _queryParameters['error'] as String?;

  /// Status of the link that launched the application.
  /// Status can be between 200-599
  String get status => _queryParameters['status'] as String;
}

/// Redirect implementations contains [token]
class RedirectWithToken extends Redirect {
  RedirectWithToken._(Uri url) : super._fromUri(url);

  /// access_token parameter of the link that launched the application.
  String get token => _queryParameters['access_token'] as String;
}

abstract class RedirectToGetAuth extends RedirectWithToken {
  RedirectToGetAuth._(Uri url) : super._(url);
}

/// Oauth redirect is used to hold information about the link that
/// launched the application. Oauth redirect is created from the link.
class OauthRedirect extends RedirectToGetAuth {
  OauthRedirect._(Uri url) : super._(url);
}

/// Magic link redirect is used to hold information about the link that
/// launched the application. Magic link redirect is created from the link.
class MagicLinkRedirect extends RedirectToGetAuth {
  MagicLinkRedirect._(Uri url) : super._(url);
}

/// Email verification redirect is used to hold information about the link that
/// launched the application. Email verification redirect is created from the
/// link.
class EmailVerificationRedirect extends RedirectToGetAuth {
  EmailVerificationRedirect._(Uri url) : super._(url);
}

/// Password reset redirect is used to hold information about the link that
/// launched the application. Password reset redirect is created from the link.
class PasswordResetRedirect extends RedirectWithToken {
  PasswordResetRedirect._(Uri url) : super._(url);
}

/// Change email redirect is used to hold information about the link that
/// launched the application. Change email redirect is created from the link.
class ChangeEmailRedirect extends Redirect {
  ChangeEmailRedirect._(Uri url) : super._fromUri(url);
}
