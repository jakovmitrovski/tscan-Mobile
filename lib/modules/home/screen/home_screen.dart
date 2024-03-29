import 'package:app_settings/app_settings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/models/selected_parking_provider.dart';
import 'package:squick/modules/explore/screen/explore_screen.dart';
import 'package:squick/modules/map/screen/map_screen.dart';
import 'package:squick/modules/past_transactions/screen/past_transactions_screen.dart';
import 'package:squick/modules/ticket_information/screen/ticket_information_screen.dart';
import 'package:squick/modules/wallet/screen/wallet_screen.dart';
import 'package:squick/utils/helpers/alert.dart';
import 'package:squick/utils/helpers/scanner.dart';
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
  bool isExplore = false,
      isMap = true,
      isTransactions = false,
      isWallet = false;
  Widget screen = const MapScreen();
  bool loading = false;

  updateUI(int index) {
    setState(() {
      currentIndex = index;

      switch (index) {
        case 0:
          {
            isExplore = true;
            isMap = false;
            isTransactions = false;
            isWallet = false;
          }
          break;

        case 1:
          {
            isExplore = false;
            isMap = true;
            isTransactions = false;
            isWallet = false;
          }
          break;
        case 2:
          {
            isExplore = false;
            isMap = false;
            isTransactions = true;
            isWallet = false;
          }
          break;
        default:
          {
            isExplore = false;
            isMap = false;
            isTransactions = false;
            isWallet = true;
          }
          break;
      }
    });
  }

  void _navigateWithLoader() async {
    setState(() {
      loading = true;
    });

    final ticketInfo = await Scanner.scan(context);

    setState(() {
      loading = false;
    });

    if (ticketInfo == null || ticketInfo == -1) {
      return;
    }

    Navigator.pushNamed(context, TicketInformation.id, arguments: ticketInfo);
  }

  Future<void> _checkConnectivityState(BuildContext context) async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();

    if (result != ConnectivityResult.wifi && result != ConnectivityResult.mobile) {
      AlertHelper.showAlert(context,
          title: "Немате интернет конекција!",
          description: "Осигурајте се дека сте поврзани на интернет",
          buttonText: "Отвори интернет поставки",
          onTap: () async {
            await AppSettings.openWIFISettings();
            Navigator.pop(context);
          }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var selectedParkingProvider = Provider.of<SelectedParkingProvider>(context);

    _checkConnectivityState(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: loading
            ? kLoader
            : Padding(
                padding: isMap || isExplore || isTransactions
                    ? const EdgeInsets.symmetric(horizontal: 0.0)
                    : const EdgeInsets.symmetric(horizontal: 25.0),
                child: IndexedStack(
                  children: const [
                    ExploreScreen(),
                    MapScreen(),
                    TransactionsScreen(),
                    WalletScreen()
                  ],
                  index: currentIndex,
                ),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: (MediaQuery.of(context).viewInsets.bottom != 0 ||
                (isMap && selectedParkingProvider.selected != -1))
            ? null
            : FloatingMenuButton(onPressed: () {
                _navigateWithLoader();
              }),
        bottomNavigationBar: (isMap && selectedParkingProvider.selected != -1)
            ? null
            : Menu(
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
