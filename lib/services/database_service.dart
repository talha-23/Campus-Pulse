import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/event.dart';
import '../models/user_preferences.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'campus_notify.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE events(
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        date TEXT,
        location TEXT,
        category INTEGER,
        isReminderSet INTEGER,
        reminderTime TEXT,
        imageUrl TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE preferences(
        id INTEGER PRIMARY KEY DEFAULT 1,
        seminarNotifications INTEGER,
        examNotifications INTEGER,
        festNotifications INTEGER,
        noticeNotifications INTEGER,
        reminderTime INTEGER
      )
    ''');

    // Insert default preferences
    await db.insert('preferences', {
      'id': 1,
      'seminarNotifications': 1,
      'examNotifications': 1,
      'festNotifications': 1,
      'noticeNotifications': 1,
      'reminderTime': 30,
    });
  }

  // Event CRUD operations
  Future<void> insertEvent(Event event) async {
    final db = await database;
    await db.insert(
      'events',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Event>> getAllEvents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('events');
    return List.generate(maps.length, (i) => Event.fromMap(maps[i]));
  }

  // Preferences operations
  Future<UserPreferences> getPreferences() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = 
        await db.query('preferences', where: 'id = 1');
    if (maps.isNotEmpty) {
      return UserPreferences.fromMap(maps.first);
    }
    return UserPreferences(
      seminarNotifications: true,
      examNotifications: true,
      festNotifications: true,
      noticeNotifications: true,
    );
  }

  Future<void> updatePreferences(UserPreferences preferences) async {
    final db = await database;
    await db.update(
      'preferences',
      preferences.toMap(),
      where: 'id = 1',
    );
  }
}