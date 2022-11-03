import 'package:altogic_flutter/altogic_flutter.dart';

class AltogicHelper {
  factory AltogicHelper() => _instance;

  AltogicHelper._();

  static final AltogicHelper _instance = AltogicHelper._();

  late AltogicClient client;

  AuthManager get auth {
    if (!_initialized) throw Exception('Inıt once');
    return client.auth;
  }

  bool _initialized = false;

  Future<void> init() async {
    client = createClient(
        'https://c1-na.altogic.com/e:62863f06bb75ed002ed0f207',
        '5ad8526dbd014613a8dbeff60daa7c26');
    await client.restoreLocalAuthSession();
    _initialized = true;
    await checkUserLoggedIn();
  }

  User get user => _user!;
  User? _user;

  bool get userLoggedIn => _user != null;

  Future<bool> checkUserLoggedIn() async {
    _user = await auth.getUser();
    return userLoggedIn;
  }

  void setUser(User user) {
    _user = user;
  }
}
