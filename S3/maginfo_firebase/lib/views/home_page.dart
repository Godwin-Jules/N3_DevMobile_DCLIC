import 'package:flutter/material.dart';
import 'package:maginfo_firebase/widgets/section_icons.dart';
import 'package:maginfo_firebase/widgets/section_service.dart';
import 'package:maginfo_firebase/widgets/section_text.dart';
import 'package:maginfo_firebase/widgets/section_title.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Magazine Info'),
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 70, 14),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: [
          Image(
            image: AssetImage('assets/images/hero.png'),
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),
          const SectionTitle(),
          const SectionText(),
          const SectionIcons(),
          const SectionService(),
        ],
      ),
    );
  }
}
