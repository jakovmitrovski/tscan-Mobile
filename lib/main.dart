import 'package:flutter/material.dart';
import 'package:squick/modules/explore/screen/explore_screen.dart';
import 'package:squick/modules/home/screen/home_screen.dart';
import 'package:squick/modules/map/screen/map_screen.dart';
import 'package:squick/modules/past_transactions/screen/past_transactions_screen.dart';
import 'package:squick/modules/scan/screen/scan_screen.dart';
import 'package:squick/modules/ticket_information/screen/ticket_information_screen.dart';
import 'package:squick/modules/wallet/screen/wallet_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        MapScreen.id: (context) => MapScreen(),
        ExploreScreen.id: (context) => ExploreScreen(),
        TransactionsScreen.id: (context) => TransactionsScreen(),
        ScanScreen.id: (context) => ScanScreen(),
        TicketInformation.id: (context) => TicketInformation(),
        WalletScreen.id: (context) => WalletScreen(),
      },
    );
  }
}
