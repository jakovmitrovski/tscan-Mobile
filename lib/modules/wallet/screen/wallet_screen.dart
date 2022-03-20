import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/modules/home/model/database.dart';
import 'package:squick/modules/wallet/model/credit_card.dart';
import 'package:squick/modules/wallet/widget/credit_card_widget.dart';
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
    return Padding(
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
                  style: font20Bold.copyWith(color: colorBlueDark),
                ),
                SizedBox(
                    width: (MediaQuery.of(context).size.width - 50) / 7.03,
                    height: (MediaQuery.of(context).size.width - 50) / 7.04,
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
                                            'Го достигнавте лимитот за број на картички!',
                                        alertContent:
                                            'Доколку сакате да додате нова картичка, ве молиме избришете некоја од тековните и обидете се повторно.',
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
                        child: Icon(
                          Icons.add,
                          size: ((MediaQuery.of(context).size.width) / 14.04),
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

                  if (snapshot.data!.length == 0) {
                    return Center(
                      child: Text(
                        'Немате внесено картички!',
                        style: font18Medium.copyWith(
                            color: colorBlueDark),
                      ),
                    );
                  }

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
                                onPressed: (card.isPrimary == 0 || snapshot.data!.length == 1)
                                    ? () {
                                        Alert(
                                            context: context,
                                            type: AlertType.warning,
                                            title:
                                                'Дали сте сигурни дека сакате да ја избришете картичката?',
                                            style: AlertStyle(
                                                titleStyle: font16Medium
                                                    .copyWith(
                                                        color: colorBlueDark),
                                                descStyle:
                                                    font14Regular.copyWith(
                                                        color:
                                                            colorBlueDarkLight)),
                                            buttons: [
                                              DialogButton(
                                                child: const Text(
                                                  "Откажи",
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
                                                  "Избриши",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    Provider.of<DatabaseProvider>(
                                                            context,
                                                            listen: false)
                                                        .deleteCreditCard(
                                                            card.cardNumber, card.cvv);
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
                                      Size(
                                          ((MediaQuery.of(context)
                                                  .size
                                                  .width) /
                                              5.538),
                                          ((MediaQuery.of(context)
                                                  .size
                                                  .width) /
                                              5.538)),
                                    ),
                                    backgroundColor: (card.isPrimary == 1 && snapshot.data!.length != 1)
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
                                child: Icon(
                                  Icons.delete_forever,
                                  color: Colors.white,
                                  size: ((MediaQuery.of(context).size.width) /
                                      12),
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
                  return kLoader;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
