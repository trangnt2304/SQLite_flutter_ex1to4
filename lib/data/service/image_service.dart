import 'package:sqflite/sqflite.dart';
import 'package:sqlite_sample/data/base/data_result.dart';
import 'package:sqlite_sample/data/database/image_database.dart';
import 'package:sqlite_sample/data/model/image_model.dart';

class ImageService {
  Future<DataResult> insertImageUrl(ImageUrl student, String tableName) async {
    try{
      Database db = await ImageDatabase.getInstance();
      int lastInsertedRow = await db.insert(tableName, student.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      return DataResult.success(lastInsertedRow);
    }catch(ex){
      return DataResult.failure(DatabaseFailure(ex.toString()));
    }
  }

  Future<DataResult> getAllImageUrl() async{
    try{
      Database db = await ImageDatabase.getInstance();
      final List<Map<String,dynamic>> maps = await db.query("imageUrl");
      List<ImageUrl> students = maps.map((e) => ImageUrl.fromMap(e)).toList();
      return DataResult.success(students);
    }catch(ex){
      return DataResult.failure(DatabaseFailure(ex.toString()));
    }
  }

}
