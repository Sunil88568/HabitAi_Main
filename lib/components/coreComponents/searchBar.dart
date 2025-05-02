// import 'package:flutter/material.dart';
//
// // import '../../feature/data/models/dataModels/autoCompleteAddressModel.dart';
//
// class AppSearchBar extends StatefulWidget {
//   const AppSearchBar({super.key});
//
//   @override
//   State<AppSearchBar> createState() => _SearchBarState();
// }
//
// class _SearchBarState extends State<AppSearchBar> {
//   final SearchController controller = SearchController();
//
//   final homeCtrl = HomeCtrl.find;
//
//   @override
//   Widget build(BuildContext context) {
//
//     return GetX<HomeCtrl>(
//       builder: (homeCtrl) {
//         return Scaffold(
//             appBar:AppBar(
//               actions: [
//                 IconButton(onPressed: (){
//                   showSearch(context: context, delegate:
//                   CustomSearchDelegate<AutoCompleteAddressModel>(
//                       searchList: homeCtrl.autoCompleteGeoAddressList,
//                       onSearch: homeCtrl.getAutoCompleteAddress,
//                       searchItemBuilder: (index)=> Text(homeCtrl.autoCompleteGeoAddressList[index].description ?? ''),
//
//
//                     searchFieldDecorationTheme:  InputDecorationTheme(
//                       hintStyle: TextStyle(),
//                       border: OutlineInputBorder(
//                         borderSide: BorderSide(
//                             color: Colors.red,
//                             width: 5.0),
//                       )
//                     ),
//                     )
//
//                     // InputDecorationTheme(
//                     //   border: InputBorder(
//                     //     borderSide: BorderSide(),
//                     //
//                     //   )
//                     // )
//                   // )
//
//
//
//                   );
//                 }, icon: Icon(Icons.search))
//               ],
//
//
//             ),
//           body: Column(
//             children: [
//
//               SizedBox(
//                 height: 0,
//                   width: 0,
//                   child: Text(homeCtrl.autoCompleteGeoAddressList.length.toString()))
//             ],
//           ),
//         );
//       }
//     );
//   }
// }
//
//
//
//
//
//
// class CustomSearchDelegate<T> extends SearchDelegate{
//   final List<T> searchList;
//   final Function(String) onSearch;
//   final Widget Function(int) searchItemBuilder;
//
//
//   CustomSearchDelegate( {super.searchFieldLabel,
//     super.searchFieldStyle,
//     super.searchFieldDecorationTheme,
//     super.keyboardType,
//     super.textInputAction,
//     required this.searchList,
//     required this.onSearch,
//     required this.searchItemBuilder,
//   });
//
//
//
//
//
//
//
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     onSearch(query);
//
//     print('buildActions.....');
//     return [IconButton(
//       icon: Icon(Icons.clear),
//       onPressed: (){
//         query = '';
//       }
//         )];
//   }
//
//   @override
//   Widget? buildLeading(BuildContext context) {
//     onSearch(query);
//     print('buildLeading.....');
//     return IconButton(
//         icon: Icon(Icons.arrow_back),
//         onPressed: (){
//           close(context, null);
//         }
//     );
//   }
//
//   @override
//   Widget buildResults(BuildContext context) {
//     onSearch(query);
//     print('buildResults.....');
//     // onSearch(query);
//
//
//     List<String> matchQuery =[];
//
//     return ListView.builder(
//       itemBuilder: (context, index) => searchItemBuilder(index),
//
//
//           // Text(matchQuery[index]),
//       itemCount: searchList.length,
//     );
//   }
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     onSearch(query);
//     // onSearch(query);
//     print('buildSuggestions.....');
//     List<String> matchQuery =[];
//
//     return ListView.builder(
//       itemBuilder: (context, index) => Text(matchQuery[index]),
//       itemCount: matchQuery.length,
//     );
//   }
//
// }
//
