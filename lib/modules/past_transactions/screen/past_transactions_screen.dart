import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:squick/models/paging_response.dart';
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

  PagingResponse? _pagingTransactions;

  Future<PagingResponse?> getTransactions(DeviceInfoPlugin deviceInfo, int start, int items) async {

    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    String? userId = androidInfo.id;

    if (userId == null) {
      //TODO: show alert problem
      return null;
    }

    Uri uri = Uri.parse('$baseEndpoint/transactions/$userId/all?start=$start&items=$items');
    NetworkHelper networkHelper = NetworkHelper(uri);
    final transactionsData = await networkHelper.getTransactions(context);

    if (transactionsData != null) {
      _pagingTransactions = ParseUtils.parseTransactionData(transactionsData);
    }else {
      //TODO: unable to load data
    }

    return _pagingTransactions;
  }

  @override
  Widget build(BuildContext context) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    getTransactions(deviceInfo, 0, 15);

    return Container(
      child: Center(child: Text('Transactions Screen')),
    );
  }
}
