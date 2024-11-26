import 'package:eexily/components/cheffy_message.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  static Database? _database;

  static Future<void> init() async {
    DatabaseManager._database = await openDatabase(
      "eexily.db",
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE Messages "
            "("
                "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                "role TEXT NOT NULL, "
                "content TEXT NOT NULL, "
                "timestamp INTEGER NOT NULL "
            ")"
        );
      },
    );
  }

  static Future<List<CheffyMessage>> getMessages() async {
    List<Map<String, dynamic>>? response = await _database?.query(
      "Messages",
      orderBy: "timestamp ASC",
    );
    if (response == null) return [];

    List<CheffyMessage> messages = [];
    for (var element in response) {
      CheffyMessage msg = CheffyMessage.fromJson(element);
      messages.add(msg);
    }

    return messages;
  }

  static Future<void> addMessage(CheffyMessage message) async {
    Map<String, dynamic> map = message.toJson();
    map["timestamp"] = message.timestamp.millisecondsSinceEpoch;
    await _database?.transaction((txn) async {
      await txn.insert("Messages", map);
    });
  }

  static Future<void> clearAllMessages() async {
    await _database?.delete("Messages");
  }
}