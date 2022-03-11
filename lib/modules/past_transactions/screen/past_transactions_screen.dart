import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:squick/modules/past_transactions/model/transaction.dart';
import 'package:squick/utils/helpers/networking.dart';
import 'package:squick/constants/api_constants.dart';
import 'package:squick/utils/helpers/parse_utils.dart';

class TransactionsScreen extends StatefulWidget {
  static const String id = "/transactions";

  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {

  List<SingleTransaction> _transactions = [];

  Future<List<SingleTransaction>> getTransactions(DeviceInfoPlugin deviceInfo, int month, int year) async {

    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    String? userId = androidInfo.id;

    if (userId == null) {
      //TODO: show alert problem
      return [];
    }

    Uri uri = Uri.parse('$baseEndpoint/transactions/$userId?month=$month&year=$year');
    NetworkHelper networkHelper = NetworkHelper(uri);
    final transactionsData = await networkHelper.getTransactions(context);

    if (transactionsData != null) {
      _transactions = ParseUtils.parseTransactionData(transactionsData);
    }

    return _transactions;
  }

  @override
  Widget build(BuildContext context) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    //TODO: design transactions screen - send deviceInfo to getTransactions function - also send year and month on change (keeep month and year in state - default values are current year and current month!)
    //TODO: think about paging ... is it really necessary ? backend returns pageable, currently 100 transactions per page.
    return Container(
      child: Center(child: Text('Transactions Screen')),
    );
  }
}
