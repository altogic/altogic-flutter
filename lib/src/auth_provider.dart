import 'package:altogic_dart/altogic_dart.dart';
import 'package:url_launcher/url_launcher.dart';

/// AuthManager extension to add [signInWithProviderFlutter]
extension AltogicAuthFlutterExtension on AuthManager {
  /// Sign in with a provider using Flutter
  ///
  /// This method will open a browser window to sign in with the provider.
  ///
  /// [provider] is the provider to sign in with.
  ///
  /// If you want to open it manually, you can get the link by using
  /// [signInWithProvider].
  Future<bool> signInWithProviderFlutter(String provider) {
    var link = signInWithProvider(provider);
    return launchUrl(Uri.parse(link),
        webOnlyWindowName: '_self',
        mode: LaunchMode.externalApplication,
        webViewConfiguration: const WebViewConfiguration(
            headers: {'OverrideUserAgent': 'Mozilla/5.0 Google'}));
  }
}
