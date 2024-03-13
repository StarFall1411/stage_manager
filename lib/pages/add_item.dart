import 'package:flutter/material.dart';
import 'package:stage_manager/models/inventory_item_model.dart';
import 'package:stage_manager/isar_service.dart';

class AddItemPage extends StatefulWidget {
  final ItemType addItemType;

  const AddItemPage({Key? key, required this.addItemType}) : super(key: key);

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String title = widget.addItemType == ItemType.prop
        ? 'Add Prop'
        : widget.addItemType == ItemType.costume
            ? 'Add Costume'
            : 'Add Furniture';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(title),
      ),
      body: _body(),
    );
  }

  Widget _body(){
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          const SizedBox(
            height: 10.0,
          ),
          const Text('Name'),
          TextField(
            controller: nameController, //TODO add the ability to tap out of this
          ),
          Card(
            child: TextButton(
              onPressed: () {
                IsarService isar = IsarService();
                InventoryItem newItem = InventoryItem(
                    nameController.value.text,
                    "picture.jpg",
                    "This is a description.",
                    "Hallway",
                    widget.addItemType);
                isar.addItem(newItem);
                nameController.clear();
                setState(() {});
                FocusScope.of(context).unfocus();
              },
              child: const Text("Submit"),
            ),
          )
        ],
      ),
    );
  }
}
