import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stage_manager/models/inventory_item_model.dart';
import 'package:stage_manager/pages/item_settings.dart';

import '../models/tag_model.dart';

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
        title: const Text("View Item"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ItemSettingsPage(
                          inventoryItem: widget.inventoryItem)));
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
    if (!widget.inventoryItem.picture!.contains("default.png")) {
      nonDefaultImage = File(widget.inventoryItem.picture!);
    }

    return Center(
      child: SizedBox(
        width: screenWidth - 30.0,
        child: Expanded(
          child: Column(
            children: [
              Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Text(
                              "Item Image:",
                              style: TextStyle(fontSize: 20.0),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            _itemImage(nonDefaultImage),
                            SizedBox(
                              height: 10.0,
                            ),
                            const Text(
                              "Item Information:",
                              style: TextStyle(fontSize: 20.0),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            _nameLocation(screenWidth),
                            const SizedBox(
                              height: 10.0,
                            ),
                            _description(screenWidth),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Text(
                              "Tags:",
                              style: TextStyle(fontSize: 20.0),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            _tags(),
                          ],
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _tags() {
    List<Widget> tagWidgets = _getWidgetTags();
    return Column(
      children: [
        tagWidgets.isNotEmpty
            ? Wrap(
                children: tagWidgets,
              )
            : const Text("No Tags have been Chosen"),
      ],
    );
  }

  List<Widget> _getWidgetTags() {
    List<Widget> tagWidgets = [];
    widget.inventoryItem.tags.load();
    for (Tag tag in widget.inventoryItem.tags) {
      tagWidgets.add(
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(tag.name),
          ),
        ),
      );
    }
    return tagWidgets;
  }

  Widget _nameLocation(double screenWidth) {
    return SizedBox(
      width: screenWidth - 30.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: 150.0,
            width: 175.0,
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Name:",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Text(
                    widget.inventoryItem.name,
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 150.0,
            width: 175.0,
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Location:",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Text(
                    widget.inventoryItem.location != null
                        ? widget.inventoryItem.location != ""
                            ? widget.inventoryItem.location!
                            : "No Location Given"
                        : "No Location Given",
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _description(double screenWidth) {
    return SizedBox(
      width: screenWidth - 30.0,
      child: Card(
        margin: EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10.0,
            ),
            const Text(
              "Description:",
              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              widget.inventoryItem.description != null
                  ? widget.inventoryItem.description != ""
                      ? widget.inventoryItem.description!
                      : "No Description Given"
                  : "No Description Given",
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemImage(File nonDefaultImage) {
    return widget.inventoryItem.picture!.contains("default.png")
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
