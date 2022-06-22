import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:squick/constants/api_constants.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/modules/completed_transaction/screen/completed_transaction.dart';
import 'package:squick/modules/ticket_information/model/payment_status.dart';
import 'package:squick/modules/ticket_information/model/ticket_info.dart';
import 'package:squick/modules/ticket_information/model/transaction_dto.dart';
import 'package:squick/modules/home/model/database.dart';
import 'package:stripe_payment/stripe_payment.dart';

import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:squick/utils/helpers/networking.dart';
import 'package:squick/widgets/squick_button.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../models/stripe_transaction_response.dart';
import '../../../utils/helpers/payment.dart';
import 'credit_card_widget.dart';
import '../../wallet/model/credit_card.dart' as TScanCreditCard;

class CreditCardView extends StatefulWidget {
  final int primaryIndex;
  final TicketInfo ticket;
  final DeviceInfoPlugin deviceInfo;
  final VoidCallback onPayTapped;

  CreditCardView(
      {Key? key,
      required this.primaryIndex,
      required this.ticket,
      required this.deviceInfo,
      required this.onPayTapped,
      })
      : super(key: key);

  @override
  _CreditCardViewState createState() => _CreditCardViewState();
}

class _CreditCardViewState extends State<CreditCardView> {
  int currentIndex = 0;
  bool isFirstTime = true;
  bool loading = false;
  NetworkHelper networkHelper =
      NetworkHelper(Uri.parse('$baseEndpoint/transactions'));
  late DatabaseProvider _databaseProvider;

  final controller = AutoScrollController(
      viewportBoundaryGetter: () => const Rect.fromLTRB(0, 0, 0, 5),
      axis: Axis.horizontal);

  int changeIndex(int maxLength, AutoScrollController controller) {
    if (controller.position.userScrollDirection == ScrollDirection.reverse) {
      if (currentIndex == maxLength) return currentIndex;
      setState(() {
        currentIndex += 1;
      });
    } else if (controller.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (currentIndex == 0) return currentIndex;
      setState(() {
        currentIndex -= 1;
      });
    }

    return currentIndex;
  }

  Future<StripeTransactionResponse> payTicket({required ticketId, required price, required userId, required TScanCreditCard.CreditCard card}) async {
    var expiryArr = card.expiryDate.split('/');
    CreditCard stripeCard = CreditCard(
      number: card.cardNumber,
      expMonth: int.parse(expiryArr[0]),
      expYear: int.parse(expiryArr[1]),
      name: card.cardholderName,
      cvc: card.cvv,
    );

    var response = await StripeService.payViaExistingCard(
        price: price,
        userId: userId,
        ticketId: ticketId,
        card: stripeCard
    );
    return response;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.primaryIndex != -1 && isFirstTime) {
      setState(() {
        isFirstTime = false;
        currentIndex += widget.primaryIndex;
        controller.scrollToIndex(widget.primaryIndex);
      });
    }
    _databaseProvider = Provider.of<DatabaseProvider>(context);

    return AbsorbPointer(
      absorbing: loading,
      child: Container(
        color: const Color(0xff757575),
        child: Container(
          height: 0.5.sh,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                    width: 60,
                    height: 2,
                    color: colorGrayDark,
                  ),
                ),
              ),
              Expanded(
                flex: 10,
                child: NotificationListener(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListView.separated(
                      controller: controller,
                      clipBehavior: Clip.hardEdge,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: Provider.of<DatabaseProvider>(context)
                              .count +
                          1,
                      itemBuilder: (BuildContext context, int index) {
                        TScanCreditCard.CreditCard? card =
                            index < Provider.of<DatabaseProvider>(context).count
                                ? Provider.of<DatabaseProvider>(context)
                                    .getLoadedCards[index]
                                : null;
                        return index ==
                                Provider.of<DatabaseProvider>(context).count
                            ? AutoScrollTag(
                                key: ValueKey(index),
                                controller: controller,
                                index: index,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CreditCardViewWidget(
                                      creditCard: TScanCreditCard.CreditCard("",
                                          cardNumber: "",
                                          expiryDate: "",
                                          cvv: "",
                                          cardholderName: "",
                                          isPrimary: 0),
                                      isSelected: false,
                                    ),
                                  ],
                                ),
                              )
                            : AutoScrollTag(
                                key: ValueKey(index),
                                controller: controller,
                                index: index,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CreditCardViewWidget(
                                      creditCard: TScanCreditCard.CreditCard(card!.imageUrl,
                                          cardNumber: card.cardNumber,
                                          expiryDate: card.expiryDate,
                                          cvv: card.cvv,
                                          cardholderName: card.cardholderName,
                                          isPrimary: card.isPrimary),
                                      isSelected:
                                          index == currentIndex ? true : false,
                                    ),
                                  ],
                                ),
                              );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                    ),
                  ),
                  onNotification: (n) {
                    if (n is ScrollEndNotification) {
                      setState(() {
                        controller.scrollToIndex(
                            changeIndex(
                                Provider.of<DatabaseProvider>(context,
                                        listen: false)
                                    .count,
                                controller),
                            preferPosition: AutoScrollPosition.middle);
                      });
                    }
                    return true;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 25.0, right: 25.0, bottom: 25.0),
                child: SquickButton(
                  buttonText: !loading ? 'Плати' : 'Се плаќа...',
                  backgroundColor: colorOrange,
                  onTap: _databaseProvider.count == 0 || loading ? null : () async {
                    widget.onPayTapped();
                    setState(() {
                      loading = true;
                    });
                    AndroidDeviceInfo androidInfo =
                        await widget.deviceInfo.androidInfo;
                    String? userId = androidInfo.id;

                    List<TScanCreditCard.CreditCard> cards = await _databaseProvider.getAllCreditCards();
                    TScanCreditCard.CreditCard card = cards[currentIndex];

                    StripeTransactionResponse response = await payTicket(price: widget.ticket.price, userId: userId, ticketId: widget.ticket.id, card: card);

                    // TransactionDto transaction = TransactionDto(
                    //     userId.toString(),
                    //     widget.ticket.id,
                    //     widget.ticket.price,
                    //     response.success ? PaymentStatus.SUCCESSFUL.toString().split(".")[1] : PaymentStatus.UNSUCCESSFUL.toString().split(".")[1]);
                    //
                    // bool result = await networkHelper.newTransaction(
                    //     transaction, context);

                    setState(() {
                      loading = false;
                    });

                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(
                        context, CompletedTransactionScreen.id,
                        arguments: response.success);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
