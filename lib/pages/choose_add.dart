import 'package:flutter/material.dart';
import 'package:stage_manager/models/inventory_item_model.dart';
import 'package:stage_manager/pages/add_item.dart';

import '../isar_service.dart';
import '../models/tag_model.dart';
import 'add_tag.dart';

class ChooseAddPage extends StatefulWidget {
  const ChooseAddPage({super.key});

  @override
  State<ChooseAddPage> createState() => _ChooseAddPageState();
}

class _ChooseAddPageState extends State<ChooseAddPage> {
  @override
  Widget build(BuildContext context) {
    IsarService isar = IsarService();

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
                onPressed: () async{
                  List<Tag> tags = [];
                  await isar.getAllTags().then((value) {
                    setState(() {
                      tags = value;
                    });
                  });

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddItemPage(
                                addItemType: ItemType.prop,
                            tags: tags,
                              )));
                },
                child: const Text("Prop")),
          ),
          Card(
            child: TextButton(
                onPressed: () async{
                  List<Tag> tags = [];
                  await isar.getAllTags().then((value) {
                    setState(() {
                      tags = value;
                    });
                  });

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddItemPage(
                                addItemType: ItemType.costume,
                            tags: tags,
                              )));
                },
                child: const Text("Costume")),
          ),
          Card(
            child: TextButton(
                onPressed: () async{
                  List<Tag> tags = [];
                  await isar.getAllTags().then((value) {
                    setState(() {
                      tags = value;
                    });
                  });

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddItemPage(
                                addItemType: ItemType.furniture,
                            tags: tags,
                              )));
                },
                child: const Text("Furniture")),
          ),
          Card(
            child: TextButton(
                onPressed: () async{
                  List<InventoryItem> inventoryItems = [];
                  await isar.getAllInventoryItems().then((value) {
                    setState(() {
                      inventoryItems = value;
                    });
                  });

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddTagPage(
                            inventoryItems: inventoryItems,
                          )));
                },
                child: const Text("Tag")),
          ),
        ],
      ),
    );
  }
}
