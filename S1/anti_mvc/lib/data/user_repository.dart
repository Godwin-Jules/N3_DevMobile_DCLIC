import 'package:sqflite/sqflite.dart';
import '../models/user.dart';
import 'app_database.dart';

class UserRepository {
  Future<User?> findByUsername(String username) async {
    final Database db = await AppDatabase.instance.database;
    final rows = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return User.fromMap(rows.first);
  }

  Future<int> createUser(User user) async {
    final Database db = await AppDatabase.instance.database;
    return db.insert('users', user.toMap());
  }
}
