import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:squick/models/paging_response.dart';
import 'package:squick/modules/past_transactions/model/transaction.dart';
import 'package:squick/utils/helpers/alert.dart';
import 'package:squick/utils/helpers/date.dart';
import 'package:squick/utils/helpers/networking.dart';
import 'package:squick/constants/api_constants.dart';
import 'package:squick/utils/helpers/parse_utils.dart';
import 'package:squick/constants/app_constants.dart';
import 'dart:async';
import 'package:squick/widgets/transaction_widget.dart';
import 'package:squick/widgets/transactions_month_button.dart';

class TransactionsScreen extends StatefulWidget {
  static const String id = "/transactions";

  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  int _page = 0;
  final int _items = 7;
  static final DateTime _now = DateTime.now();
  static final int _currentMonth = _now.month;
  static final int _currentYear = _now.year;
  final ScrollController _scrollController = ScrollController();
  int _selectedYear = _currentYear;
  int _selectedMonth = _currentMonth;
  int _selectedIndex = 0;
  int _totalSpent = 1850;

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
    String? userId = androidInfo.id;

    if (userId == null) {
      AlertHelper.showAlert(
          context,
          title: 'Грешка!',
          description: 'Не може да се пронајде идентификациски број.',
          buttonText: 'Затвори ја TScan',
          onTap: () {
            exit(1);
          }
      );
      return '';
    }
    return userId;
  }

  void getTransactions(DeviceInfoPlugin deviceInfo, int start, int items,
      {int month = -1, int year = -1, bool fromButtonClick = false}) async {
    if (month == -1 || year == -1) {
      month = _currentMonth;
      year = _currentYear;
    }

    if (!fromButtonClick) {
      setState(() {
        _isFirstLoadRunning = true;
      });
    }

    String user = await getUserId(deviceInfo);

    if (user.isEmpty) {
      setState(() {
        _transactions = [];
      });

      return;
    }

    Uri uri = Uri.parse(
        '$baseEndpoint/transactions/$user?year=$year&month=$month&start=$start&items=$items');
    NetworkHelper networkHelper = NetworkHelper(uri);
    final transactionsData = await networkHelper.getTransactions(context);

    if (transactionsData != null) {
      _transactionsPagingResponse =
          ParseUtils.parseTransactionData(transactionsData);

      _getTotalSpent(deviceInfo, month: month, year: year);

      setState(() {
        _isFirstLoadRunning = false;
        _transactions =
            _transactionsPagingResponse.content as List<SingleTransaction>;
      });
    }
  }

  void _getTotalSpent(DeviceInfoPlugin deviceInfo,
      {int month = -1, int year = -1}) async {
    if (month == -1 || year == -1) {
      month = _currentMonth;
      year = _currentYear;
    }

    String user = await getUserId(deviceInfo);

    Uri uri = Uri.parse(
        '$baseEndpoint/transactions/$user/sum?year=$year&month=$month');

    NetworkHelper networkHelper = NetworkHelper(uri);
    final sumData = await networkHelper.getSum(context);

    if (sumData != null) {
      setState(() {
        _totalSpent = ParseUtils.parseSumData(sumData);
      });
    }
  }

  void _loadMore(DeviceInfoPlugin deviceInfo) async {
    if (_hasNextPage &&
        !_isFirstLoadRunning &&
        !_isLoadMoreRunning &&
        _transactions.isNotEmpty &&
        _controller.position.userScrollDirection == ScrollDirection.reverse &&
        _controller.position.extentAfter < 150) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page += 1;

      String user = await getUserId(deviceInfo);

      Uri uri = Uri.parse(
          '$baseEndpoint/transactions/$user?year=$_selectedYear&month=$_selectedMonth&start=$_page&items=$_items');
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
    for (int i = 0, month = _currentMonth, year = _currentYear;
        i < 12;
        i++, month--) {
      if (month == 0) {
        month = 12;
        year--;
      }

      widgets.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TransactionsMonthButton(
            buttonText: DateHelper.getFormattedDate(year, month),
            onTap: () => {
              setState(() {
                _hasNextPage = true;
                _page = 0;
                _isFirstLoadRunning = false;
                _isLoadMoreRunning = false;
                _selectedMonth = month;
                _selectedYear = year;
                _selectedIndex = i;
                _transactions = [];
              }),
              _getTotalSpent(_deviceInfo, month: month, year: year),
              getTransactions(_deviceInfo, 0, _items,
                  month: month, year: year, fromButtonClick: true),
              scrollRight(),
            },
            selected: i == _selectedIndex,
          ),
        ),
      );
    }

    return widgets;
  }

  void scrollRight() {
    if (_scrollController.hasClients) {
      double position = _selectedIndex * (90 + 2 * 8);
      _scrollController.animateTo(position,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn);
    }
  }

  @override
  void initState() {
    _deviceInfo = DeviceInfoPlugin();
    getTransactions(_deviceInfo, 0, _items);
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
    WidgetsBinding.instance!.addPostFrameCallback((_) => scrollRight());

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
                              '$_totalSpent денари',
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
                                controller: _scrollController,
                                scrollDirection: Axis.horizontal,
                                reverse: true,
                                children: _getMonths(),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    15.0, 15.0, 15.0, 0.0),
                                child: _transactions.isNotEmpty
                                    ? ListView.builder(
                                        controller: _controller,
                                        padding:
                                            const EdgeInsets.only(bottom: 30.0),
                                        itemCount: _transactions.length,
                                        itemBuilder: (_, index) =>
                                            TransactionWidget(
                                                transaction:
                                                    _transactions[index],
                                                height: height))
                                    : Center(
                                        child: Text(
                                          'Не се пронајдени податоци',
                                          style: font18Medium.copyWith(
                                              color: colorBlueDark),
                                        ),
                                      ),
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
              ],
            ),
    );
  }
}
