import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stage_manager/models/inventory_item_model.dart';
import 'package:stage_manager/pages/choose_add.dart';

import '../isar_service.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  IsarService isar = IsarService();

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
          const SearchBar(
            hintText: "Search",
          ),
          const SizedBox(height: 10.0),
          FutureBuilder(
              future: isar.getAllInventoryItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If we got an error
                  if (snapshot.hasError) {
                    return const Card(
                      child: Text("Snapshot has error"),
                    );

                    // if we got our data
                  } else if (snapshot.hasData) {
                    // Extracting data from snapshot object
                    List<InventoryItem>? inventoryItems = snapshot.data;
                    return Expanded(
                      child: Center(
                        child: Column(children: [
                          Expanded(
                            child: ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: SizedBox(
                                    width: screenWidth - 15.0,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/default.png',
                                          height: 80.0,
                                          width: 80.0,
                                        ),
                                        Text(inventoryItems?[index].name ??
                                            'No Item')
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: inventoryItems?.length,
                              // physics: const NeverScrollableScrollPhysics(), //TODO fix the scrolling
                            ),
                          ),
                        ]),
                      ),
                    );
                  }
                  return const Card(
                    child: Text("Other error message"),
                  );
                }
                return const Card(
                  child: Text(
                      "Connection not done."), //TODO make this a CircularProgressIndicator()
                );
              })
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
}
