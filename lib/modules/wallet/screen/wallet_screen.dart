import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  static const String id = "/wallet";

  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('Wallet Screen')),
    );
  }
}
