import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stage_manager/models/inventory_item_model.dart';
import 'package:stage_manager/pages/item_settings.dart';

class ViewItemPage extends StatefulWidget {
  final InventoryItem inventoryItem;

  const ViewItemPage({super.key, required this.inventoryItem});

  @override
  State<ViewItemPage> createState() => _ViewItemPageState();
}

class _ViewItemPageState extends State<ViewItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(widget.inventoryItem.name),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ItemSettingsPage(inventoryItem: widget.inventoryItem)));
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    double screenWidth = MediaQuery.of(context).size.width;
    File nonDefaultImage = File('assets/default.png');
    if (!widget.inventoryItem
        .picture!
        .contains("default.png")) {
      nonDefaultImage =
          File(widget.inventoryItem.picture!);
    }

    return Center(
      child: SizedBox(
        width: screenWidth - 40.0,
        child: Column(
          children: [
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              "Item Image",
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 10.0,),
            _itemImage(nonDefaultImage),
            SizedBox(height: 10.0,),
            const Text(
              "Location:",
              style: TextStyle(fontSize: 20.0),
            ),
            Text(widget.inventoryItem.location ?? ""),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              "Description:",
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              widget.inventoryItem.description ?? "",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              "Tags:",
              style: TextStyle(fontSize: 20.0),
            )
          ],
        ),
      ),
    );
  }

  Widget _itemImage(File nonDefaultImage){
    return widget.inventoryItem
        .picture!
        .contains("default.png")
        ? ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Image.asset(
        widget.inventoryItem.picture!,
        height: 225.0,
        width: 225.0,
      ),
    )
        : ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Image.file(
        nonDefaultImage,
        height: 225.0,
        width: 225.0,
        fit: BoxFit.cover,
      ),
    );
  }

}
