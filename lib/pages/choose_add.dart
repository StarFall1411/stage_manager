import 'package:flutter/material.dart';
import 'package:stage_manager/models/inventory_item_model.dart';
import 'package:stage_manager/pages/add_item.dart';

import '../isar_service.dart';
import '../models/tag_model.dart';
import 'add_tag.dart';

class ChooseAddPage extends StatefulWidget {
  const ChooseAddPage({super.key});

  @override
  State<ChooseAddPage> createState() => _ChooseAddPageState();
}

class _ChooseAddPageState extends State<ChooseAddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text('Choose Item Type to Add'),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 10.0,
          ),
          _addItemTypePage(
              ItemType.prop, "Add Prop", Icons.architecture_outlined),
          //architecture attachment backpack bakery badge blender casino category celebration checkroom coffee color design
          _addItemTypePage(ItemType.furniture, "Add Furniture", Icons.deck),
          //bed chair deck weekend
          _addItemTypePage(ItemType.costume, "Add Costume", Icons.checkroom),
          //wc  woman hail girl
          _tagPage(),
        ],
      ),
    );
  }

  Widget _addItemTypePage(
      ItemType itemType, String cardText, IconData cardIcon) {
    IsarService isar = IsarService();
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth - 20.0,
      child: GestureDetector(
        onTap: () async {
          List<Tag> tags = [];
          await isar.getAllTags().then((value) {
            setState(() {
              tags = value;
            });
          });

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddItemPage(
                        addItemType: itemType,
                        tags: tags,
                      )));
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cardText,
                  style: const TextStyle(fontSize: 18.0),
                ),
                Icon(
                  cardIcon,
                  size: 30.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tagPage() {
    IsarService isar = IsarService();
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth - 20.0,
      child: GestureDetector(
        onTap: () async {
          List<InventoryItem> inventoryItems = [];
          await isar.getAllInventoryItems().then((value) {
            setState(() {
              inventoryItems = value;
            });
          });

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddTagPage(
                        inventoryItems: inventoryItems,
                      )));
        },
        child: const Card(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Add Tag",
                  style: TextStyle(fontSize: 18.0),
                ),
                Icon(
                  Icons.discount,
                  size: 30.0,
                ) //discount tag
              ],
            ),
          ),
        ),
      ),
    );
  }
}
