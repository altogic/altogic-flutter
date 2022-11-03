import 'package:altogic_dart/altogic_dart.dart';
import 'package:app_links/app_links.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesStorage extends ClientStorage {
  late SharedPreferences preferences;
  Future<SharedPreferences>? _prefGetter;
  final AppLinks appLinks = AppLinks();
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
