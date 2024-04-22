library globals;

import 'package:stage_manager/models/inventory_item_model.dart';

import 'models/tag_model.dart';

List<Tag> selectedTags = [];

InventoryItem curEditItem = InventoryItem("", "", "", "", ItemType.prop);