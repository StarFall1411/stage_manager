import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stage_manager/models/inventory_item_model.dart';
import 'package:stage_manager/models/tag_model.dart';
import 'models/inventory_model.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [InventorySchema,InventoryItemSchema,TagSchema],
        inspector: true,
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  Future<void> addItem(InventoryItem newItem) async{
    final isar = await db;
    isar.writeTxnSync((){
      isar.inventoryItems.putSync(newItem);
    });
  }

  Future<void> addTagsToItem(InventoryItem newItem,List<Tag> newTags) async{
    final isar = await db;
    InventoryItem? item = await isar.inventoryItems.where().idEqualTo(newItem.id).findFirst();

    item!.tags.load();
    for(Tag tag in newTags){
      item.tags.add(tag);
    }

    isar.writeTxnSync((){
      isar.inventoryItems.putSync(item);
    });
  }

  Future<void> addTagToItems(List<InventoryItem> inventoryItems,Tag newTag) async{
    final isar = await db;
    for(InventoryItem inventoryItem in inventoryItems){
      InventoryItem? item = await isar.inventoryItems.where().idEqualTo(inventoryItem.id).findFirst();
      item!.tags.load();
      item.tags.add(newTag);
      isar.writeTxnSync((){
        isar.inventoryItems.putSync(item);
      });
    }
  }

  Future<List<InventoryItem>> getAllInventoryItems() async {
    final isar = await db;
    return await isar.inventoryItems.where().sortByName().findAll();
  }

  Stream<List<InventoryItem>> getAllFilteredInventoryItems(String searchString,List<Tag> filterTags) async* {//TODO better searches
    final isar = await db;
    final query = isar.inventoryItems.where().filter().nameContains(searchString,caseSensitive: false).tags((q){
      return q.allOf(filterTags, (q, Tag tag) => q.idEqualTo(tag.id));
    }).sortByName();

    await for(final results in query.watch(fireImmediately: true)){
      if(results.isNotEmpty){
        yield results;
      }
    }
  }

  Future<void> deleteItem(InventoryItem item)async{
    final isar = await db;
    bool success = false;
    await isar.writeTxn(()async{
      success = await isar.inventoryItems.delete(item.id);
    });

    if(success){
      //TODO give good feedback
    }else{
      //TODO give bad feedback
      print("Did not delete");
    }
  }

  Future<void> addTag(Tag newTag)async{
    final isar = await db;
    isar.writeTxnSync((){
      isar.tags.putSync(newTag);
    });
  }

  Future<List<Tag>> getAllTags() async {
    final isar = await db;
    return await isar.tags.where().sortByName().findAll();
  }

  // Future<void> saveCourse(Course newCourse) async {
  //   final isar = await db;
  //   isar.writeTxnSync<int>(() => isar.courses.putSync(newCourse));
  // }

  // Future<void> saveStudent(Student newStudent) async {
  //   final isar = await db;
  //   isar.writeTxnSync<int>(() => isar.students.putSync(newStudent));
  // }

  // Future<void> saveTeacher(Teacher newTeacher) async {
  //   final isar = await db;
  //   isar.writeTxnSync<int>(() => isar.teachers.putSync(newTeacher));
  // }

  // Future<List<Course>> getAllCourses() async {
  //   final isar = await db;
  //   return await isar.courses.where().findAll();
  // }

  // Stream<List<Course>> listenToCourses() async* {
  //   final isar = await db;
  //   yield* isar.courses.where().watch(initialReturn: true);
  // }

  // Future<List<Student>> getStudentsFor(Course course) async {
  //   final isar = await db;
  //   return await isar.students
  //       .filter()
  //       .courses((q) => q.idEqualTo(course.id))
  //       .findAll();
  // }

  // Future<Teacher?> getTeacherFor(Course course) async {
  //   final isar = await db;
  //
  //   final teacher = await isar.teachers
  //       .filter()
  //       .course((q) => q.idEqualTo(course.id))
  //       .findFirst();
  //
  //   return teacher;
  // }
  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }
}
