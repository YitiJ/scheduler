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
  static String tblTaskHistory = "taskHistory";

  
  Future<Database> get database async {
    if (_db != null)
      return _db;

    // if _database is null we instantiate it
    _db = await initDB();
    //testScript();
    return _db;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, _dbName);
    return await openDatabase(path, version: 1, onOpen: (db) {
      db.execute("PRAGMA foreign_keys = ON;"); 
    },
    onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE $tblTask("
            "id INTEGER PRIMARY KEY,"
            "name TEXT NOT NULL,"
            "description TEXT,"
            "isDeleted INTEGER DEFAULT 0)");
    db.execute(
      "CREATE TABLE $tblCategory("
          "id INTEGER PRIMARY KEY,"
          "name TEXT NOT NULL)").then(
            (onValue) {
              instance.insertCategory(Category.none());
              }
          );
    await db.execute(
      "CREATE TABLE $tblTaskCategoryRel("
          "id INTEGER PRIMARY KEY,"
          "taskID INTEGER NOT NULL UNIQUE,"
          "categoryID INTEGER NOT NULL,"
          "FOREIGN KEY (taskID) REFERENCES $tblTask(id) ON DELETE CASCADE,"
          "FOREIGN KEY (categoryID) REFERENCES $tblCategory(id))");
    await db.execute(
      "CREATE TABLE $tblTaskHistory("
      "id INTEGER PRIMARY KEY,"
      "taskID INTEGER NOT NULL,"
      "startTime INTEGER NOT NULL,"
      "endTime INTEGER NOT NULL,"
      "FOREIGN KEY (taskID) REFERENCES $tblTask(id))");
  }

//db CRUD Operation

//Task CRUD Operation
  Future<int> insertTask(Task task) async{
    var dbClient = await database;
    return await dbClient.insert(tblTask,task.toMap());
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
    int res = await dbClient.rawDelete("DELETE from $tblTask WHERE id = ?",[id]);
  }


//Category CRUD Operation
  Future<int> insertCategory(Category category) async{
    var dbClient = await database;
    return await dbClient.insert(tblCategory,category.toMap());
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
  Future<int> insertTaskCategoryRel(TaskCategoryRel taskCategoryRel) async{
    var dbClient = await database;
    return await dbClient.insert(tblTaskCategoryRel,taskCategoryRel.toMap());
  }
  
  Future<TaskCategoryRel> getTaskCategoryRel(int id) async{
    var dbClient = await database;
    List<Map> res = await dbClient.query(tblTaskCategoryRel, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? TaskCategoryRel.fromMap(res.first) : null;
  }

  Future<TaskCategoryRel> getTaskCategory(int taskID) async{
    var dbClient = await database;
    List<Map> res = await dbClient.query(tblTaskCategoryRel, where: "taskID = ?", whereArgs: [taskID]);
    return res.isNotEmpty ? TaskCategoryRel.fromMap(res.first) : null;
  }

  Future<List<TaskCategoryRel>> getAllTaskCategoryRel() async{
     var dbClient = await database;
    List<Map> res = await dbClient.query(tblTaskCategoryRel);
    List<TaskCategoryRel> list = new List<TaskCategoryRel>();
    res.forEach((row) => list.add(TaskCategoryRel.fromMap(row)));
    list;
    return list;
  }

  Future<void> updateTaskCategoryRel(TaskCategoryRel taskCategoryRel) async{
    var dbClient = await database;
    int res = await dbClient.rawUpdate("UPDATE $tblTaskCategoryRel SET categoryID = ? WHERE taskID = ?", [taskCategoryRel.categoryID,taskCategoryRel.taskID]);
  }

  Future<void> deleteTaskCategoryRel(int taskID, int categoryID) async{
    var dbClient = await database;
    int res = await dbClient.delete(tblTaskCategoryRel,where: 'taskID = ? AND categoryID = ?', whereArgs: [taskID,categoryID]);
  }

  //TaskHistory CRUD Operation
  Future<int> insertTaskHistory(TaskHistory taskHistory) async{
    var dbClient = await database;
    return await dbClient.insert(tblTaskHistory,taskHistory.toMap());
  }

  Future<TaskHistory> getTaskHistory(int id) async{
    var dbClient = await database;
    List<Map> res = await dbClient.query(tblTaskHistory, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? TaskHistory.fromMap(res.first) : null;
  }

  Future<List<TaskHistory>> getAllTaskHistory() async{
     var dbClient = await database;
    List<Map> res = await dbClient.query(tblTaskHistory);
    List<TaskHistory> list = new List<TaskHistory>();
    res.forEach((row) => list.add(TaskHistory.fromMap(row)));
    return list;
  }
  
  Future<void> updateTaskHistory(TaskHistory taskHistory) async{
    var dbClient = await database;
    int res = await dbClient.update(tblTaskHistory,taskHistory.toMap(), where: 'id = ?', whereArgs: [taskHistory.id]);
  }

  Future<void> deleteTaskHistory(int id) async{
    var dbClient = await database;
    int res = await dbClient.delete(tblTaskHistory,where: 'id = ?', whereArgs: [id]);
  }
}
