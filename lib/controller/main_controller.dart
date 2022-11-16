import 'dart:developer';

import 'package:sqlite_sample/data/base/data_result.dart';
import 'package:sqlite_sample/data/image_repository.dart';
import 'package:sqlite_sample/data/model/image_model.dart';

class MainController {
  final ImageRepositoryImplement _imageRepositoryImplement;
  List<ImageUrl> listImageUrl = List.empty(growable: true);

  MainController(this._imageRepositoryImplement);

  Future<List<ImageUrl>> insertImageUrl(ImageUrl student) async {
    DataResult dataResult =
        await _imageRepositoryImplement.insertImageUrl(student, "imageUrl");
    if (dataResult.isSuccess) {
      await getAllImageUrl();
      log("Success ${listImageUrl.length}");
      return listImageUrl;
    } else {
      if (dataResult.error is DatabaseFailure) {
        log("Error ${(dataResult.error as DatabaseFailure).errorMessage}");
        return <ImageUrl>[];
      }
    }
    return <ImageUrl>[];
  }

  Future<void> getAllImageUrl() async {
    DataResult dataResult = await _imageRepositoryImplement.getAllImageUrl();
    if (dataResult.isSuccess) {
      listImageUrl = dataResult.data;
    } else {
      if (dataResult.error is DatabaseFailure) {
        log("Error ${(dataResult.error as DatabaseFailure).errorMessage}");
        listImageUrl = List.empty();
      }
    }
  }
}
