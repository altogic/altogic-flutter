import 'package:altogic/altogic.dart';
import 'package:example/helpers/altogic_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final ValueNotifier<bool> ob = ValueNotifier(true);
  final AltogicHelper helper = AltogicHelper();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  child: const FlutterLogo(
                    size: 150,
                  ),
                )),
                Card(
                  color: Colors.white,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Container(
                    width: 400,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Sign In With Altogic',
                            style: TextStyle(fontSize: 20)),
                        const SizedBox(
                          height: 30,
                        ),
                        TextField(
                          controller: mailController,
                          decoration: const InputDecoration(hintText: 'Mail'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ValueListenableBuilder(
                            valueListenable: ob,
                            builder: (c, v, w) {
                              return TextField(
                                obscureText: ob.value,
                                controller: passwordController,
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          ob.value = !ob.value;
                                        },
                                        icon: Icon(ob.value
                                            ? Icons.visibility
                                            : Icons.visibility_off)),
                                    hintText: 'Password'),
                              );
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              if (mailController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty) {
                                var res = await helper.auth.signInWithEmail(
                                    mailController.text,
                                    passwordController.text);

                                if (res.errors != null) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Error: ${res.errors!.statusText}')));
                                  }
                                } else {
                                  var logged = await helper.checkUserLoggedIn();
                                  if (logged) {
                                    if (mounted) {
                                      Navigator.of(context).pushNamed('/home');
                                    }
                                  } else {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text('Not Logged')));
                                    }
                                  }
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        content: Text('Please enter valid '
                                            'mail and password.')));
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: const Text('Login With E-Mail'),
                            ))
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: 100,
                    width: 400,
                    child: Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      /*height: 60,
                          alignment: Alignment.topCenter,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          */
                      child: InkWell(
                        onTap: () async {
                          await helper.auth.signOutAll();
                          helper.auth.signInWithProviderFlutter('google');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/google.png",
                                height: 60,
                              ),
                              const SizedBox(
                                width: 18,
                              ),
                              const Text('Continue With Google',
                                  style: TextStyle(fontSize: 18)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
