import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:squick/models/paging_response.dart';
import 'package:squick/modules/past_transactions/model/transaction.dart';
import 'package:squick/utils/helpers/networking.dart';
import 'package:squick/constants/api_constants.dart';
import 'package:squick/utils/helpers/parse_utils.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/widgets/squick_button.dart';
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
  late ScrollController _controller;
  late double height;

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
    if (_hasNextPage &&
        !_isFirstLoadRunning &&
        !_isLoadMoreRunning &&
        _controller.position.userScrollDirection == ScrollDirection.reverse &&
        _controller.position.extentAfter < 150) {
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

  _getMonths() {
    List<Widget> widgets = [];
    for (int i = 1; i < 12; i++) {
      widgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: SquickButton(
          buttonText: 'Jan \'22',
          width: 90.0,
          onTap: () => {},
        ),
      ),
      );
  }

    return
    widgets;
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
    height = MediaQuery
        .of(context)
        .size
        .height;

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Вкупно потрошено',
                          style: font18Regular.copyWith(
                              color: colorBlueDarkLightest),
                        ),
                      ),
                      Text(
                        '1850 денари',
                        style: font36Bold.copyWith(color: colorBlueDark),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
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
                    SizedBox(
                      height: 80.0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: _getMonths(),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                              15.0, 15.0, 15.0, 0.0),
                          child: ListView.builder(
                              controller: _controller,
                              padding: const EdgeInsets.only(bottom: 30.0),
                              itemCount: _transactions.length,
                              itemBuilder: (_, index) =>
                                  TransactionWidget(
                                      transaction: _transactions[index],
                                      height: height)),
                        )),
                    if (_isLoadMoreRunning &&
                        _controller.position.userScrollDirection ==
                            ScrollDirection.reverse)
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 40.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: colorBlueLight,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          //
          // if (!_hasNextPage)
          //   Container(
          //     padding: const EdgeInsets.only(top: 30, bottom: 40),
          //     color: Colors.amber,
          //     child: const Center(
          //       child: Text('You have fetched all of the content'),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
