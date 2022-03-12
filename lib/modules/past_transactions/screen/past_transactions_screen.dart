import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:squick/models/paging_response.dart';
import 'package:squick/modules/past_transactions/model/transaction.dart';
import 'package:squick/utils/helpers/networking.dart';
import 'package:squick/constants/api_constants.dart';
import 'package:squick/utils/helpers/parse_utils.dart';
import 'package:squick/constants/app_constants.dart';
import 'dart:async';

import 'package:squick/widgets/transaction_widget.dart';

class TransactionsScreen extends StatefulWidget {
  static const String id = "/transactions";

  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  int _page = 0;
  final int _items = 7;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  List<SingleTransaction> _transactions = [];

  late PagingResponse _transactionsPagingResponse;
  late DeviceInfoPlugin _deviceInfo;
  late ScrollController _controller;  late double height;


  Future<String> getUserId(DeviceInfoPlugin deviceInfo) async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    // String? userId = androidInfo.id;
    //TODO: Remove this - testing purposes only
    String userId = "NRD90M";

    // if (userId == null) {
    //   //TODO: show alert problem
    //   return null;
    // }
    return userId;
  }

  void getTransactions(DeviceInfoPlugin deviceInfo, int start,
      int items) async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    String user = await getUserId(deviceInfo);

    Uri uri = Uri.parse(
        '$baseEndpoint/transactions/$user/all?start=$start&items=$items');
    NetworkHelper networkHelper = NetworkHelper(uri);
    final transactionsData = await networkHelper.getTransactions(context);

    if (transactionsData != null) {
      _transactionsPagingResponse =
          ParseUtils.parseTransactionData(transactionsData);

      setState(() {
        _isFirstLoadRunning = false;
        _transactions =
        _transactionsPagingResponse.content as List<SingleTransaction>;
      });
    } else {
      //TODO: unable to load data
    }
  }

  void _loadMore(DeviceInfoPlugin deviceInfo) async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page += 1;

      String user = await getUserId(deviceInfo);

      Uri uri = Uri.parse(
          '$baseEndpoint/transactions/$user/all?start=$_page&items=$_items');
      NetworkHelper networkHelper = NetworkHelper(uri);
      final transactionsData = await networkHelper.getTransactions(context);

      if (transactionsData.isNotEmpty) {
        _transactionsPagingResponse =
            ParseUtils.parseTransactionData(transactionsData);

        setState(() {
          _transactions.addAll(
              _transactionsPagingResponse.content as List<SingleTransaction>);
        });
      } else {
        setState(() {
          _hasNextPage = false;
        });
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  @override
  void initState() {
    _deviceInfo = DeviceInfoPlugin();
    getTransactions(_deviceInfo, _page, _items);
    _controller = ScrollController()
      ..addListener(() {
        _loadMore(_deviceInfo);
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(() {
      _loadMore(_deviceInfo);
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: _isFirstLoadRunning
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: colorGray,
              width: double.infinity,

              child: Column(
                children: [
                  Column(
                    children: const [Text('Вкупно потрошено')],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: colorGray,
              width: double.infinity,

              child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  child: Column(
                    children: [
                      Container(
                        color: colorGray,
                        width: double.infinity,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                          child: ListView.builder(
                            controller: _controller,
                            padding: const EdgeInsets.only(bottom: 30.0),
                            itemCount: _transactions.length,
                            itemBuilder: (_, index) =>
                              TransactionWidget(
                                  transaction: _transactions[index],
                                  height: height
                              )
                          ),
                        )
                      ),

                      if (_isLoadMoreRunning == true)
                        const Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 40),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    ],
                  ),
              ),
            ),
          ),

          if (_hasNextPage == false)
            Container(
              padding: const EdgeInsets.only(top: 30, bottom: 40),
              color: Colors.amber,
              child: const Center(
                child: Text('You have fetched all of the content'),
              ),
            ),
        ],
      ),
    );
  }
}

// return Scaffold(
// body: Container(
// child: const Text("HI"),
// ),
// );

// return Scaffold(
// body: _isFirstLoadRunning
// ? const Center(
// child: CircularProgressIndicator(),
// )
// : Column(
// children: [
// Container(
// color: colorGray,
// child: Column(
// children: [
// Column(
// children: const [Text('Вкупно потрошено')],
// ),
// Column(
// children: [
// Container(
// width: 60,
// height: 2,
// color: colorGrayDark,
// ),
// Expanded(
// child: ListView.builder(
// controller: _controller,
// itemCount: _transactions.length,
// itemBuilder: (_, index) => Card(
// margin: const EdgeInsets.symmetric(
// vertical: 8, horizontal: 10),
// child: ListTile(
// title: Text(_transactions[index].id.toString()),
// ),
// ),
// ),
// ),
// if (_isLoadMoreRunning == true)
// const Padding(
// padding: EdgeInsets.only(top: 10, bottom: 40),
// child: Center(
// child: CircularProgressIndicator(),
// ),
// ),
// if (_hasNextPage == false)
// Container(
// padding:
// const EdgeInsets.only(top: 30, bottom: 40),
// color: Colors.amber,
// child: const Center(
// child:
// Text('You have fetched all of the content'),
// ),
// ),
// ],
// )
// ],
// ),
// )
// ],
// ),
// );
