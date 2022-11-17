import 'package:altogic/altogic.dart';
import 'package:example/helpers/altogic_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AltogicHelper helper = AltogicHelper();

  User get user => helper.user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('User Logged In'),
              const SizedBox(
                height: 20,
              ),
              const Text('User info:'),
              Text('_id: ${user.id}'),
              Text('name: ${user.name}'),
              Text('provider: ${user.provider}'),
              Text('provider_user_id: ${user.providerUserId}'),
              Text('signUpAt: ${user.signUpAt}'),
              Text('lastLoginAt: ${user.lastLoginAt}'),
              Text('email: ${user.email}'),
              Text('email: ${user.phone}'),
              Text('profile_picture: ${user.profilePicture}'),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () async {
                    var res = await helper.auth.signOutAll();
                    if (res != null) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text("Error on sign out: ${res.statusText}")));
                        Navigator.of(context).pushNamed('/splash');
                      }
                    } else {
                      if (mounted) {
                        Navigator.of(context).pushNamed('/login');
                      }
                    }
                  },
                  child: const Text('Logout'))
            ],
          ),
        ),
      ),
    );
  }
}
