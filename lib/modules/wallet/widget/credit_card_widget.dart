import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/custom_card_type_icon.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/modules/home/model/database.dart';
import 'package:squick/modules/wallet/model/credit_card.dart';

class CustomCreditCardWidget extends StatefulWidget {
  final CreditCard creditCard;

  CustomCreditCardWidget({Key? key, required this.creditCard})
      : super(key: key);

  @override
  _CreditCardWidgetState createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CustomCreditCardWidget> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
      width: width / 1.1,
      child: Stack(
        children: <Widget>[
          CreditCardWidget(
            height: 190,
            labelExpiredDate: 'EXPIRED',
            cardNumber: widget.creditCard.cardNumber,
            expiryDate: widget.creditCard.expiryDate,
            cardHolderName: widget.creditCard.cardholderName,
            cvvCode: widget.creditCard.cvv,
            isHolderNameVisible: true,
            cardBgColor: colorGray,
            isChipVisible: false,
            backgroundImage: widget.creditCard.imageUrl,
            isSwipeGestureEnabled: false,
            onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
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
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: (width / 12), top: (width / 12)),
              child: InkWell(
                  onTap: () {
                    setState(() {
                      widget.creditCard.isPrimary = 1;
                      CreditCard newCard = CreditCard(
                          widget.creditCard.imageUrl.toString(),
                          cardNumber: widget.creditCard.cardNumber,
                          expiryDate: widget.creditCard.expiryDate,
                          cvv: widget.creditCard.cvv,
                          cardholderName: widget.creditCard.cardholderName,
                          isPrimary: widget.creditCard.isPrimary);
                      Provider.of<DatabaseProvider>(context, listen: false)
                          .updateCreditCard(newCard);
                    });
                  },
                  child: widget.creditCard.isPrimary == 1
                      ? Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: const Icon(IconlyBold.star,
                              color: Colors.white, size: 25),
                        )
                      : Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: const Icon(IconlyLight.star,
                              color: Colors.white, size: 25),
                        )),
            ),
          ),
        ],
      ),
    );
  }
}
