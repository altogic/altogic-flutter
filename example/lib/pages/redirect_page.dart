import 'package:altogic/altogic.dart';
import 'package:example/helpers/altogic_helper.dart';
import 'package:flutter/material.dart';

class RedirectResultPage extends StatefulWidget {
  const RedirectResultPage({required this.userSessionFuture, Key? key})
      : super(key: key);

  final Future<UserSessionResult> userSessionFuture;

  @override
  State<RedirectResultPage> createState() => _RedirectResultPageState();
}

class _RedirectResultPageState extends State<RedirectResultPage> {
  UserSessionResult? result;

  @override
  void initState() {
    widget.userSessionFuture.then((value) async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          result = value;
        });
      }

      await Future.delayed(const Duration(seconds: 4));
      if (mounted) {
        if (result?.errors == null) {
          AltogicHelper().setUser(value.user!);
          Navigator.of(context).pushNamed('/home');
        } else {
          Navigator.of(context).pushNamed('/login');
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        return Center(
          child: Builder(builder: (context) {
            if (result != null) {
              if (result!.errors != null) {
                return Column(
                  children: [
                    Center(
                      child: Text('Error: ${result!.errors!.status} \n'
                          '${result!.errors!.items.map((e) => e.message)}'),
                    )
                  ],
                );
              } else {
                return const Center(
                  child: Text('Success!'),
                );
              }
            }
            return const CircularProgressIndicator();
          }),
        );
      }),
    );
  }
}
