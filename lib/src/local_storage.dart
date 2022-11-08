import 'package:altogic_dart/altogic_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ClientStorage implementation for Flutter.
///
/// SharedPreferencesStorage uses
/// [shared_preferences](https://pub.dev/packages/shared_preferences)
/// package.
///
/// [SharedPreferencesStorage] is the default storage for [AltogicClient] in
/// Flutter.
class SharedPreferencesStorage extends ClientStorage {
  /// Shared preferences instance
  late SharedPreferences preferences;
  Future<SharedPreferences>? _prefGetter;
  bool _initialized = false;

  Future<void> _ensureInit() async {
    if (_initialized) return;
    _prefGetter ??= SharedPreferences.getInstance();
    preferences = await _prefGetter!;
    _initialized = true;
    return;
  }

  @override
  Future<String?> getItem(String key) async {
    await _ensureInit();
    return preferences.getString(key);
  }

  @override
  Future<void> removeItem(String key) async {
    await _ensureInit();
    await preferences.remove(key);
  }

  @override
  Future<void> setItem(String key, String value) async {
    await _ensureInit();
    await preferences.setString(key, value);
  }
}
