import 'package:flutter/material.dart';
import 'package:stage_manager/models/inventory_item_model.dart';
import 'package:stage_manager/isar_service.dart';

import '../models/tag_model.dart';

class AddItemPage extends StatefulWidget {
  final ItemType addItemType;

  const AddItemPage({Key? key, required this.addItemType}) : super(key: key);

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  IsarService isar = IsarService();

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

  Widget _body() {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Center(
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
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: screenWidth - 30.0,
              child: TextField(
                controller: locationController,
                //TODO add the ability to tap out of this
                decoration: const InputDecoration(
                  labelText: 'Location',
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: screenWidth - 30.0,
              child: TextField(
                controller: descriptionController,
                //TODO add the ability to tap out of this
                decoration: const InputDecoration(
                  labelText: 'Description',
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                minLines: 2,
              ),
            ),
            SizedBox(height: 10.0),
            FutureBuilder(
                future: isar.getAllTags(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Card(
                        child: Text("Snapshot has error"),
                      );
                    } else if (snapshot.hasData) {
                      List<Tag>? tags = snapshot.data;
                      List<Tag> chosenTags = [];
                      return Expanded(
                          child: Center(
                              child: Column(
                        children: [
                          Expanded(
                              child: ListView.builder(
                            itemCount: tags?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: (){
                                  //Has just been chosen
                                  if(!chosenTags.contains(tags[index])){
                                    chosenTags.add(tags[index]);
                                    //Has been deselected
                                  }else{
                                    chosenTags.remove(tags[index]);
                                  }
                                },
                                child: Card(
                                  child: SizedBox(
                                    height: 50.0,
                                    width: 1.0,
                                    child: Row(
                                      children: [
                                        Text(tags?[index].name ?? "No Tag"),
                                        chosenTags.contains(tags![index]) ? const Text("Selected"):const Text("Not Selected"),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )),
                        ],
                      )));
                    }
                  }
                  return const Card(
                    child: Text(
                        "Connection not done."), //TODO make this a CircularProgressIndicator()
                  );
                }),
            Card(
              child: TextButton(
                //TODO create dialog confirming item has been made
                onPressed: () {
                  IsarService isar = IsarService();
                  InventoryItem newItem = InventoryItem(
                      nameController.value.text,
                      "picture.jpg",
                      descriptionController.value.text,
                      locationController.value.text,
                      widget.addItemType);
                  isar.addItem(newItem);
                  nameController.clear();
                  locationController.clear();
                  descriptionController.clear();
                  setState(() {});
                  FocusScope.of(context).unfocus();
                  Navigator.pop(context);
                },
                //TODO tags go here
                child: const Text("Submit"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
