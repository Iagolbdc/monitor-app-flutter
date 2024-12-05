import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'monitor_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitor de Sensores',
      theme: ThemeData(primarySwatch: Colors.blue),
      navigatorKey: navigatorKey, // Adiciona o GlobalKey
      home: LoginScreen(
        onIpSaved: (ip) {
          navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (context) => MonitorScreen(ip: ip),
            ),
          );
        },
      ),
    );
  }
}
