import 'package:flutter/material.dart';
import 'package:stage_manager/pages/edit_item.dart';
import 'package:stage_manager/pages/inventory.dart';

import '../isar_service.dart';
import '../models/inventory_item_model.dart';
import '../models/tag_model.dart';

class ItemSettingsPage extends StatefulWidget {
  final InventoryItem inventoryItem;

  const ItemSettingsPage({super.key, required this.inventoryItem});

  @override
  State<ItemSettingsPage> createState() => _ItemSettingsPageState();
}

class _ItemSettingsPageState extends State<ItemSettingsPage> {
  IsarService isar = IsarService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text("Item Settings"),
      ),
      body: Center(
        child: Column(
          children: [
            _editItem(),
            _deleteItem(),
          ],
        ),
      ),
    );
  }

  Widget _editItem() {
    double screenWidth = MediaQuery.of(context).size.width;
    IsarService isar = IsarService();
    return SizedBox(
      width: screenWidth - 15.0,
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              List<Tag> tags = [];
              await isar.getAllTags().then((value) {
                setState(() {
                  tags = value;
                });
              });
              widget.inventoryItem.tags.load();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditItemPage(
                      inventoryItem: widget.inventoryItem,
                      tags: tags,
                      selectedTags: widget.inventoryItem.tags.toList(),
                    ),
                  ));
            },
            child: const Card(
              child: SizedBox(
                height: 100.0,
                child: Row(
                  children: [
                    Text("Edit Item"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _deleteItem() {
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth - 15.0,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Delete ${widget.inventoryItem.name}?"),
                      content: Text(
                          "This action will delete ${widget.inventoryItem.name}."),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              isar.deleteItem(widget.inventoryItem);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const InventoryPage()),
                              );
                            },
                            child: const Text("Yes")),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("No")),
                      ],
                    );
                  });
            },
            child: const Card(
              child: SizedBox(
                height: 100.0,
                child: Row(
                  children: [
                    Text("Delete Item"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
