import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uni_links/uni_links.dart';

abstract class AltogicAuthState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!kIsWeb && state == AppLifecycleState.resumed) {
      getInitialUri().then((value) {
        if (value != null) {
          Navigator.of(context)
              .pushNamed(value.path, arguments: value.queryParameters);
        }
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
