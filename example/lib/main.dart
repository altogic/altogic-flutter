import 'package:example/pages/home_page.dart';
import 'package:example/pages/login_page.dart';
import 'package:example/pages/register_page.dart';
import 'package:example/pages/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    setPathUrlStrategy();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (ctx) {
          switch (settings.name) {
            case '/redirect':
              throw UnimplementedError();
          }
          return MyHomePage(title: settings.name ?? "unknown");
        });
      },
      onGenerateInitialRoutes: (s) {
        return [
          MaterialPageRoute(builder: (ctx) {
            var uri = Uri.parse(s);
            var settings =
                RouteSettings(name: uri.path, arguments: uri.queryParameters);
            switch (settings.name) {
              case '/register':
                return const SplashScreen(
                  routeTo: '/register',
                );
              case '/redirect':
                throw UnimplementedError();
            }
            return const SplashScreen();
          })
        ];
      },
      routes: {
        '/': (c) => const SplashScreen(),
        '/splash': (c) => const SplashScreen(),
        '/home': (c) => const HomePage(),
        '/login': (c) => const LoginPage(),
        '/register': (c) => const RegisterPage(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _counter = 0;

  void _incrementCounter() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
