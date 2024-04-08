import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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
  String _imagePath = 'assets/default.png';
  final picker = ImagePicker();

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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          const SizedBox(
            height: 10.0,
          ),
          const Text('Item Image'),
          GestureDetector(
            onTap: _showOptions,
            child: Image.asset(_imagePath,height: 225.0,width: 225.0,),
          ),
          //TODO put a button to default to the default photo
          //TODO put something to help the user to know to tap to take a new photo
          const Text('Name'),
          TextField(
            controller:
            nameController, //TODO add the ability to tap out of this
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

    setState(() async {
      if (pickedImage != null) {
        final Directory directory = await getApplicationDocumentsDirectory();
        final String path = directory.path;
        final File createdFile = File(pickedImage.path);
        final File newImage = await createdFile.copy('$path/image1.png');
        _imagePath = newImage.path;
      }
    });
  }

  Future _getImageFromCamera() async {
    final pickedImage =
    await picker.pickImage(source: ImageSource.camera); //getImage?

    setState(() {
      if (pickedImage != null) {
        _imagePath = pickedImage.path;
      }
    });
  }
}

// Future<File> getImageFileFromAssets(String path) async {
//   final byteData = await rootBundle.load('assets/$path');
//
//   final file = File('${(await getTemporaryDirectory()).path}/$path');
//   await file.create(recursive: true);
//   await file.writeAsBytes(byteData.buffer
//       .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
//
//   return file;
// }

// class GetGet {
//   Future<File> printPath() async {
//     return await getImageFileFromAssets('default.png');
//   }
// }
