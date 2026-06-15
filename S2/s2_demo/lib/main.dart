import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blue)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              title: Text('Titre de la carte 1'),
              subtitle: Text('Sous-titre de la carte 1'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Title de la carte 2'),
              subtitle: Text('Sous-titre de la carte 2'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Title de la carte 3'),
              subtitle: Text('Sous-titre de la carte 3'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Title de la carte 4'),
              subtitle: Text('Sous-titre de la carte 4'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Title de la carte 5'),
              subtitle: Text('Sous-titre de la carte 5'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Title de la carte 6'),
              subtitle: Text('Sous-titre de la carte 6'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Title de la carte 7'),
              subtitle: Text('Sous-titre de la carte 7'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Title de la carte 8'),
              subtitle: Text('Sous-titre de la carte 8'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Title de la carte 9'),
              subtitle: Text('Sous-titre de la carte 9'),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('You press the add button');
        },
        tooltip: 'Add button',
        child: const Icon(Icons.add),
      ),
    );
  }
}
