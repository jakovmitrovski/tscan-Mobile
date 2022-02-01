import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:provider/provider.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/modules/home/model/database.dart';
import 'package:squick/modules/wallet/model/credit_card.dart';
import 'package:squick/widgets/alert_dialog.dart';
import 'package:squick/widgets/squick_button.dart';

class AddCardScreen extends StatefulWidget {
  static String id = '/add-card';

  const AddCardScreen({Key? key}) : super(key: key);

  @override
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool isPrimary = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Matrix4 perspective = _pmat(1.0);

  static Matrix4 _pmat(num pv) {
    return Matrix4(
      1.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      pv * 0.001,
      0.0,
      0.0,
      0.0,
      1.0,
    );
  }

  @override
  void initState() {
    border = const OutlineInputBorder(
      borderSide: BorderSide(
        color: colorGrayDark,
        width: 1.0,
      ),
    );

    super.initState();
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 25.0, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: colorBlueDark),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: colorBlueDark,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 13,
                      child: Text(
                        'Додади картичка',
                        style: font20Medium.copyWith(color: colorBlueDark),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Transform(
                alignment: FractionalOffset.center,
                transform: perspective.scaled(1.0, 1.0, 1.0)
                  ..rotateX(pi - 200 * pi / 180)
                  ..rotateY(0.0)
                  ..rotateZ(0.0),
                child: CreditCardWidget(
                  showPrimary: false,
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  showBackView: isCvvFocused,
                  obscureCardNumber: false,
                  obscureCardCvv: false,
                  isHolderNameVisible: true,
                  backgroundImage: 'assets/images/gradient_blue_background.png',
                  cardBgColor: Colors.white.withOpacity(0.5),
                  isSwipeGestureEnabled: true,
                  onCreditCardWidgetChange:
                      (CreditCardBrand creditCardBrand) {},
                  customCardTypeIcons: <CustomCardTypeIcon>[
                    CustomCardTypeIcon(
                      cardType: CardType.mastercard,
                      cardImage: Image.asset(
                        'assets/images/master_card_logo.png',
                        height: 48,
                        width: 48,
                      ),
                    ),
                    CustomCardTypeIcon(
                      cardType: CardType.visa,
                      cardImage: Image.asset(
                        'assets/images/visa_logo.png',
                        height: 48,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CreditCardForm(
                        formKey: formKey,
                        obscureCvv: false,
                        obscureNumber: false,
                        cardNumber: cardNumber,
                        cvvCode: cvvCode,
                        isHolderNameVisible: true,
                        isCardNumberVisible: true,
                        isExpiryDateVisible: true,
                        cardHolderName: cardHolderName,
                        expiryDate: expiryDate,
                        textColor: colorBlueDark,
                        cursorColor: colorBlueDark,
                        cardNumberDecoration: InputDecoration(
                          labelText: 'Број на картичка',
                          hintText: 'XXXX XXXX XXXX XXXX',
                          filled: true,
                          fillColor: Colors.white,
                          hintStyle: creditCardLabelStyle,
                          labelStyle: creditCardLabelStyle,
                          focusedBorder: border,
                          enabledBorder: border,
                        ),
                        expiryDateDecoration: InputDecoration(
                          hintStyle: creditCardLabelStyle,
                          labelStyle: creditCardLabelStyle,
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: 'Месец и година',
                          hintText: 'XX/XX',
                        ),
                        cvvCodeDecoration: InputDecoration(
                          label: const Text('CVV'),
                          hintStyle: creditCardLabelStyle,
                          labelStyle: creditCardLabelStyle,
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: border,
                          enabledBorder: border,
                          hintText: 'XXX',
                        ),
                        cardHolderDecoration: InputDecoration(
                          hintStyle: creditCardLabelStyle,
                          labelStyle: creditCardLabelStyle,
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: 'Име и презиме',
                        ),
                        onCreditCardModelChange: onCreditCardModelChange,
                        themeColor: colorBlueLight,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Примарна',
                            style: font14Regular.copyWith(color: colorBlueDark),
                          ),
                          Switch(
                            value: isPrimary,
                            onChanged: (bool value) {
                              setState(() {
                                isPrimary = value;
                              });
                            },
                            activeColor: Colors.white,
                            activeTrackColor: colorBlueDark,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: SquickButton(
                          buttonText: 'Додади картичка',
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              CreditCard card = CreditCard(
                                'assets/images/card_design_${((Provider.of<DatabaseProvider>(context, listen: false).getLastCreditCardImageNumber() + 1) % 7).toInt()}.png',
                                cardNumber: cardNumber,
                                expiryDate: expiryDate,
                                cvv: cvvCode,
                                cardholderName: cardHolderName,
                                isPrimary: isPrimary ? 1 : 0,
                              );
                              Provider.of<DatabaseProvider>(context,
                                      listen: false)
                                  .insertCreditCard(card)
                                  .then(
                                    (element) => Provider.of<DatabaseProvider>(
                                                context,
                                                listen: false)
                                            .isValid
                                        ? Navigator.pop(context)
                                        : showDialog(
                                            context: context,
                                            builder: (_) => CustomAlertDialog(
                                                alertTitle: 'Oops!',
                                                alertContent:
                                                    'Looks like you already have this card in your wallet.',
                                                actions: [
                                                  TextButton(
                                                    child: Text(
                                                      'Go back',
                                                      style:
                                                          font12Medium.copyWith(
                                                        color: colorBlueDark,
                                                      ),
                                                    ),
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(
                                                                  colorGrayDark),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text(
                                                      'Modify card',
                                                      style:
                                                          font12Medium.copyWith(
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(
                                                                  colorBlueDark),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  )
                                                ]),
                                          ),
                                  );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
