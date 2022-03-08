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
import 'package:squick/modules/wallet/model/credit_card.dart';

import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:squick/utils/helpers/networking.dart';
import 'package:squick/widgets/squick_button.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'credit_card_widget.dart';

class CreditCardView extends StatefulWidget {
  int primaryIndex;
  TicketInfo ticket;
  DeviceInfoPlugin deviceInfo;

  CreditCardView(
      {Key? key,
      required this.primaryIndex,
      required this.ticket,
      required this.deviceInfo})
      : super(key: key);

  @override
  _CreditCardViewState createState() => _CreditCardViewState();
}

class _CreditCardViewState extends State<CreditCardView> {
  int currentIndex = 0;
  bool isFirstTime = true;
  NetworkHelper networkHelper =
      NetworkHelper(Uri.parse('$baseEndpoint/transactions'));

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

  @override
  Widget build(BuildContext context) {
    if (widget.primaryIndex != -1 && isFirstTime) {
      setState(() {
        isFirstTime = false;
        currentIndex += widget.primaryIndex;
        controller.scrollToIndex(widget.primaryIndex);
      });
    }

    final double height = MediaQuery.of(context).size.height;

    return Container(
      color: const Color(0xff757575),
      child: Container(
        height: 0.5 * height,
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
                  //TODO: Remove space between elements
                  child: ListView.separated(
                    controller: controller,
                    clipBehavior: Clip.hardEdge,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: Provider.of<DatabaseProvider>(context)
                            .count +
                        1,
                    itemBuilder: (BuildContext context, int index) {
                      CreditCard? card =
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
                                    creditCard: CreditCard("",
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
                                    creditCard: CreditCard(card!.imageUrl,
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
            Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 25.0, right: 25.0, bottom: 25.0),
                  child: SquickButton(
                    buttonText: 'Плати',
                    backgroundColor: colorOrange,
                    onTap: () async {
                      AndroidDeviceInfo androidInfo =
                          await widget.deviceInfo.androidInfo;
                      String? userId = androidInfo.id;

                      TransactionDto transaction = TransactionDto(
                          userId.toString(),
                          widget.ticket.id,
                          widget.ticket.price,
                          PaymentStatus.SUCCESSFUL.toString().split(".")[1]);

                      bool result = await networkHelper.newTransaction(
                          transaction, context);
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(
                          context, CompletedTransactionScreen.id,
                          arguments: result);
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
