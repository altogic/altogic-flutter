## Altogic Dart

Altogic Dart is a Dart client for the Altogic Client Library. It provides access to all the functionality of the Altogic
Client Library.

This package includes some Flutter dependencies in addition to the [altogic_dart](https://pub.dev/packages/altogic_dart)
package.

## Additional Functionalities

### Default Local Storage

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

### Auto Open Sign In With Provider URLs

AltogicClient can open sign in with provider URLs automatically. To open sign in with provider URLs automatically, have
to
use ``AuthManager.signInWithProviderFlutter`` method.

```dart
altogic.auth.signInWithProviderFlutter('google');
```

``signInWithProviderFlutter`` returns a ``Future`` that resolves to ``true`` if the sign in with provider URL is opened.

### Handle Sign In With Provider Callbacks

#### AltogicState

If you use the ``AltogicState`` in root of the application, the state will be mounted if the application lifecyle is
resumed. So when application resumed or opened with deep link, we can handle the link.

When the application is opened with a deeplink, ``AltogicState`` cannot synchronously inform you with which link the
application was opened. Instead, you can override methods to be called when the application is opened with a deep link.

Available methods to override: `onEmailVerificationLink`, `onMagicLink`, `onOauthProviderLink`, `onEmailChangeLink`
, `onPasswordResetLink`.

AltogicState provides a getter named ``navigatorObserver`` that can be used to observe navigation events. You can use
this to deep linking methods BuildContext parameter.If you use navigatorObserver e.g. ``onMagicLink`` called with
context, otherwise BuildContext will be null on the method.

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
    // TODO: implement onPasswordResetLink
    super.onPasswordResetLink(context, redirect);
  }

  @override
  void onEmailChangeLink(BuildContext? context, ChangeEmailRedirect redirect) {
    // TODO: implement onEmailChangeLink
    super.onEmailChangeLink(context, redirect);
  }

  @override
  void onOauthProviderLink(BuildContext? context, OauthRedirect redirect) {
    // TODO: implement onOauthProviderLink
    super.onOauthProviderLink(context, redirect);
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