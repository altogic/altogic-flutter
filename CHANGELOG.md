## 0.0.9+14

- Bug fixes
- ``README.md`` updated.
- ``altogic_dart`` dependency updated.

## 0.0.9+10

- ``AltogicClient.restoreLocalAuthSession`` no longer restore session from local if the application opened with deep link.
- `AltogicClient.auth` now returns ``FlutterAuthManager`` that implements `AuthManager`.
- ``AuthManager.signInWithProvider`` now opens the provider's sign in page automatically.
- ``ClientOptions`` implementation is added.
- ``ClientOptions.signInRedirect`` now is called with a nullable `BuildContext` parameter.
- ``AuthManager.getAuthGrant`` now checks access_token parameter from initial link if optional [accessToken] parameter is null.
- Many documentation improvements.
- ``altogic_dart`` package upgraded to ``0.0.9+3``. see [changelog](https://pub.dev/packages/altogic_dart/changelog).
- ``README.md`` updated.
- static getter of ``AltogicState.applicationInitialRedirect`` added. It used for navigation duplication.
- Web redirect bug fixed.

## 0.0.9+1

- Package name changed to "altogic"
- Some public classes turned to private
- Some public methods turned to private
- altogic_dart package upgraded to 0.0.9+2


## 0.0.9

- Preparing to release
- Added `AltogicState`

## 0.0.5

- Bug fixes
- ``altogic_dart`` dependency updated to ``0.0.5``
- ``README.md`` updated


## 0.0.2

- Tested all platforms
- Readme updated.
- altogic_dart version updated.


## 0.0.1

* TODO: Describe initial release.
