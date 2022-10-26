import 'package:sqlite_sample/data/base/data_result.dart';
import 'package:sqlite_sample/data/service/image_service.dart';

import 'model/image_model.dart';

abstract class ImageRepository{
  Future<DataResult> insertImageUrl(ImageUrl imageUrl, String tableName);
  Future<DataResult> getAllImageUrl();
}

class ImageRepositoryImplement implements ImageRepository{
  final ImageService _imageService;


  ImageRepositoryImplement(this._imageService);

  @override
  Future<DataResult> insertImageUrl(ImageUrl image, String tableName) {
    return _imageService.insertImageUrl(image, tableName);
  }

  @override
  Future<DataResult> getAllImageUrl() {
    return _imageService.getAllImageUrl();
  }


}

