import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stage_manager/models/inventory_item_model.dart';
import 'package:stage_manager/isar_service.dart';

import '../models/tag_model.dart';

class AddTagPage extends StatefulWidget {
  final List<InventoryItem> inventoryItems;

  const AddTagPage({Key? key, required this.inventoryItems}) : super(key: key);

  @override
  State<AddTagPage> createState() => _AddTagPageState();
}

class _AddTagPageState extends State<AddTagPage> {
  TextEditingController nameController = TextEditingController();
  List<InventoryItem> selectedInventoryItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text("Add Tag"),
      ),
      floatingActionButton: _submitButtons(),
      body: _body(),
    );
  }

  Widget _body() {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Center(
        child: Expanded(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            width: screenWidth - 30.0, //TODO decide on width
                            child: TextField(
                              controller: nameController,
                              //TODO add the ability to tap out of this
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            width: screenWidth - 30.0,
                            child: _itemTable(widget.inventoryItems),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _submitButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _addButton(),
        const SizedBox(
          width: 10.0,
        ),
        _addAnotherButton(),
      ],
    );
  }

  Widget _addButton() {
    return FloatingActionButton(
      heroTag: "btn1",
      onPressed: () async {
        IsarService isar = IsarService();
        //Add tag
        Tag newTag = Tag(nameController.value.text);
        isar.addTag(newTag);
        //Add items to a tag
        isar.addTagToItems(selectedInventoryItems, newTag);
        //clean up stuff
        nameController.clear();
        setState(() {});
        FocusScope.of(context).unfocus();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Tag was Successfully Created!",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Color.fromRGBO(205, 0, 0, 1),
          ),
        );
      },
      shape: const CircleBorder(),
      child: const Icon(
        Icons.check,
        color: Colors.white,
      ),
    );
  }

  Widget _addAnotherButton() {
    return FloatingActionButton(
      heroTag: "btn2",
      onPressed: () async {
        IsarService isar = IsarService();
        //Add tag
        Tag newTag = Tag(nameController.value.text);
        isar.addTag(newTag);
        //Add items to a tag
        isar.addTagToItems(selectedInventoryItems, newTag);
        //clean up stuff
        nameController.clear();
        FocusScope.of(context).unfocus();
        selectedInventoryItems = [];
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Tag was Successfully Created!",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Color.fromRGBO(205, 0, 0, 1),
          ),
        );
      },
      shape: const CircleBorder(),
      child: const Icon(
        Icons.autorenew_rounded,
        color: Colors.white,
      ),
    );
  }

  Widget _itemTable(List<InventoryItem> inventoryItems) {
    //TODO add photos to this later
    final columns = ["Item Picture", "Item Name"];
    return DataTable(
      columns: _getColumns(columns),
      rows: _getRows(inventoryItems),
      dataRowMaxHeight: 100.0,
    );
  }

  List<DataColumn> _getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
          ))
      .toList();

  List<DataRow> _getRows(List<InventoryItem> inventoryItems) =>
      inventoryItems.map((InventoryItem inventoryItem) {
        Widget avatarPicture = inventoryItem.picture!.contains("default.png")
            ? Image.asset(
                inventoryItem.picture!,
                height: 90.0,
                width: 90.0,
                fit: BoxFit.cover,
              )
            : Image.file(
                File(inventoryItem.picture!),
                height: 90.0,
                width: 90.0,
                fit: BoxFit.cover,
              );
        return DataRow(
            selected: selectedInventoryItems.contains(inventoryItem),
            onSelectChanged: (isSelected) => setState(() {
                  final isAdding = isSelected != null && isSelected;

                  isAdding
                      ? selectedInventoryItems.add(inventoryItem)
                      : selectedInventoryItems.remove(inventoryItem);
                }),
            cells: [
              DataCell(
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: avatarPicture,
                ),
              ),
              DataCell(Text(inventoryItem.name)),
            ]);
      }).toList();
}
// DataRow(
//     selected: selectedInventoryItems.contains(inventoryItem),
//     onSelectChanged: (isSelected) =>
//         setState(() {
//           final isAdding = isSelected != null && isSelected;
//
//           isAdding
//               ? selectedInventoryItems.add(inventoryItem)
//               : selectedInventoryItems.remove(inventoryItem);
//         }),
//     cells: [
//       DataCell(CircleAvatar(
//         backgroundImage: inventoryItem.picture!.contains(
//             "default.png") ?
//         Image.asset(
//           inventoryItem.picture!,)
//             : Image.file(,),
//       ),),
//       DataCell(Text(inventoryItem.name)),
//     ]))
// .toList();
