import 'package:isar/isar.dart';
import 'package:stage_manager/models/inventory_item_model.dart';

part 'tag_model.g.dart';

@collection
class Tag{
  Id id = Isar.autoIncrement;

  late String name;

  final inventoryItems = IsarLinks<InventoryItem>();

  Tag(String name){
    this.name = name;
  }
}