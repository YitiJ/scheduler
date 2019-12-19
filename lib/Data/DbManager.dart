import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DbManager {
  DbManager._();
  static final DbManager instance = DbManager._();
  static final String _dbName = "main.db";
  static final int _dbVersion = 1;
  static Database _db;

  static String tblTask = "Task";
  static String tblCategory = "Category";
  static String tblTaskCategoryRel = "TaskCategoryRel";

  
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
          "TaskID INTEGER NOT NULL,"
          "CategoryID INTEGER NOT NULL,"
          "FOREIGN KEY (taskID) REFERENCES $tblTask(id),"
          "FOREIGN KEY (categoryID) REFERENCES $tblCategory(id))");
  }

  }