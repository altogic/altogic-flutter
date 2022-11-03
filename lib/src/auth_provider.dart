import 'package:altogic_dart/altogic_dart.dart';
import 'package:url_launcher/url_launcher.dart';

extension AltogicAuthFlutterExtension on AuthManager {
  Future<bool> signInWithProviderFlutter(String provider) {
    var link = signInWithProvider(provider);
    return launchUrl(Uri.parse(link),
        webOnlyWindowName: '_self',
        mode: LaunchMode.externalApplication,
        webViewConfiguration: const WebViewConfiguration(
            headers: {'OverrideUserAgent': 'Mozilla/5.0 Google'}));
  }
}
