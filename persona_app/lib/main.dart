import 'package:flutter/material.dart';
import 'router/app_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Persona App',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Primary color theme
        visualDensity: VisualDensity.adaptivePlatformDensity, // Adaptive density
      ),
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      debugShowCheckedModeBanner: false, // Disable debug banner
    );
  }
}