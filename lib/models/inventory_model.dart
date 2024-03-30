import 'package:isar/isar.dart';

import 'inventory_item_model.dart';

part 'inventory_model.g.dart';

@collection
class Inventory {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  final items = IsarLinks<InventoryItem>();
}