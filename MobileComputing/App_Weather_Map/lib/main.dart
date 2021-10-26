import 'package:app_weather_map/screens/home.dart';
import 'package:app_weather_map/theme/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const UniClima());
}

class UniClima extends StatelessWidget {
  const UniClima({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Home(),
      title: "UniClima",
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      themeMode: ThemeMode.system,
    );
  }
}


