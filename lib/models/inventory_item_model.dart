import 'package:isar/isar.dart';
import 'package:stage_manager/models/tag_model.dart';

import 'inventory_model.dart';

part 'inventory_item_model.g.dart';

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

  @Backlink(to: "inventoryItems")
  final tags = IsarLinks<Tag>();

  // @Backlink(to: 'tags')
  // IsarLinks<Tag> tag = IsarLinks<Tag>();

  InventoryItem(this.name,this.picture,this.description,this.location,this.itemType);

}
