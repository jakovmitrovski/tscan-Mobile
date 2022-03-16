import 'package:flutter/material.dart';
import 'package:squick/models/filter_data_model.dart';
import 'package:squick/models/maps_provider.dart';
import 'package:squick/models/selected_parking_provider.dart';
import 'package:squick/modules/completed_transaction/screen/completed_transaction.dart';
import 'package:squick/modules/explore/screen/explore_screen.dart';
import 'package:squick/modules/home/model/database.dart';
import 'package:squick/modules/home/screen/home_screen.dart';
import 'package:squick/modules/map/screen/map_screen.dart';
import 'package:squick/modules/past_transactions/screen/past_transactions_screen.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DatabaseProvider()),
        ChangeNotifierProvider(create: (_) => FilterDataModel()),
        ChangeNotifierProvider(create: (_) => MapsProvider()),
        ChangeNotifierProvider(create: (_) => SelectedParkingProvider()),
      ],
      child: MaterialApp(
        title: 'TScan',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: HomeScreen.id,
        routes: {
          HomeScreen.id: (context) => const HomeScreen(),
          MapScreen.id: (context) => const MapScreen(),
          ExploreScreen.id: (context) => const ExploreScreen(),
          TransactionsScreen.id: (context) => const TransactionsScreen(),
          TicketInformation.id: (context) => TicketInformation(),
          WalletScreen.id: (context) => const WalletScreen(),
          CompletedTransactionScreen.id: (context) => CompletedTransactionScreen(),
          AddCardScreen.id: (context) => const AddCardScreen(),
        },
      ),
    );
  }
}
