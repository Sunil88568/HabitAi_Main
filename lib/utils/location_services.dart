// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:water_bottle/main.dart';
// import 'package:water_bottle/utils/extensions/context_extensions.dart';
// import 'package:water_bottle/utils/extensions/text_style.dart';
//
// import '../components/coreComponents/common_button.dart';
// import '../components/coreComponents/text_view.dart';
//
// import 'package:permission_handler/permission_handler.dart';
// class LocationServices {
//   static late bool _serviceEnabled;
//   static late LocationPermission _permission;
//
//   static BuildContext? get _context => navState.currentState?.context;
//
//   static _serviceEnabledFun() async {
//     _serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!_serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }
//   }
//
//   static Future<int> _grantPermission() async{
//     final status = await Geolocator.requestPermission();
//     if(status == LocationPermission.denied){
//       return 2;
//     }else if(status == LocationPermission.deniedForever){
//       return 3;
//     }else if(status == LocationPermission.whileInUse || status == LocationPermission.always){
//       return 1;
//     }
//     return 0;
//   }
//
//
//
//
//
//   static Future<int> getPermission() async{
//     final status = await permissionStatus();
//     if(status == 1){
//       return status;
//     }else {
//      return await _grantPermission();
//     }
//   }
//
//   static appSettingsToast(){
//     BuildContext context = _context!;
//     context.openDialog( Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//          TextView(text: 'You need to allow location permission to get near by property',
//           style: 14.txtRegularBlack,
//           margin: const EdgeInsets.only(bottom: 20),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Expanded(
//               child: CommonButton(
//                 text: 'Cancel',
//                 clickAction: ()=>navState.currentContext!.stopLoader,
//               ),
//             ),
//             const SizedBox(width: 10,),
//             Expanded(
//               child: CommonButton(
//                 text: 'Go to settings',
//                 clickAction: () {
//                       navState.currentContext!.stopLoader;
//                       openAppSettings();
//                 },
//               ),
//             ),
//           ],
//         )
//       ],
//     ));
//   }
//
//   static Future<int> permissionStatus() async {
//     await _serviceEnabledFun();
//     _permission = await Geolocator.checkPermission();
//     if(_permission == LocationPermission.denied){
//       return 2;
//     }else if(_permission == LocationPermission.deniedForever){
//       return 3;
//     }else if(_permission == LocationPermission.whileInUse || _permission == LocationPermission.always){
//       return 1;
//     }
//     return 0;
//   }
//
//   static StreamSubscription<Position> listener()  {
//     const LocationSettings locationSettings =  LocationSettings(
//       accuracy: LocationAccuracy.high,
//       distanceFilter: 100,
//     );
//     return  Geolocator.getPositionStream(locationSettings: locationSettings).listen(
//             (Position? position) {
//           if (kDebugMode) {
//             print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
//           }
//         });
//   }
//
//   static Future<Position> currentLocation()  async{
//     if (kDebugMode && Platform.isIOS) {
//
//       return Position(
//         longitude: 76.726334,
//         latitude : 30.705629,
//         timestamp: DateTime.now(),
//         accuracy: 0,
//         altitude: 0,
//         altitudeAccuracy: 0,
//         heading: 0,
//         headingAccuracy: 0,
//         speed: 0,
//         speedAccuracy: 0,
//       );
//     }else{
//       const LocationSettings locationSettings =  LocationSettings(
//         accuracy: LocationAccuracy.high,
//         distanceFilter: 100,
//       );
//       return Geolocator.getCurrentPosition(locationSettings: locationSettings);
//     }
//   }
// }
