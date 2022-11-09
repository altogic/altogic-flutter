# Altogic Dart

Altogic Dart is a Dart client for the Altogic Client Library. It provides access to all the functionality of the Altogic
Client Library.

This package includes some Flutter dependencies in addition to the [altogic_dart](https://pub.dev/packages/altogic_dart)
package.

# Additional Functionalities

## Default Local Storage

`AltogicClient` needs a local storage implementation to hold session and user information. This package provides a
default
local storage implementation that uses the [shared_preferences](https://pub.dev/packages/shared_preferences) package.

To create `AltogicClient` with default client, have to use this package's createClient method.

```dart
import 'package:altogic_dart_flutter/altogic_dart_flutter.dart';

final altogic = createClient(
    'your env url',
    'your client key'
);
```

## Auto Open Sign In With Provider URLs

AltogicClient can open sign in with provider URLs automatically. To open sign in with provider URLs automatically, have
to
use ``AuthManager.signInWithProvider`` method.

```dart
altogic.auth.signInWithProvider('google');
```

## Handle Redirect URLs

In many authentication flows/operations Altogic redirects your user to a specific URL.

For example oAuth2 flow after user signed in with the provider sign in page, Altogic redirects the user to the
redirect URL you specified in the Altogic Designer.

On websites, you can handle redirect urls by getting which path the site was opened with.

In mobile or desktop applications, you can use deep linking to open the application from a redirect url.

##### [Deep Linking Configuration](https://www.google.com)



### When Application Running in Background

If your application is running in background and opened with a deep link, `AltogicState` handle the deep link.


### AltogicState

If you use the ``AltogicState`` in root of the application, the state will be mounted if the application lifecycle is
resumed. So when application resumed or opened with deep link, we can handle the link.


When the application is opened with a deeplink, ``AltogicState`` cannot synchronously inform you with which link the
application was opened. Instead, you can override methods to be called when the application is opened with a deep link.

Available methods to override: `onEmailVerificationLink`, `onMagicLink`, `onOauthProviderLink`, `onEmailChangeLink`
, `onPasswordResetLink`.

AltogicState provides a getter named ``navigatorObserver`` that can be used to observe navigation events. You can use
this to deep linking methods BuildContext parameter.If you use navigatorObserver e.g. ``onMagicLink`` called with
context, otherwise BuildContext will be null on the method.

> If application is not running and opened with a deep link, ``restoreAuthSession`` method handle the deep link and get 
> auth grant. Even if auth grant was gotten, the methods below will be called again. Getting auth grant again is returns
> same result.

`````dart

class AltogicAuthExampleApp extends StatefulWidget {
  const AltogicAuthExampleApp({Key? key}) : super(key: key);

  @override
  State<AltogicAuthExampleApp> createState() => _AltogicAuthExampleAppState();
}

class _AltogicAuthExampleAppState extends AltogicState<AltogicAuthExampleApp> {
  @override
  void onEmailVerificationLink(BuildContext? context, EmailVerificationRedirect redirect) {
    // Handle email verification link
  }

  @override
  void onMagicLink(BuildContext? context, MagicLinkRedirect redirect) {
    // Handle magic link
  }

  @override
  void onPasswordResetLink(BuildContext? context, PasswordResetRedirect redirect) {
    // Handle password reset link
  }

  @override
  void onEmailChangeLink(BuildContext? context, ChangeEmailRedirect redirect) {
    // Handle email change link
  }

  @override
  void onOauthProviderLink(BuildContext? context, OauthRedirect redirect) {
    // Handle oauth provider link
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [navigatorObserver],
      // ...
    );
  }
}

`````


### When Application Not Running
If your application is not running and opened with a deep link, `AltogicClient.restoreAuthSession` method handle
the deep link automatically.

#### Restore Auth Session

`AltogicClient` can restore session from a deep link or local storage. To restore session from a deep link, have to use
`AltogicClient.restoreAuthSession` method.

```dart
await altogic.restoreAuthSession();
```

> Note: When application is not running and opened with a deep link, 
> [restoreAuthSession] will automatically sign in the user. 
>
> So if you have a splash screen, in the screen [AltogicClient.auth.currentState] will
> be logged in and may be you want to route to the user in splash screen. However, 
> you may want to same in the [AltogicState].onX methods. This will cause conflicts.
> To avoid this, you can use [AltogicClient.linkHandled] to check link handled by onX methods.

