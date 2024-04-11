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
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ChooseAddPage()));
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: Column(
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
                                child: SizedBox(
                                  width: screenWidth - 15.0,
                                  child: Row(
                                    children: [
                                      inventoryItems[index]
                                              .picture!
                                              .contains("default.png")
                                          ? Image.asset(
                                              inventoryItems[index].picture!,
                                              height: 80.0,
                                              width: 80.0,
                                            )
                                          : Image.file(
                                              nonDefaultImage,
                                              height: 80.0,
                                              width: 80.0,
                                              fit: BoxFit.cover,
                                            ),
                                      Text(inventoryItems[index].name)
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: inventoryItems.length,
                          // physics: const NeverScrollableScrollPhysics(), //TODO fix the scrolling
                        ),
                      ),
                    ]),
                  );
                }),
          )
        ],
      ),
    );

    // Card(
    //   child: SizedBox(
    //     height: 80.0,
    //     width: screenWidth - 15.0,
    //     child: Text(inventoryItems?[index].name ??
    //         'No Item'),
    //   ),
    // );
  }

// Widget _futureBuilder() {
//   return FutureBuilder(
//       future: isar.getAllFilteredInventoryItems(searchController.text),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           // If we got an error
//           if (snapshot.hasError) {
//             return const Card(
//               child: Text("Snapshot has error"),
//             );
//
//             // if we got our data
//           } else if (snapshot.hasData) {
//             // Extracting data from snapshot object
//             List<InventoryItem>? inventoryItems = snapshot.data;
//             return Expanded(
//               child: Center(
//                 child: Column(children: [
//                   Expanded(
//                     child: ListView.builder(
//                       itemBuilder: (BuildContext context, int index) {
//                         return GestureDetector(
//                           onTap: () {
//                             if (inventoryItems?[index] != null) {
//                               Navigator.push(context,
//                                   MaterialPageRoute(builder: (context) =>
//                                       ViewItemPage(
//                                         inventoryItem: inventoryItems![index],)));
//                             }
//                             //TODO put a message saying like item doesnt exist or something like that
//                           },
//                           child: Card(
//                             child: SizedBox(
//                               width: screenWidth - 15.0,
//                               child: Row(
//                                 children: [
//                                   Image.asset(
//                                     'assets/default.png',
//                                     height: 80.0,
//                                     width: 80.0,
//                                   ),
//                                   Text(inventoryItems?[index].name ??
//                                       'No Item')
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                       itemCount: inventoryItems?.length,
//                       // physics: const NeverScrollableScrollPhysics(), //TODO fix the scrolling
//                     ),
//                   ),
//                 ]),
//               ),
//             );
//           }
//           return const Card(
//             child: Text("Other error message"),
//           );
//         }
//         return const Card(
//           child: Text(
//               "Connection not done."), //TODO make this a CircularProgressIndicator()
//         );
//       })
// }
}
