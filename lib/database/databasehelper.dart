import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class Task {
  final int? id;
  final String title;
  final String dateTime;
  final String status;

  Task(
      {this.id,
      required this.title,
      required this.dateTime,
      required this.status});

  factory Task.fromMap(Map<String, dynamic> json) => Task(
      id: json["id"],
      title: json["title"],
      dateTime: json["dateTime"],
      status: json["status"]);

  Map<String, dynamic> toMap() {
    return {"id": id, "title": title, "dateTime": dateTime, "status": status};
  }
}

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ?? await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "tasks.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Task (id INTEGER PRIMARY KEY, title TEXT, dateTime TEXT, status TEXT)");
  }

  Future<int> add(Task task) async {
    Database db = await instance.database;
    return await db.insert("Task", task.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete("Task", where: "id=?", whereArgs: [id]);
  }

  Future<int> update(Task task) async {
    Database db = await instance.database;
    return await db
        .update("Task", task.toMap(), where: "id=?", whereArgs: [task.id]);
  }

  Future<List<Task>> getTask() async {
    Database db = await instance.database;
    var task = await db.query("Task", orderBy: "id");
    List<Task> taskList =
        task.isNotEmpty ? task.map((e) => Task.fromMap(e)).toList() : [];
    return taskList;
  }

  Future<int> changeStatus(Task task) async {
    String newStatus = task.status == "ACTIVE" ? "DONE" : "ACTIVE";
    Task newTask = Task(
        id: task.id,
        title: task.title,
        dateTime: task.dateTime,
        status: newStatus);
    return update(newTask);
  }
}
