import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/custom_card_type_icon.dart';
import 'package:iconly/iconly.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/modules/wallet/model/credit_card.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:squick/modules/wallet/screen/add_new_card_screen.dart';

class CreditCardViewWidget extends StatefulWidget {
  final CreditCard creditCard;
  bool isSelected;

  CreditCardViewWidget(
      {Key? key, required this.creditCard, required this.isSelected})
      : super(key: key);

  @override
  _CreditCardViewWidgetState createState() => _CreditCardViewWidgetState();
}

class _CreditCardViewWidgetState extends State<CreditCardViewWidget> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Container(
      width: width / 1.05,
      child: Stack(
        children: <Widget>[
          widget.creditCard.cardNumber == ""
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    height: widget.isSelected ? height / 3.4 : height / 3.6,
                    decoration: const BoxDecoration(
                      color: colorGray,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(20),
                      dashPattern: const [10, 5],
                      color: colorBlue,
                      strokeWidth: 3,
                      child: Center(
                        child: Container(
                          width: width / 6,
                          child: InkWell(
                            child: const Icon(
                              Icons.add_circle_outline,
                              color: colorBlue,
                              size: 40
                            ),
                            onTap: () {
                              var backToPayment = true;
                              Navigator.pushNamed(context, AddCardScreen.id,
                                  arguments: backToPayment);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : CreditCardWidget(
                  height: widget.isSelected ? height / 3.4 : height / 3.6,
                  labelExpiredDate: 'EXPIRED',
                  cardNumber: widget.creditCard.cardNumber,
                  expiryDate: widget.creditCard.expiryDate,
                  cardHolderName: widget.creditCard.cardholderName,
                  cvvCode: widget.creditCard.cvv,
                  isHolderNameVisible: true,
                  cardBgColor: Colors.white,
                  isChipVisible: false,
                  backgroundImage: widget.creditCard.imageUrl,
                  isSwipeGestureEnabled: false,
                  onCreditCardWidgetChange:
                      (CreditCardBrand creditCardBrand) {},
                  showBackView: false,
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
          widget.isSelected
              ? Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: (width / 11), bottom: (height / 180)),
                    child: InkWell(
                        onTap: () {
                          setState(() {});
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: colorGreen,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white, width: 1.5)),
                          child: const Center(
                            child: Icon(
                              CupertinoIcons.checkmark_alt,
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ))
              : Container(),
        ],
      ),
    );
  }
}
