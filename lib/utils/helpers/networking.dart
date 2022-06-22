import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:squick/modules/ticket_information/model/transaction_dto.dart';
import 'package:squick/utils/helpers/alert.dart';
import 'dart:convert';

class NetworkHelper {
  final Uri url;

  NetworkHelper(this.url);

  scanTicket(BuildContext context) async {
    http.Response response = await http
        .get(url, headers: {'Content-Type': 'application/json; charset=utf-8'});
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else if(response.statusCode == 404) {
      AlertHelper.showAlert(context,
          title: 'Невалиден билет!',
          description: 'Билетот кој го скениравте не е валиден.',
          buttonText: 'Назад',
          onTap: () {
            Navigator.pop(context);
          }
      );
    }
    else if(response.statusCode == 400) {
      AlertHelper.showAlert(context,
          title: 'Грешка!',
          description: 'Билетот кој го скениравте е веќе платен.',
          buttonText: 'Назад',
          onTap: () {
            Navigator.pop(context);
          }
      );
    }else {
      AlertHelper.showAlert(context,
          title: 'Грешка!',
          description: 'Ве молиме обидете се повторно подоцна.',
          buttonText: 'Назад',
          onTap: () {
            Navigator.pop(context);
          }
      );
    }
  }

  Future<bool> newTransaction(
      TransactionDto transactionDto, BuildContext context) async {
    http.Response response = await http.post(url,
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode(transactionDto.toJSON()));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  void _showErrorDialog(BuildContext context) {
    AlertHelper.showAlert(context,
        title: 'Грешка!',
        description: 'Ве молиме обидете се повторно подоцна.',
        buttonText: 'Затвори ја TScan',
        onTap: () {
          exit(1);
        }
    );
  }

  Future<dynamic> getParkings(BuildContext context) async {
    http.Response response = await http
        .get(url, headers: {'Content-Type': 'application/json; charset=utf-8'});
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes)) as List;
    } else {
     _showErrorDialog(context);
     return null;
    }
  }

  Future<dynamic> getTransactions(BuildContext context) async {
    http.Response response = await http
        .get(url, headers: {'Content-Type': 'application/json; charset=utf-8'});
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      _showErrorDialog(context);
      return null;
    }
  }

  Future<dynamic> getSum(BuildContext context) async {
    http.Response response = await http
        .get(url, headers: {'Content-Type': 'application/json; charset=utf-8'});
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      _showErrorDialog(context);
      return null;
    }
  }

  Future<dynamic> createPaymentIntent({required int price, required int ticketId, required String userId}) async {
    http.Response response = await http.post(url, body: json.encode({
      'amount': price * 100,
      'ticketId': ticketId,
      'price': price,
      'userId': userId
    }), headers: {'Content-Type': 'application/json; charset=utf-8'});
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      return null;
    }
  }

  Future<dynamic> getDistFromApi({required double lat1, required double lon1, required double lat2, required double lon2}) async {
    Uri googleUrl = Uri.parse("https://maps.googleapis.com/maps/api/distancematrix/json?destinations=${lat1},${lon1}&origins=${lat2},${lon2}&mode=driving&key=AIzaSyAVdxBK8Tn2sPZTnO4Y_TMFfQjELISyf2s");
    http.Response response = await http.get(googleUrl);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["rows"][0]["elements"][0]["distance"]["text"];
    }else {
      return "0 м";
    }
  }
}
