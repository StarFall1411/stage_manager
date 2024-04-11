import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stage_manager/pages/inventory.dart';

import 'isar_service.dart';

void main() async {
  runApp(const StageManager());
}

class StageManager extends StatelessWidget {
  const StageManager({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stage Manager',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromRGBO(205, 0, 0, 1),
          onPrimary: Color.fromRGBO(205, 0, 0, 1),
          secondary: Color.fromRGBO(237, 214, 85, 1),
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.red,
          background: Color.fromRGBO(41, 38, 38, 1),
          onBackground: Color.fromRGBO(188, 188, 183, 1),
          surface: Color.fromRGBO(150, 150, 150, 1),
          onSurface: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Stage Manager'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title});

  final String title;
  final service = IsarService();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return const InventoryPage();
    // return Scaffold(
    //   appBar: AppBar(
    //     // TRY THIS: Try changing the color here to a specific color (to
    //     // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
    //     // change color while the other colors stay the same.
    //     backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    //     centerTitle: true,
    //     title: Text(title),
    //     actions: [
    //       IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
    //     ],
    //   ),
    //   body: Center(
    //     child: Column(
    //       children: <Widget>[
    //         const SizedBox(
    //           height: 10,
    //         ),
    //         GestureDetector(
    //             onTap: () {
    //               Navigator.push(
    //                   context,
    //                   MaterialPageRoute(
    //                       builder: (context) => const InventoryPage()));
    //             },
    //             child: Card(
    //               child: SizedBox(
    //                 height: 80.0,
    //                 width: screenWidth - 15.0,
    //                 child: const Text('Inventory'), //const Text('Inventory')
    //               ),
    //             )),
    //       ],
    //     ),
    //   ),
    // );
  }
}
