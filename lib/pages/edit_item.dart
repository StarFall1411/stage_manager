import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stage_manager/models/inventory_item_model.dart';
import 'package:stage_manager/isar_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';

import '../models/tag_model.dart';
import 'package:stage_manager/globals.dart' as globals;

class EditItemPage extends StatefulWidget {
  InventoryItem inventoryItem;
  final List<Tag> allTags;

  EditItemPage({Key? key, required this.inventoryItem, required this.allTags})
      : super(key: key);

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  IsarService isar = IsarService();

  final picker = ImagePicker();
  String _imagePath = 'assets/default.png';
  File? _image;
  String? _oldFilePath;


  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: widget.inventoryItem.name);
    TextEditingController locationController = TextEditingController(text: widget.inventoryItem.location ?? "");
    TextEditingController descriptionController = TextEditingController(text: widget.inventoryItem.description ?? "");
    if(!widget.inventoryItem.picture!.contains("default.png")){
      _imagePath = widget.inventoryItem.picture!;
      _image = File(_imagePath);
    }


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text("Edit Item"),
      ),
      floatingActionButton: _addButton(nameController, locationController, descriptionController),
      body: _body(nameController,locationController,descriptionController),
    );
  }

  Widget _body(TextEditingController nameController,TextEditingController locationController,TextEditingController descriptionController) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: ListView(shrinkWrap: true, children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Text(
                          'Item Image (Tap to Change)',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await _showOptions();
                          },
                          child: _image == null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.asset(
                              _imagePath,
                              height: 225.0,
                              width: 225.0,
                            ),
                          )
                              : ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.file(
                              _image!,
                              height: 225.0,
                              width: 225.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        //TODO put a button to default to the default photo
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "Item Information",
                          style: TextStyle(fontSize: 20.0),
                        ),
                        SizedBox(
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
                        const SizedBox(height: 10.0),
                        const Text(
                          "Add Tags to Item",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 20.0),
                        ),
                        SizedBox(
                            width: screenWidth - 30.0,
                            child: _tagTable(widget.allTags)),
                      ],
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _addButton(TextEditingController nameController,TextEditingController locationController,TextEditingController descriptionController) {
    return FloatingActionButton(
      heroTag: "btn1",
      onPressed: () async {
        IsarService isar = IsarService();

        String itemImagePath;
        if (_image != null) {
          //real life photo
          if(_oldFilePath == null){
            //No change made
            itemImagePath = widget.inventoryItem.picture!;
          } else {
            //change made
            if(_oldFilePath!.contains("default.png")){
              //Need to create entirely new image with new name
              final Directory applicationDocDirect =
              await getApplicationDocumentsDirectory();
              final String copyToPath = applicationDocDirect.path;

              //Makes new filename
              final File newImage = await _image!.copy(
                  '$copyToPath/${nameController.value.text}${_random(1, 1000).toString()}.png');
              itemImagePath = newImage.path;
            }else{
              //Need to take the new image and copy it to the old path to overwrite it
              final File newImage = await _image!.copy(_oldFilePath!);
              itemImagePath = newImage.path;
            }
          }
        } else {
          //default picture no change made
          itemImagePath = "assets/default.png";
        }

        //Edits old inventory item information with new information
        widget.inventoryItem.name = nameController.text;
        widget.inventoryItem.picture = itemImagePath;
        widget.inventoryItem.description = descriptionController.text;
        widget.inventoryItem.location = locationController.text;
        //updates the item in the database
        isar.updateItem(widget.inventoryItem,globals.selectedTags);
        //Cleans stuff up on the page
        nameController.clear();
        locationController.clear();
        descriptionController.clear();
        setState(() {});
        FocusScope.of(context).unfocus();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Item was Successfully Updated!",
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

  Widget _tagTable(List<Tag> tags) {
    final columns = ["Tag Name"];
    return DataTable(
      columns: _getColumns(columns),
      rows: _getRows(tags),
    );
  }

  List<DataColumn> _getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
    label: Text(column),
  ))
      .toList();

  List<DataRow> _getRows(List<Tag> tags) => tags
      .map((Tag tag) => DataRow(
      selected: _isSelected(tag),
      onSelectChanged: (isSelected) => setState(() {
        final isAdding = isSelected != null && isSelected;

        isAdding ? globals.selectedTags.add(tag) : _removeTag(tag);
      }),
      cells: [
        DataCell(Text(tag.name)),
      ]))
      .toList();

  void _removeTag(Tag tag){
    List<Tag> tags = globals.selectedTags;
    for(int i =0;i<tags.length;i++){
      if(tags[i].id == tag.id){
        globals.selectedTags.removeAt(i);
        break;
      }
    }
  }

  bool _isSelected(Tag tag){
   bool selected = false;
    for(Tag curSelectedTag in globals.selectedTags){
      if(curSelectedTag.id == tag.id){
        selected = true;
        break;
      }
    }
    return selected;
  }

  Future _showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              _getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Camera'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              _getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  Future _getImageFromGallery() async {
    final pickedImage =
    await picker.pickImage(source: ImageSource.gallery); //getImage?

    setState(() {
      if (pickedImage != null) {
        _oldFilePath = _imagePath;
        _image = File(pickedImage.path);
        _imagePath = pickedImage.path;
      }
    });
  }

  Future _getImageFromCamera() async {
    final pickedImage =
    await picker.pickImage(source: ImageSource.camera); //getImage?

    setState(() {
      if (pickedImage != null) {
        _oldFilePath = _imagePath;
        _image = File(pickedImage.path);
        _imagePath = pickedImage.path;
      }
    });
  }

  int _random(int min, int max) {
    return min + Random().nextInt(max - min);
  }
}