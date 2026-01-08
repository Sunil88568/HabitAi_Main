// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// class LocationPickerScreen extends StatefulWidget {
//   @override
//   State<LocationPickerScreen> createState() => _LocationPickerScreenState();
// }
// class _LocationPickerScreenState extends State<LocationPickerScreen> {
//   final MapController _mapController = MapController();
//   LatLng selectedLocation = LatLng(37.7749, -122.4194);
//   double radius = 1000;
//   bool isArriving = true;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(title: const Text("Select Location")),
//       body: Column(
//         children: [
//           _LocationSearchBar(
//             onLocationSelected: (latLng) {
//               setState(() => selectedLocation = latLng);
//               _mapController.move(latLng, 15);
//             },
//           ),
//           Expanded(
//             child: FlutterMap(
//               mapController: _mapController,
//               options: MapOptions(
//                 center: selectedLocation,
//                 zoom: 15,
//                 onTap: (tapPos, latLng) {
//                   setState(() => selectedLocation = latLng);
//                 },
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
//                 ),
//                 CircleLayer(
//                   circles: [
//                     CircleMarker(
//                       point: selectedLocation,
//                       radius: radius,
//                       useRadiusInMeter: true,
//                       color: Colors.blue.withOpacity(0.2),
//                       borderColor: Colors.blue,
//                       borderStrokeWidth: 2,
//                     ),
//                   ],
//                 ),
//                 MarkerLayer(
//                   markers: [
//                     Marker(
//                       point: selectedLocation,
//                       width: 40,
//                       height: 40,
//                       child: Icon(
//                         Icons.location_pin,
//                         size: 40,
//                         color: Colors.red,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           _RadiusSlider(
//             radius: radius,
//             onChanged: (value) {
//               setState(() => radius = value);
//             },
//           ),
//           _ArrivingLeavingToggle(
//             isArriving: isArriving,
//             onChanged: (value) {
//               setState(() => isArriving = value);
//             },
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: ElevatedButton(
//               onPressed: () {
//                 print({
//                   "lat": selectedLocation.latitude,
//                   "lng": selectedLocation.longitude,
//                   "radius": radius,
//                   "type": isArriving ? "arriving" : "leaving",
//                 });
//               },
//               child: const Text("Confirm Location"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _LocationSearchBar extends StatelessWidget {
//   final Function(LatLng) onLocationSelected;
//   const _LocationSearchBar({required this.onLocationSelected});
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8),
//       child: TypeAheadField<Map<String, dynamic>>(
//         builder: (context, controller, focusNode) {
//           return TextField(
//             controller: controller,
//             focusNode: focusNode,
//             decoration: const InputDecoration(
//               hintText: "Search location",
//               prefixIcon: Icon(Icons.search),
//               border: OutlineInputBorder(),
//             ),
//           );
//         },
//         suggestionsCallback: (query) async {
//           if (query.isEmpty || query.length < 3) return [];
//           try {
//             return await _searchPlaces(query);
//           } catch (e) {
//             return [];
//           }
//         },
//         itemBuilder: (context, suggestion) {
//           return ListTile(
//             leading: const Icon(Icons.location_on),
//             title: Text(suggestion['display_name'] ?? 'Unknown'),
//             subtitle: Text(
//               "${double.parse(suggestion['lat']).toStringAsFixed(4)}, ${double.parse(suggestion['lon']).toStringAsFixed(4)}",
//             ),
//           );
//         },
//         onSelected: (suggestion) {
//           onLocationSelected(
//             LatLng(double.parse(suggestion['lat']),
//                 double.parse(suggestion['lon'])),
//           );
//         },
//       ),
//     );
//   }
//
//   Future<List<Map<String, dynamic>>> _searchPlaces(String query) async {
//     final url = Uri.parse(
//       'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=5&addressdetails=1',
//     );
//
//     final response = await http.get(
//       url,
//       headers: {
//         'User-Agent': 'Flutter Location Picker App',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       return data.cast<Map<String, dynamic>>();
//     }
//     return [];
//   }
// }
//
// class _RadiusSlider extends StatelessWidget {
//   final double radius;
//   final ValueChanged<double> onChanged;
//
//   const _RadiusSlider({required this.radius, required this.onChanged});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text("Radius: ${radius.toInt()} meters"),
//         Slider(
//           min: 100,
//           max: 5000,
//           value: radius,
//           onChanged: onChanged,
//         ),
//       ],
//     );
//   }
// }
//
// class _ArrivingLeavingToggle extends StatelessWidget {
//   final bool isArriving;
//   final ValueChanged<bool> onChanged;
//
//   const _ArrivingLeavingToggle(
//       {required this.isArriving, required this.onChanged});
//
//   @override
//   Widget build(BuildContext context) {
//     return ToggleButtons(
//       isSelected: [isArriving, !isArriving],
//       onPressed: (index) {
//         onChanged(index == 0);
//       },
//       children: const [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16),
//           child: Text("Arriving"),
//         ),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16),
//           child: Text("Leaving"),
//         ),
//       ],
//     );
//   }
// }