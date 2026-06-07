import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/endroits_provider.dart';
import './widgets/endroits_list.dart';
import 'ajout_endroit.dart';

class EndroitsInterface extends ConsumerWidget {
  const EndroitsInterface({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final endroits = ref.watch(endroitsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes endroits préférés'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (ctx) => const AjoutEndroit()));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: EndroitsList(endroits: endroits),
    );
  }
}
