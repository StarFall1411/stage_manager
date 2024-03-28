import 'package:flutter/material.dart';

import '../models/inventory_item_model.dart';

class ItemSettingsPage extends StatefulWidget {
  final InventoryItem inventoryItem;

  const ItemSettingsPage({super.key, required this.inventoryItem});

  @override
  State<ItemSettingsPage> createState() => _ItemSettingsPageState();
}

class _ItemSettingsPageState extends State<ItemSettingsPage> {
  @override
  Widget build(BuildContext context) {
    //TODO Make look better
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      centerTitle: true,
      title: Text("${widget.inventoryItem.name} Settings"),
    ),
      body: Center(
      child: SizedBox(
        width: screenWidth - 15.0,
        child: Column(
          children: [
            Card(
              child: Row(
                children: [
                  Text("Delete Item"),
                ],
              ),
            ),
          ],
        ),
      ),
    ),);
  }
}