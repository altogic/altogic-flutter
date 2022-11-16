# Altogic Dart

Altogic Dart is a Dart client for the Altogic Client Library. It provides access to all the functionality of the Altogic Client Library.

This package includes some Flutter dependencies in addition to the [altogic_dart](https://pub.dev/packages/altogic_dart) package.

# Additional Functionalities

## Default Local Storage

`AltogicClient` needs a local storage implementation to hold sessions and user information. This package provides a
default local storage implementation that uses the [shared_preferences](https://pub.dev/packages/shared_preferences)
package.

````dart
import 'package:altogic_dart_flutter/altogic_dart_flutter.dart';

final altogic = createClient(
    'your env url',
    'your client key'
);
````

## Auto Open Sign In With Provider URLs

AltogicClient can open sign-in with provider URLs automatically. You can use the ``AuthManager.signInWithProvider`` method to open sign-in with provider URLs directly.

```dart
altogic.auth.signInWithProvider('google');
```

## Handle Redirect URLs


In many authentication flows/operations, Altogic redirects your user to a specific URL.

For example, oAuth2 flow after the user signed in with the provider sign-in page, Altogic redirects the user to the redirect URL you specified in the Altogic Designer > App Settings > Authentication.

You can handle redirect URLs on websites by getting which path opens the site.

You can use deep linking in mobile or desktop applications to open the application from a redirect URL.


##### [Deep Linking Configuration](https://altogic.com/client/guides/authentication/handling_auth_deep_links)

### AltogicState

If you use "AltogicState" at the root of the application, the "AltogicState" will be "connected" throughout the application lifecycle. Thus, we can listen to the deep links when the application is resumed or opened with a deep link.

When the application opens by a deep link, ``AltogicState`` cannot synchronously inform you about the deep link. Instead, you can override methods to be called when a deep link opens the application.

Available methods to override: `onEmailVerificationLink`, `onMagicLink`, `onOauthProviderLink`, `onEmailChangeLink`, `onPasswordResetLink`.

AltogicState provides a getter named ``navigatorObserver`` to observe navigation events. You can use `BuildContext` as the parameter for deep linking methods. If you use navigatorObserver, e.g., ``onMagicLink`` called with context; otherwise, `BuildContext` will be null for these methods.

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

Generally, in the first run of the application, many developers show a splash screen. In this case, the application is opened with a deep link, `AuthState.onX` methods are triggered, and maybe the user is navigated to another page from the triggered method. Also, the splash screen will try to navigate to another page. This case causes a conflict.

To avoid this conflict, you can use ``AltogicState.applicationInitialRedirect`` static getter:

`````dart
Future<void> init() async {
  // Check if the application was opened with a deep link
  var openedRedirect = await AltogicState.applicationInitialRedirect;
  if (openedRedirect != null) {
    return;
  }
  // navigate now
}
`````

> You can use the ``AltogicState.applicationInitialRedirect`` getter instead of the ``AltogicState.onX`` methods. But you have to listen to ApplicationLifecycle events manually to handle deep links.


#### Restore Auth Session

`AltogicClient` can restore the session from local storage. To do this, you can use the `AltogicClient.restoreAuthSession` method.

> If the application is not running and opened with a deep link, the ``restoreAuthSession`` method checks if the application opened with a deep-link. If the application opens with a deep-link, the ``restoreAuthSession`` method will not restore the session from local storage. (Necessary to avoid conflicts)

```dart
await
altogic.restoreAuthSession();
```


