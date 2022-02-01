import 'package:flutter/material.dart';
import 'package:squick/modules/completed_transaction/screen/completed_transaction.dart';
import 'package:squick/modules/explore/screen/explore_screen.dart';
import 'package:squick/modules/home/model/database.dart';
import 'package:squick/modules/home/screen/home_screen.dart';
import 'package:squick/modules/map/screen/map_screen.dart';
import 'package:squick/modules/past_transactions/screen/past_transactions_screen.dart';
import 'package:squick/modules/scan/screen/scan_screen.dart';
import 'package:squick/modules/ticket_information/screen/ticket_information_screen.dart';
import 'package:squick/modules/wallet/screen/add_new_card_screen.dart';
import 'package:squick/modules/wallet/screen/wallet_screen.dart';
import 'package:provider/provider.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DatabaseProvider(),
      child: MaterialApp(
        title: 'Squick',
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
          CompletedTransactionScreen.id: (context) => CompletedTransactionScreen(),
          AddCardScreen.id: (context) => AddCardScreen(),
        },
      ),
    );
  }
}
