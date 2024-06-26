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

class AddItemPage extends StatefulWidget {
  final ItemType addItemType;
  final List<Tag> tags;

  const AddItemPage({Key? key, required this.addItemType, required this.tags})
      : super(key: key);

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  IsarService isar = IsarService();

  List<Tag> selectedTags = [];
  final picker = ImagePicker();
  String _imagePath = 'assets/default.png';
  File? _image;

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
      floatingActionButton: _submitButtons(),
      body: _body(),
    );
  }

  Widget _body() {
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
                            child: _tagTable(widget.tags)),
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

  Widget _submitButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _addButton(),
        SizedBox(
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

        String itemImagePath;
        if (_image != null) {
          final Directory applicationDocDirect =
              await getApplicationDocumentsDirectory();
          final String copyToPath = applicationDocDirect.path;
          //TODO filename goes here

          final File newImage = await _image!.copy(
              '$copyToPath/${nameController.value.text}${_random(1, 1000).toString()}.png');
          itemImagePath = newImage.path;
        } else {
          itemImagePath = _imagePath;
        }

        //Creates new item, then inserts it(Initializes links)
        InventoryItem newItem = InventoryItem(
            nameController.value.text,
            itemImagePath,
            descriptionController.value.text,
            locationController.value.text,
            widget.addItemType);
        isar.addItem(newItem);
        //Sets the links
        isar.addTagsToItem(newItem, selectedTags);
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
              "Item was Successfully Created!",
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

        String itemImagePath;
        if (_image != null) {
          final Directory applicationDocDirect =
              await getApplicationDocumentsDirectory();
          final String copyToPath = applicationDocDirect.path;
          //TODO filename goes here

          final File newImage = await _image!.copy(
              '$copyToPath/${nameController.value.text}${_random(1, 1000).toString()}.png');
          itemImagePath = newImage.path;
        } else {
          itemImagePath = _imagePath;
        }

        //Creates new item, then inserts it(Initializes links)
        InventoryItem newItem = InventoryItem(
            nameController.value.text,
            itemImagePath,
            descriptionController.value.text,
            locationController.value.text,
            widget.addItemType);
        isar.addItem(newItem);
        //Sets the links
        isar.addTagsToItem(newItem, selectedTags);
        //Cleans stuff up on the page
        nameController.clear();
        locationController.clear();
        descriptionController.clear();
        selectedTags = [];
        _imagePath = 'assets/default.png';
        _image = null;
        setState(() {});
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Item was Successfully Created!",style: TextStyle(
              color: Colors.white,
            ),),
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
              selected: selectedTags.contains(tag),
              onSelectChanged: (isSelected) => setState(() {
                    final isAdding = isSelected != null && isSelected;

                    isAdding ? selectedTags.add(tag) : selectedTags.remove(tag);
                  }),
              cells: [
                DataCell(Text(tag.name)),
              ]))
      .toList();

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
        _image = File(pickedImage.path);
      }
    });
  }

  Future _getImageFromCamera() async {
    final pickedImage =
        await picker.pickImage(source: ImageSource.camera); //getImage?

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      }
    });
  }

  int _random(int min, int max) {
    return min + Random().nextInt(max - min);
  }
}
