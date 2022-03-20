import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        ? 'assets/images/explore_active.svg'
        : 'assets/images/explore_inactive.svg';
    final String mapImage = widget.map
    ? 'assets/images/map_active.svg'
        : 'assets/images/map_inactive.svg';
    final String transactionsImage = widget.transactions
    ? 'assets/images/transactions_active.svg'
        : 'assets/images/transactions_inactive.svg';
    final String walletImage = widget.wallet
    ? 'assets/images/wallet_active.svg'
        : 'assets/images/wallet_inactive.svg';


    var height = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 24,
          ),
        ],
      ),
      child: BottomAppBar(
        elevation: 5,
        child: Container(
          color: Colors.white60,
          height: Platform.isAndroid ? 0.1.sh : 0.08.sh,
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
                  child: SvgPicture.asset(
                    exploreImage
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
                  child: SvgPicture.asset(
                    mapImage,
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
                  child: SvgPicture.asset(
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
                  child: SvgPicture.asset(
                    walletImage
                  ),
                ),
              )
          ],
          ),
        ),
        notchMargin: 14.0,
      ),
    );
  }
}