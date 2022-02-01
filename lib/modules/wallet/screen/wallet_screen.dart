import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/modules/home/model/database.dart';
import 'package:squick/modules/wallet/model/credit_card.dart';
import 'package:squick/modules/wallet/model/credit_card_widget.dart';
import 'package:squick/modules/wallet/screen/add_new_card_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:squick/widgets/alert_dialog.dart';

class WalletScreen extends StatefulWidget {
  static const String id = "/wallet";

  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Мои Картички',
                    style: font32Black.copyWith(color: colorBlueDark),
                  ),
                  SizedBox(
                      width: 44.23,
                      height: 44.0,
                      child: Material(
                        color: colorBlue,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            if (Provider.of<DatabaseProvider>(context,
                                        listen: false)
                                    .count ==
                                kMaxNumberOfCreditCards) {
                              showDialog(
                                  context: context,
                                  builder: (_) => CustomAlertDialog(
                                          alertTitle:
                                              'Number of credit cards limit reached!',
                                          alertContent:
                                              'You have reached the maximum number of credit cards. If you wish to add another card, please delete one of your existing cards and try again.',
                                          actions: [
                                            Center(
                                              child: TextButton(
                                                child: Text(
                                                  'Go back',
                                                  style: font12Medium.copyWith(
                                                    color: colorBlueDark,
                                                  ),
                                                ),
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(colorGrayDark),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ),
                                          ]));
                            } else {
                              Navigator.pushNamed(context, AddCardScreen.id);
                            }
                          },
                          child: const Icon(
                            Icons.add,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                      )),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future:
                    Provider.of<DatabaseProvider>(context).getAllCreditCards(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        CreditCard card = snapshot.data![index];
                        return Slidable(
                            endActionPane: ActionPane(
                              extentRatio: 0.3,
                              motion: const ScrollMotion(),
                              children: [
                                ElevatedButton(
                                  onPressed: card.isPrimary == 0
                                      ? () {
                                          Alert(
                                              context: context,
                                              type: AlertType.warning,
                                              title:
                                                  'Are you sure you want to delete this card?',
                                              desc:
                                                  'If you remove this card it will be permanently deleted.',
                                              buttons: [
                                                DialogButton(
                                                  child: const Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  color: Colors.grey.shade400,
                                                ),
                                                DialogButton(
                                                  child: const Text(
                                                    "Delete card",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      Provider.of<DatabaseProvider>(
                                                              context, listen:false)
                                                          .deleteCreditCard(
                                                              card.cardNumber);
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  color: colorBlueDarkLight,
                                                )
                                              ]).show();
                                        }
                                      : null,
                                  style: ButtonStyle(
                                      fixedSize:
                                          MaterialStateProperty.all<Size>(
                                        const Size(65, 65),
                                      ),
                                      backgroundColor: card.isPrimary == 1
                                          ? MaterialStateProperty.all<Color>(
                                              Colors.grey)
                                          : MaterialStateProperty.all<Color>(
                                              const Color(0xc8E32216),
                                            ),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                      ))),
                                  child: const Icon(
                                    Icons.delete_forever,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                ),
                              ],
                            ),
                            child: CustomCreditCardWidget(
                              creditCard: CreditCard(card.imageUrl,
                                  cardNumber: card.cardNumber,
                                  expiryDate: card.expiryDate,
                                  cvv: card.cvv,
                                  cardholderName: card.cardholderName,
                                  isPrimary: card.isPrimary),
                            ));
                      },
                    );
                  } else {
                    return const SpinKitDoubleBounce(
                      color: colorBlueLight,
                      size: 100.0,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
