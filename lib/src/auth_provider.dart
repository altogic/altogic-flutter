import 'package:altogic_dart/altogic_dart.dart';
import 'package:flutter/material.dart';
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

  Future<UserSessionResult> handleProviderRedirect(dynamic settings) async {
    String? accessToken;
    String? error;
    int? status;

    if (settings is RouteSettings && settings.arguments is Map) {
      var args = (settings.arguments as Map?);
      accessToken = args?["access_token"];
      error = args?['error'];
      status = args?['status'] != null ? int.parse(args?['status']) : null;
    } else if (settings is String) {
      var uri = Uri.parse(settings);
      var args = uri.queryParameters;
      accessToken = args["access_token"];
      error = args['error'];
      status = args['status'] != null ? int.parse(args['status']!) : null;
    }

    if (error != null) {
      return UserSessionResult(
          errors: APIError(
              status: status ?? 400,
              statusText: '',
              items: [ErrorEntry(message: error)]));
    }

    return getAuthGrant(accessToken);
  }
}
