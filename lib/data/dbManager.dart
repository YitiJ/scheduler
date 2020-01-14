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
  static String tblTaskHistory = "TaskHistory";
  static String tblTodo = "Todo";

  
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
    Batch batch = db.batch();
    // When creating the db, create the table
    batch.execute(
        "CREATE TABLE $tblTask("
            "id INTEGER PRIMARY KEY,"
            "name TEXT NOT NULL,"
            "description TEXT,"
            "isDeleted INTEGER DEFAULT 0)");
    batch.execute(
      "CREATE TABLE $tblCategory("
          "id INTEGER PRIMARY KEY,"
          "name TEXT NOT NULL)");
    batch.execute(
      "CREATE TABLE $tblTaskCategoryRel("
          "id INTEGER PRIMARY KEY,"
          "taskID INTEGER NOT NULL UNIQUE,"
          "categoryID INTEGER NOT NULL,"
          "FOREIGN KEY (taskID) REFERENCES $tblTask(id),"
          "FOREIGN KEY (categoryID) REFERENCES $tblCategory(id))");
    batch.execute(
      "CREATE TABLE $tblTaskHistory("
      "id INTEGER PRIMARY KEY,"
      "taskID INTEGER NOT NULL,"
      "startTime INTEGER NOT NULL,"
      "endTime INTEGER NOT NULL,"
      "FOREIGN KEY (taskID) REFERENCES $tblTask(id))");
    batch.execute(
      "CREATE TABLE $tblTodo("
      "id INTEGER PRIMARY KEY,"
      "taskID INTEGER NOT NULL,"
      "date INTEGER NOT NULL,"
      "duration INTEGER NOT NULL,"
      "completed INTEGER DEFAULT 0,"
      "FOREIGN KEY (taskID) REFERENCES $tblTask(id))"); 
    
    batch.insert(tblCategory, Category.none().toMap());
    await batch.commit(noResult: true);
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

    Future<List<Task>> getAllAvailTask() async{
    var dbClient = await database;
    List<Map> res = await dbClient.query(tblTask,where:'isDeleted = 0');
    List<Task> list = new List<Task>();
    res.forEach((row) => list.add(Task.fromMap(row)));
    return list;
  }

  Future<void> updateTask(Task task) async{
    var dbClient = await database;
     await dbClient.update(tblTask,task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<void> deleteTask(int id) async{
    try{
      var dbClient = await database;
      await dbClient.rawDelete("DELETE from $tblTask WHERE id = ?",[id]);
    }
    catch(_){
      Task task = await getTask(id);
      updateTask(task..isDeleted = true);
    }
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
     await dbClient.update(tblCategory,category.toMap(), where: 'id = ?', whereArgs: [category.id]);
  }

  Future<void> deleteCategory(int id) async{
    var dbClient = await database;
    await dbClient.delete(tblCategory,where: 'id = ?', whereArgs: [id]);
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
    return list;
  }

  Future<void> updateTaskCategoryRel(TaskCategoryRel taskCategoryRel) async{
    var dbClient = await database;
    await dbClient.rawUpdate("UPDATE $tblTaskCategoryRel SET categoryID = ? WHERE taskID = ?", [taskCategoryRel.categoryID,taskCategoryRel.taskID]);
  }

  Future<void> deleteTaskCategoryRel(int taskID, int categoryID) async{
    var dbClient = await database;
    await dbClient.delete(tblTaskCategoryRel,where: 'taskID = ? AND categoryID = ?', whereArgs: [taskID,categoryID]);
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

  Future<List<TaskHistory>> getTaskHistorysByDate(DateTime startTime, DateTime endTime) async{
    var dbClient = await database;
    List<Map> res = await dbClient.rawQuery(
      "SELECT * FROM $tblTaskHistory "
      "WHERE (startTime BETWEEN ? and ?) AND "
      "(endTime BETWEEN ? and ?)",
        [startTime.millisecondsSinceEpoch, endTime.millisecondsSinceEpoch,
        startTime.millisecondsSinceEpoch, endTime.millisecondsSinceEpoch]);
    List<TaskHistory> list = new List<TaskHistory>();
    res.forEach((row) => list.add(TaskHistory.fromMap(row)));
    return list;
  }

  Future<List<TaskHistory>> getTaskHistorysByTaskDate(DateTime startTime, DateTime endTime, int taskID) async{
    var dbClient = await database;
    List<Map> res = await dbClient.rawQuery(
      "SELECT * FROM $tblTaskHistory "
      "WHERE (startTime BETWEEN ? and ?) AND "
      "(endTime BETWEEN ? and ?) AND "
      "taskID = ?",
        [startTime.millisecondsSinceEpoch, endTime.millisecondsSinceEpoch,
        startTime.millisecondsSinceEpoch, endTime.millisecondsSinceEpoch,
        taskID]);
    List<TaskHistory> list = new List<TaskHistory>();
    res.forEach((row) => list.add(TaskHistory.fromMap(row)));
    return list;
  }
  
  Future<void> updateTaskHistory(TaskHistory taskHistory) async{
    var dbClient = await database;
    await dbClient.update(tblTaskHistory,taskHistory.toMap(), where: 'id = ?', whereArgs: [taskHistory.id]);
  }

  Future<void> deleteTaskHistory(int id) async{
    var dbClient = await database;
    await dbClient.delete(tblTaskHistory,where: 'id = ?', whereArgs: [id]);
  }

  //Todo CRUD Operation
  Future<int> insertTodo(Todo todo) async{
    var dbClient = await database;
    return await dbClient.insert(tblTodo,todo.toMap());
  }

  Future<Todo> getTodo(int id) async{
    var dbClient = await database;
    List<Map> res = await dbClient.query(tblTodo, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Todo.fromMap(res.first) : null;
  }

  Future<List<Todo>> getAllTodo() async{
    var dbClient = await database;
    List<Map> res = await dbClient.query(tblTodo);
    List<Todo> list = new List<Todo>();
    res.forEach((row) => list.add(Todo.fromMap(row)));
    return list;
  }

  Future<List<Todo>> getTodosByDate(DateTime startTime, DateTime endTime) async{
    var dbClient = await database;
    List<Map> res = await dbClient.rawQuery("SELECT * FROM $tblTodo WHERE date BETWEEN ? and ?",
        [startTime.millisecondsSinceEpoch, endTime.millisecondsSinceEpoch]);
    List<Todo> list = new List<Todo>();
    res.forEach((row) => list.add(Todo.fromMap(row)));
    return list;
  }

  Future<Todo> getTodoByTaskDate(DateTime date, int taskID) async{
    var dbClient = await database;
    List<Map> res = await dbClient.rawQuery("SELECT * FROM $tblTodo WHERE date = ? AND taskID = ?",
        [date.millisecondsSinceEpoch, taskID]);
    return res.isNotEmpty ? Todo.fromMap(res.first): null;
  }


  Future<void> updateTodo(Todo todo) async{
    var dbClient = await database;
    await dbClient.update(tblTodo,todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<void> deleteTodo(int id) async{
    var dbClient = await database;
    await dbClient.rawDelete("DELETE from $tblTodo WHERE id = ?",[id]);
  }


}
