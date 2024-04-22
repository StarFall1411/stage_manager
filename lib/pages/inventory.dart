import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stage_manager/models/inventory_item_model.dart';
import 'package:stage_manager/models/tag_model.dart';
import 'package:stage_manager/pages/choose_add.dart';
import 'package:stage_manager/pages/view_item.dart';

import '../isar_service.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  IsarService isar = IsarService();
  String searchString = "";

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text('Inventory'),
        actions: [
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.settings),
          // )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ChooseAddPage()));
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add,color: Colors.white,),
      ),
      body: _body(screenWidth),
    );
  }

  Widget _body(double screenWidth){
    return Column(
      children: [
        const SizedBox(
          height: 10.0,
        ),
        SearchBar(
          hintText: "Search",
          onChanged: (string) {
            setState(() {
              searchString = string;
            });
          },
        ),
        const SizedBox(height: 10.0),
        Expanded(
          child: StreamBuilder<List<InventoryItem>>(
              stream: isar.getAllFilteredInventoryItems(searchString, []),
              //TODO replace with selected tags later
              builder: (context, snapshot) {
                List<InventoryItem> inventoryItems = snapshot.data ?? [];
                return Center(
                  child: SizedBox(
                    width: screenWidth - 20.0,
                    child: Column(children: [
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            File nonDefaultImage = File('assets/default.png');
                            if (!inventoryItems[index]
                                .picture!
                                .contains("default.png")) {
                              nonDefaultImage =
                                  File(inventoryItems[index].picture!);
                            }
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewItemPage(
                                          inventoryItem:
                                          inventoryItems[index],
                                        )));
                              },
                              child: Card(
                                child: Row(
                                  children: [
                                    inventoryItems[index]
                                        .picture!
                                        .contains("default.png")
                                        ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Image.asset(
                                        inventoryItems[index].picture!,
                                        height: 80.0,
                                        width: 80.0,
                                      ),
                                    )
                                        : ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Image.file(
                                        nonDefaultImage,
                                        height: 80.0,
                                        width: 80.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 10.0,),
                                    Text(inventoryItems[index].name)
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: inventoryItems.length,
                          // physics: const NeverScrollableScrollPhysics(), //TODO fix the scrolling
                        ),
                      ),
                    ]),
                  ),
                );
              }),
        )
      ],
    );
  }
}
