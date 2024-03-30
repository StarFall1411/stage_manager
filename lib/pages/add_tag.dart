import 'package:flutter/material.dart';
import 'package:stage_manager/models/inventory_item_model.dart';
import 'package:stage_manager/isar_service.dart';

import '../models/tag_model.dart';

class AddTagPage extends StatefulWidget {
  const AddTagPage({Key? key}) : super(key: key);

  @override
  State<AddTagPage> createState() => _AddTagPageState();
}

class _AddTagPageState extends State<AddTagPage> {
  TextEditingController nameController = TextEditingController();

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

  Widget _body(){
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: screenWidth - 30.0,//TODO decide on width
              child: TextField(
                controller: nameController, //TODO add the ability to tap out of this
                decoration: const InputDecoration(
                  labelText: 'Name',
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Card(
              child: TextButton( //TODO create dialog confirming item has been made
                onPressed: () {
                  IsarService isar = IsarService();
                  Tag newTag = Tag(nameController.value.text);
                  isar.addTag(newTag);
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
      ),
    );
  }
}