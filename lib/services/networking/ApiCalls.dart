import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiCalls{
  static Future<Map<String,dynamic>> get({required String url, Map<String,String>? query}) async{

    try {
      Uri uri = Uri.parse(url,);
      if(query != null){
       final tempUri = uri.replace(queryParameters: query);
       uri = tempUri;
      }

      print(uri.path);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String,dynamic>;
        return data;
      } else {
        final data = jsonDecode(response.body) as Map<String,dynamic>;
        throw data['message'];
      }
    } catch (e) {
      throw e;
    }

  }

  static Future<Map<String,dynamic>> post({required String url, required Map<String,dynamic> body }) async{
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      print('url: ${url}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String,dynamic>;
        return data;
      } else {
        final data = jsonDecode(response.body) as Map<String,dynamic>;
        throw data['message'];
      }
    } catch (error) {
      throw error;
    }

  }
}