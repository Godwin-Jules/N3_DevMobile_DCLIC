import 'package:activity_05/views/page_accueil.dart';
import 'package:activity_05/views/page_detail.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MonApplication());
}

class MonApplication extends StatelessWidget {
  const MonApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PageAccueil(),
      routes: {'/details': (context) => DetailPage()},
    );
  }
}
