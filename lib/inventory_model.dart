import 'package:isar/isar.dart';

import 'models/inventory_item_model.dart';

part 'g_files/inventory_model.g.dart';

@collection
class Inventory {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  final items = IsarLinks<InventoryItem>();
}