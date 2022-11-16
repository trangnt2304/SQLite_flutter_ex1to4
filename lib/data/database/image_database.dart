import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ImageDatabase {
  static Database? _database;

  static Future<Database> getInstance() async {
    _database ??= await openDatabase(
        join(await getDatabasesPath(), "imageUrl.db"), onCreate: (db, version) {
      return db.execute("CREATE TABLE imageUrl(imageUrl TEXT)");
    }, version: 4, singleInstance: true);
    return _database!;
  }
}
