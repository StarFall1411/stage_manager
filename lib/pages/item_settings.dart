import 'package:flutter/material.dart';
import 'package:stage_manager/pages/edit_item.dart';
import 'package:stage_manager/pages/inventory.dart';

import '../isar_service.dart';
import '../models/inventory_item_model.dart';
import '../models/tag_model.dart';
import 'package:stage_manager/globals.dart' as globals;

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
            SizedBox(height: 10.0,),
            _editItem(widget.inventoryItem.itemType,"Edit Item",Icons.edit),
            _deleteItem("Delete Item",Icons.delete),
          ],
        ),
      ),
    );
  }

  Widget _editItem(
      ItemType itemType, String cardText, IconData cardIcon) {
    double screenWidth = MediaQuery.of(context).size.width;
    IsarService isar = IsarService();
    return SizedBox(
      width: screenWidth - 20.0,
      child: GestureDetector(
        onTap: () async {
          List<Tag> tags = [];
          await isar.getAllTags().then((value) {
            setState(() {
              tags = value;
            });
          });
          widget.inventoryItem.tags.load();
          globals.selectedTags = widget.inventoryItem.tags.toList();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditItemPage(
                  inventoryItem: widget.inventoryItem,
                  allTags: tags.toList(),
                ),
              ));
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cardText,
                  style: const TextStyle(fontSize: 18.0),
                ),
                Icon(
                  cardIcon,
                  size: 30.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _deleteItem(String cardText, IconData cardIcon) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth - 20.0,
      child: GestureDetector(
        onTap: () async {
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
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cardText,
                  style: const TextStyle(fontSize: 18.0),
                ),
                Icon(
                  cardIcon,
                  size: 30.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
