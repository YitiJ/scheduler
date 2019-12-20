import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'models.dart';

class DbManager {
  DbManager._();
  static final DbManager instance = DbManager._();
  static final String _dbName = "main.db";
  static final int _dbVersion = 1;
  static Database _db;

  static String tblTask = "Task";
  static String tblCategory = "Category";
  static String tblTaskCategoryRel = "TaskCategoryRel";
  static String tblSchedule = "Schedule";

  
  Future<Database> get database async {
    if (_db != null)
      return _db;

    // if _database is null we instantiate it
    _db = await initDB();
    return _db;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, _dbName);
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE $tblTask("
            "id INTEGER PRIMARY KEY,"
            "name TEXT NOT NULL,"
            "description TEXT)");
    await db.execute(
      "CREATE TABLE $tblCategory("
          "id INTEGER PRIMARY KEY,"
          "type INTEGER NOT NULL,"
          "name TEXT NOT NULL)");
    await db.execute(
      "CREATE TABLE $tblTaskCategoryRel("
          "id INTEGER PRIMARY KEY,"
          "taskID INTEGER NOT NULL UNIQUE,"
          "categoryID INTEGER NOT NULL,"
          "FOREIGN KEY (taskID) REFERENCES $tblTask(id),"
          "FOREIGN KEY (categoryID) REFERENCES $tblCategory(id))");
    await db.execute(
      "CREATE TABLE $tblSchedule("
      "id INTEGER PRIMARY KEY,"
      "taskID INTEGER NOT NULL,"
      "startTime INTEGER NOT NULL,"
      "duration INTEGER NOT NULL,"
      "completed INTEGER DEFAULT 0,"
      "FOREIGN KEY (taskID) REFERENCES $tblTask(id))");
  }

  void testScript() async{
    insertTask(Task.newTask("1",null));
    insertTask(Task.newTask("2","hi"));

    insertCategory(Category.newCategory("homework",0));

    List<Task> tasks = await getAllTask();
    List<Category> cat = await getAllCategory();

    tasks.forEach((row) => insertTaskCategoryRel(TaskCategoryRel.newRelation(row.id,cat[0].id)));

    List<TaskCategoryRel> rel = await getAllTaskCategoryRel();
  }

//db CRUD Operation

//Task CRUD Operation
  Future<void> insertTask(Task task) async{
    var dbClient = await database;
    int res = await dbClient.insert(tblTask,task.toMap());
  }

  Future<Task> getTask(int id) async{
    var dbClient = await database;
    List<Map> res = await dbClient.query(tblTask, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Task.fromMap(res.first) : null;
  }

  Future<List<Task>> getAllTask() async{
     var dbClient = await database;
    List<Map> res = await dbClient.query(tblTask);
    List<Task> list = new List<Task>();
    res.forEach((row) => list.add(Task.fromMap(row)));
    return list;
  }

  Future<void> updateTask(Task task) async{
    var dbClient = await database;
    int res = await dbClient.update(tblTask,task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<void> deleteTask(int id) async{
    var dbClient = await database;
    int res = await dbClient.delete(tblTask,where: 'id = ?', whereArgs: [id]);
  }


//Category CRUD Operation
  Future<void> insertCategory(Category category) async{
    var dbClient = await database;
    int res = await dbClient.insert(tblCategory,category.toMap());
  }

  Future<Category> getCateogry(int id) async{
    var dbClient = await database;
    List<Map> res = await dbClient.query(tblCategory, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Category.fromMap(res.first) : null;
  }

  Future<List<Category>> getAllCategory() async{
     var dbClient = await database;
    List<Map> res = await dbClient.query(tblCategory);
    List<Category> list = new List<Category>();
    res.forEach((row) => list.add(Category.fromMap(row)));
    return list;
  }
  
  Future<void> updateCategory(Category category) async{
    var dbClient = await database;
    int res = await dbClient.update(tblCategory,category.toMap(), where: 'id = ?', whereArgs: [category.id]);
  }

  Future<void> deleteCategory(int id) async{
    var dbClient = await database;
    int res = await dbClient.delete(tblCategory,where: 'id = ?', whereArgs: [id]);
  }
  

//TaskCategory CRUD Operation
  Future<void> insertTaskCategoryRel(TaskCategoryRel taskCategoryRel) async{
    var dbClient = await database;
    int res = await dbClient.insert(tblTaskCategoryRel,taskCategoryRel.toMap());
  }
  
  Future<TaskCategoryRel> getTaskCategoryRel(int id) async{
    var dbClient = await database;
    List<Map> res = await dbClient.query(tblTaskCategoryRel, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? TaskCategoryRel.fromMap(res.first) : null;
  }

  Future<TaskCategoryRel> getTaskCategory(int taskID) async{
    var dbClient = await database;
    List<Map> res = await dbClient.query(tblTaskCategoryRel, where: "taskOD = ?", whereArgs: [taskID]);
    return res.isNotEmpty ? TaskCategoryRel.fromMap(res.first) : null;
  }

  Future<List<TaskCategoryRel>> getAllTaskCategoryRel() async{
     var dbClient = await database;
    List<Map> res = await dbClient.query(tblTaskCategoryRel);
    List<TaskCategoryRel> list = new List<TaskCategoryRel>();
    res.forEach((row) => list.add(TaskCategoryRel.fromMap(row)));
    return list;
  }

  Future<void> updateTaskCategoryRel(TaskCategoryRel taskCategoryRel) async{
    var dbClient = await database;
    int res = await dbClient.update(tblTaskCategoryRel,taskCategoryRel.toMap(), where: 'id = ?', whereArgs: [taskCategoryRel.id]);
  }

  Future<void> deleteTaskCategoryRel(int taskID, int categoryID) async{
    var dbClient = await database;
    int res = await dbClient.delete(tblTaskCategoryRel,where: 'taskID = ? AND categoryID = ?', whereArgs: [taskID,categoryID]);
  }

  //Schedule CRUD Operation
  Future<void> insertSchedule(Schedule schedule) async{
    var dbClient = await database;
    int res = await dbClient.insert(tblSchedule,schedule.toMap());
  }

  Future<Schedule> getSchedule(int id) async{
    var dbClient = await database;
    List<Map> res = await dbClient.query(tblSchedule, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Schedule.fromMap(res.first) : null;
  }

  Future<List<Schedule>> getAllSchedule() async{
     var dbClient = await database;
    List<Map> res = await dbClient.query(tblSchedule);
    List<Schedule> list = new List<Schedule>();
    res.forEach((row) => list.add(Schedule.fromMap(row)));
    return list;
  }
  
  Future<void> updateSchedule(Schedule schedule) async{
    var dbClient = await database;
    int res = await dbClient.update(tblSchedule,schedule.toMap(), where: 'id = ?', whereArgs: [schedule.id]);
  }

  Future<void> deleteSchedule(int id) async{
    var dbClient = await database;
    int res = await dbClient.delete(tblSchedule,where: 'id = ?', whereArgs: [id]);
  }
}
