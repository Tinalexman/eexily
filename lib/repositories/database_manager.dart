import 'package:get_it/get_it.dart';

import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  static Future<void> init() async {
    Database database = await openDatabase(
      "rediones.db",
      version: 1,
      onCreate: (db, version) async {
 //        await db.execute('''
 //   CREATE TABLE ${UserRepository.userTable} (
 //     id INTEGER PRIMARY KEY AUTOINCREMENT,
 //     serverID TEXT NOT NULL,
 //     profilePicture TEXT NOT NULL,
 //     email TEXT NOT NULL,
 //     nickname TEXT NOT NULL,
 //     firstName TEXT NOT NULL,
 //     lastName TEXT NOT NULL,
 //     otherName TEXT NOT NULL,
 //     school TEXT NOT NULL,
 //     address TEXT NOT NULL,
 //     description TEXT NOT NULL,
 //     gender TEXT NOT NULL
 //   )
 // ''');



      },
    );
    GetIt.I.registerSingleton<Database>(database);

  }


  static Future<void> clearDatabase() async {
    Database database = GetIt.I.get();

  }
}


