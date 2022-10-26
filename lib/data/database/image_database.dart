import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ImageDatabase {
  static Database? _database;

  static Future<Database> getInstance() async {
    _database ??= await openDatabase(

        /// use join to create path for db, then the path will be path/student.db
        join(await getDatabasesPath(), "imageUrl.db"),

        /// This function will be called in the first time database is created
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE imageUrl(imageUrl TEXT)");
    },

        /// This version will use when you want to upgrade or downgrade the database
        version: 4,
        singleInstance: true);
    return _database!;
  }
}
