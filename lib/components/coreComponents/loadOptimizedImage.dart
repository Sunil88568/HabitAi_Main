// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:path_provider/path_provider.dart';
// import '../../utils/appUtils.dart';
// import '../styles/appImages.dart';
//
//
// Future<ImageProvider> loadOptimizedImage(String? image) async {
//   if (image == null) return AssetImage('');
//
//   bool isNetworkImage = image.startsWith("http");
//   bool isServerImage = image.startsWith("/public/uploads/");
//   bool isFileImage = image.startsWith("/") && !isNetworkImage && !isServerImage;
//
//   if (isNetworkImage || isServerImage) {
//     String finalImage = isServerImage ? "$image" : image;
//     AppUtils.log('finalImage: $finalImage');
//
//     return NetworkImage(finalImage);
//   } else if (isFileImage) {
//     File file = File(image);
//     Uint8List? compressedBytes = await compressImage(file);
//     return MemoryImage(compressedBytes ?? await file.readAsBytes());
//   } else {
//     return AssetImage(AppImages.persionalInfo);
//   }
// }
//
// Future<Uint8List?> compressImage(File file) async {
//   final tempDir = await getTemporaryDirectory();
//   final targetPath = "${tempDir.path}/compressed_${file.uri.pathSegments.last}";
//
//   var result = await FlutterImageCompress.compressWithFile(
//     file.absolute.path,
//     minWidth: 300,
//     minHeight: 300,
//     quality: 70,
//     format: CompressFormat.jpeg,
//   );
//
//   return result;
// }
