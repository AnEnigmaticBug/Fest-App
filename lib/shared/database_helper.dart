import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

Database _database;

Future<Database> databaseInstance() async {
  if (_database != null) {
    return _database;
  }

  String dbPath = path.join(await getDatabasesPath(), 'fest.db');
  _database = await openDatabase(dbPath, version: 1, onCreate: (db, _) async {
    await db.execute('''PRAGMA foreign_keys = ON''');

    await db.execute('''
      CREATE TABLE Event(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        about TEXT NOT NULL,
        rules TEXT NOT NULL,
        dateTime TEXT NOT NULL,
        duration INTEGER NOT NULL,
        prize TEXT NOT NULL,
        isStarred INTEGER NOT NULL CHECK(isStarred IN (0, 1))
      )
    ''');

    await db.execute('''
      CREATE TABLE EventSpot(
        name TEXT PRIMARY KEY
      )
    ''');

    await db.execute('''
      CREATE TABLE EventType(
        name TEXT PRIMARY KEY
      )
    ''');

    await db.execute('''
      CREATE TABLE EventAndSpot(
        eventId INTEGER NOT NULL,
        spotName TEXT NOT NULL,
        PRIMARY KEY(eventId, spotName),
        FOREIGN KEY(eventId) REFERENCES Event(id) ON DELETE CASCADE,
        FOREIGN KEY(spotName) REFERENCES EventSpot(name) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE EventAndType(
        eventId INTEGER NOT NULL,
        typeName INTEGER NOT NULL,
        PRIMARY KEY(eventId, typeName),
        FOREIGN KEY(eventId) REFERENCES Event(id) ON DELETE CASCADE,
        FOREIGN KEY(typeName) REFERENCES EventType(name) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE EventFilter(
        ongoingOnly INTEGER NOT NULL CHECK(ongoingOnly IN (0, 1)),
        starredOnly INTEGER NOT NULL CHECK(starredOnly IN (0, 1)),
        PRIMARY KEY(ongoingOnly, starredOnly)
      )
    ''');

    await db.rawInsert('''
      INSERT INTO EventFilter(ongoingOnly, starredOnly)
      VALUES (0, 0)
    ''');

    await db.execute('''
      CREATE TABLE EventFilterAndSpot(
        spotName INTEGER PRIMARY KEY,
        FOREIGN KEY(spotName) REFERENCES EventSpot(name) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE EventFilterAndType(
        typeName INTEGER PRIMARY KEY,
        FOREIGN KEY(typeName) REFERENCES EventType(name) ON DELETE CASCADE
      )
    ''');
  });

  return _database;
}
