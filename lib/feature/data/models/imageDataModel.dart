
import '../../../components/coreComponents/ImageView.dart';

class ImageDataModel {
  ImageType? type;
  String? network;
  String? file;
  String? asset;
  final ImageView ?imageView;

   ImageDataModel(
      { this.type,
        this.imageView,
       this.network,
       this.file,
       this.asset});
}
