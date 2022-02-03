import 'package:http/http.dart' as http;
import 'dart:convert';


class NetworkHelper {
  final Uri url;

  NetworkHelper(this.url);

  scanTicket() async {
    http.Response response = await http.get(url, headers: {'Content-Type': 'application/json; charset=utf-8'});
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }else{
      //TODO: HANDLE ERROR
      print(response.statusCode);
    }
  }

  Future<dynamic> getParkings() async {
    http.Response response = await http.get(url, headers: {'Content-Type': 'application/json; charset=utf-8'});
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes)) as List;
    }else{
      //TODO: HANDLE ERROR
      print(response.statusCode);
      print(response.body);
    }
  }
}