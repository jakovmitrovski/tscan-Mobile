import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/modules/ticket_information/model/transaction_dto.dart';
import 'dart:convert';

import 'package:squick/widgets/alert_dialog.dart';

class NetworkHelper {
  final Uri url;

  NetworkHelper(this.url);

  scanTicket(BuildContext context) async {
    http.Response response = await http
        .get(url, headers: {'Content-Type': 'application/json; charset=utf-8'});
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else if(response.statusCode == 404) {
      Alert(
          context: context,
          type: AlertType.error,
          title: 'Невалиден билет!',
          desc: 'Билетот кој го скениравте е невалиден.',
          style: AlertStyle(
              titleStyle: font16Medium.copyWith(color: colorBlueDark),
              descStyle: font14Regular.copyWith(color: colorBlueDarkLight)),
          buttons: [
            DialogButton(
              child: const Text(
                "Назад",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              onPressed: () => Navigator.pop(context),
              color: Colors.grey.shade400,
            ),
          ]).show();
    }
    else if(response.statusCode == 400) {
      Alert(
          context: context,
          type: AlertType.error,
          title: 'Грешка!',
          desc: 'Билетот кој го скениравте е веќе платен.',
          style: AlertStyle(
              titleStyle: font16Medium.copyWith(color: colorBlueDark),
              descStyle: font14Regular.copyWith(color: colorBlueDarkLight)),
          buttons: [
            DialogButton(
              child: const Text(
                "Назад",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              onPressed: () => Navigator.pop(context),
              color: Colors.grey.shade400,
            ),
          ]).show();
    }
  }

  Future<bool> newTransaction(
      TransactionDto transactionDto, BuildContext context) async {
    http.Response response = await http.post(url,
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode(transactionDto.toJSON()));

    print(jsonEncode(transactionDto.toJSON()));
    if (response.statusCode == 200) {

      return true;
    } else {
      return false;
    }
  }

  void _showErrorDialog(BuildContext context) {
    Alert(
        context: context,
        type: AlertType.warning,
        title: 'Настана грешка!',
        desc: 'Ве молиме обидете се повторно подоцна.',
        style: AlertStyle(
            titleStyle: font16Medium.copyWith(color: colorBlueDark),
            descStyle: font14Regular.copyWith(color: colorBlueDarkLight)),
        buttons: [
          DialogButton(
            child: const Text(
              "Назад",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            onPressed: () => Navigator.pop(context),
            color: Colors.grey.shade400,
          ),
        ]).show();
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
}
