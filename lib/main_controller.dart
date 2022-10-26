import 'dart:developer';

import 'package:sqlite_sample/data/base/data_result.dart';
import 'package:sqlite_sample/data/model/image_model.dart';
import 'package:sqlite_sample/data/image_repository.dart';

class MainController {
  final ImageRepositoryImplement _imageRepositoryImplement;
  List<ImageUrl> listImageUrl = List.empty(growable: true);

  MainController(this._imageRepositoryImplement);

  void insertImageUrl(ImageUrl student) async {
    DataResult dataResult =
        await _imageRepositoryImplement.insertImageUrl(student, "imageUrl");
    if (dataResult.isSuccess) {
      await getAllImageUrl();
      log("Success ${listImageUrl.length}");
    } else {
      if (dataResult.error is DatabaseFailure) {
        log("Error ${(dataResult.error as DatabaseFailure).errorMessage}");
      }
    }
  }

  Future<void> getAllImageUrl() async {
    DataResult dataResult = await _imageRepositoryImplement.getAllImageUrl();
    if (dataResult.isSuccess) {
      listImageUrl = dataResult.data;
      print('Dong 54 ${dataResult.data.length}');

    } else {
      if (dataResult.error is DatabaseFailure) {
        log("Error ${(dataResult.error as DatabaseFailure).errorMessage}");
        listImageUrl = List.empty();
      }
    }
  }
}
