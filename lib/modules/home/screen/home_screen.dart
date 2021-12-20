import 'package:flutter/material.dart';
import 'package:squick/modules/explore/screen/explore_screen.dart';
import 'package:squick/modules/map/screen/map_screen.dart';
import 'package:squick/modules/past_transactions/screen/past_transactions_screen.dart';
import 'package:squick/modules/wallet/screen/wallet_screen.dart';
import 'package:squick/widgets/fab.dart';
import 'package:squick/widgets/menu.dart';

class HomeScreen extends StatefulWidget {

  static const String id = "/";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int currentIndex = 1;
  bool isExplore = false, isMap = true, isTransactions = false, isWallet = false;
  Widget screen = MapScreen();

  updateUI(int index){


    setState(() {

      currentIndex = index;

      switch(index) {
        case 0: {
          isExplore = true;
          isMap = false;
          isTransactions = false;
          isWallet = false;
        }
        break;

        case 1: {
          isExplore = false;
          isMap = true;
          isTransactions = false;
          isWallet = false;
        }
        break;
        case 2: {
          isExplore = false;
          isMap = false;
          isTransactions = true;
          isWallet = false;
        }
        break;
        default: {
          isExplore = false;
          isMap = false;
          isTransactions = false;
          isWallet = true;
        }
        break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: IndexedStack(
          children: [
            ExploreScreen(),
            MapScreen(),
            TransactionsScreen(),
            WalletScreen()
          ],
          index: currentIndex,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: const FloatingMenuButton(),
        bottomNavigationBar: Menu(
          explore: isExplore,
          map: isMap,
          transactions: isTransactions,
          wallet: isWallet,
          notify: (index) {
            updateUI(index);
          },
        ),
      ),
    );
  }
}
