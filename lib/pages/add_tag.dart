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
                          _itemTable(widget.inventoryItems),
                          Card(
                            child: TextButton(
                              //TODO create dialog confirming item has been made
                              onPressed: () {
                                IsarService isar = IsarService();
                                //Add tag
                                Tag newTag = Tag(nameController.value.text);
                                isar.addTag(newTag);
                                //Add items to a tag
                                isar.addTagToItems(selectedInventoryItems,newTag);
                                //clean up stuff
                                nameController.clear();
                                setState(() {});
                                FocusScope.of(context).unfocus();
                                Navigator.pop(context);
                              },
                              child: const Text("Submit"),
                            ),
                          )
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

  Widget _itemTable(List<InventoryItem> inventoryItems) {
    //TODO add photos to this later
    final columns = ["Item Name"];
    return DataTable(
      columns: _getColumns(columns),
      rows: _getRows(inventoryItems),
    );
  }

  List<DataColumn> _getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
          ))
      .toList();

  List<DataRow> _getRows(List<InventoryItem> inventoryItems) => inventoryItems
      .map((InventoryItem inventoryItem) => DataRow(
              selected: selectedInventoryItems.contains(inventoryItem),
              onSelectChanged: (isSelected) => setState(() {
                    final isAdding = isSelected != null && isSelected;

                    isAdding
                        ? selectedInventoryItems.add(inventoryItem)
                        : selectedInventoryItems.remove(inventoryItem);
                  }),
              cells: [
                DataCell(Text(inventoryItem.name)),
              ]))
      .toList();
}
