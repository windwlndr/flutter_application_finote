import 'package:flutter_application_finote/models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static const tableUser = 'users';
  //static const tableStudent = 'students';
  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'finote.db'),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE $tableUser(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, password TEXT)",
        );
      },
      // onUpgrade: (db, oldVersion, newVersion) async {
      //   if (newVersion == 2) {
      //     await db.execute(
      //       "CREATE TABLE $tableStudent(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, class TEXT, age int)",
      //     );
      //   }
      // },

      version: 1,
    );
  }

  static Future<void> registerUser(UserModel user) async {
    final dbs = await db();
    //Insert adalah fungsi untuk menambahkan data (CREATE)
    await dbs.insert(
      tableUser,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(user.toMap());
  }

  static Future<UserModel?> loginUser({
    //required String name,
    required String email,
    required String password,
  }) async {
    final dbs = await db();
    //query adalah fungsi untuk menampilkan data (READ)
    final List<Map<String, dynamic>> results = await dbs.query(
      tableUser,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }
    return null;
  }

  //GET USER
  static Future<List<UserModel>> getAllUser() async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(tableUser);
    print(results.map((e) => UserModel.fromMap(e)).toList());
    return results.map((e) => UserModel.fromMap(e)).toList();
  }

  //UPDATE
  static Future<void> updateUser(UserModel user) async {
    final dbs = await db();
    //Insert adalah fungsi untuk menambahkan data (CREATE)
    await dbs.update(
      tableUser,
      user.toMap(),
      where: "id = ?",
      whereArgs: [user.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(user.toMap());
  }

  //DELETE
  static Future<void> deleteUser(int id) async {
    final dbs = await db();
    //Insert adalah fungsi untuk menambahkan data (CREATE)
    await dbs.delete(
      tableUser,
      where: "id = ?",
      whereArgs: [id]
    );
  }
}