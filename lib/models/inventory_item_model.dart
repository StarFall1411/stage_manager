import 'package:isar/isar.dart';

import '../inventory_model.dart';

part '../g_files/inventory_item_model.g.dart';

enum ItemType { prop, furniture, costume }

@collection
class InventoryItem {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  @enumerated
  late ItemType itemType;

  late String name;
  String? picture;
  String? description;
  String? location;
  //Tags in the future

  @Backlink(to: 'items')
  final inventory = IsarLinks<Inventory>();

  InventoryItem(String name,String? picture,String? description,String? location,ItemType itemType){
    this.name = name;
    this.picture = picture;
    this.description = description;
    this.location = location;
    this.itemType = itemType;
  }

}
