import 'package:flutter/material.dart';

class Menu extends StatefulWidget {

  final bool explore, map, transactions, wallet;

  final Function notify;

  const Menu({required this.notify,
    this.explore = false,
    this.map = false,
    this.transactions = false,
    this.wallet = false});

  @override
  _MenuState createState() => _MenuState();
}


class _MenuState extends State<Menu> {

  @override
  Widget build(BuildContext context) {

    final String exploreImage = widget.explore
        ? 'assets/images/explore_active.png'
        : 'assets/images/explore_inactive.png';
    final String mapImage = widget.map
    ? 'assets/images/map_active.png'
        : 'assets/images/map_inactive.png';
    final String transactionsImage = widget.transactions
    ? 'assets/images/transactions_active.png'
        : 'assets/images/transactions_inactive.png';
    final String walletImage = widget.wallet
    ? 'assets/images/wallet_active.png'
        : 'assets/images/wallet_inactive.png';


    //TODO: ADD ELEVEATION
    return BottomAppBar(
      child: Container(
        color: Colors.white60,
        height: 60,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (!widget.explore) {
                    widget.notify(0);
                  }
                },
                child: Image.asset(
                  exploreImage,
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (!widget.map) {
                    widget.notify(1);
                  }
                },
                child: Image.asset(
                  mapImage
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: 40,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: (){
                  if (!widget.transactions) {
                    widget.notify(2);
                  }
                },
                child: Image.asset(
                  transactionsImage
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (!widget.wallet) {
                    widget.notify(3);
                  }
                },
                child: Image.asset(
                  walletImage
                ),
              ),
            )
        ],
        ),
      ),
      notchMargin: 14.0, // TODO: DOZNAJ SO E OVA
    );
  }
}