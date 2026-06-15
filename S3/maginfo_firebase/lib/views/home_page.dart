import 'package:flutter/material.dart';
import 'package:maginfo_firebase/controllers/redacteur_controller.dart';
import 'package:maginfo_firebase/utils/contants.dart';
import 'package:maginfo_firebase/views/add_redacteur_page.dart';
import 'package:maginfo_firebase/views/redacteur_info_page.dart';
import 'package:maginfo_firebase/widgets/section_icons.dart';
import 'package:maginfo_firebase/widgets/section_service.dart';
import 'package:maginfo_firebase/widgets/section_text.dart';
import 'package:maginfo_firebase/widgets/section_title.dart';

class HomePage extends StatelessWidget {
  final RedacteurController controller;
  const HomePage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Magazine Info'),
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: mainColor,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: mainColor),
              child: const Text(
                'Magazine Infos',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Ajouter un rédacteur'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AddRedacteurPage(controller: controller),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Informations des rédacteurs'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RedacteurInfoPage(controller: controller),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Image(
            image: const AssetImage('assets/images/hero.png'),
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
