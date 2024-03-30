import 'package:flutter/material.dart';
import 'package:stage_manager/models/inventory_item_model.dart';
import 'package:stage_manager/pages/add_item.dart';

import 'add_tag.dart';

class ChooseAddPage extends StatefulWidget {
  const ChooseAddPage({super.key});

  @override
  State<ChooseAddPage> createState() => _ChooseAddPageState();
}

class _ChooseAddPageState extends State<ChooseAddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text('Inventory'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10.0,
          ),
          Card(
            child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddItemPage(
                            addItemType: ItemType.prop,
                              )));
                },
                child: const Text("Prop")),
          ),
          Card(
            child: TextButton(onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddItemPage(
                        addItemType: ItemType.costume,
                      )));
            }, child: const Text("Costume")),
          ),
          Card(
            child: TextButton(onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddItemPage(
                        addItemType: ItemType.furniture,
                      )));
            }, child: const Text("Furniture")),
          ),
          Card(
            child: TextButton(onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddTagPage(
                      )));
            }, child: const Text("Tag")),
          ),
        ],
      ),
    );
  }
}
