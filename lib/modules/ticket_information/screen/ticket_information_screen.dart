import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:squick/constants/api_constants.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/modules/completed_transaction/screen/completed_transaction.dart';
import 'package:squick/modules/ticket_information/model/payment_status.dart';
import 'package:squick/modules/ticket_information/model/ticket_info.dart';
import 'package:squick/modules/home/model/database.dart';
import 'package:squick/modules/ticket_information/model/transaction_dto.dart';
import 'package:squick/modules/ticket_information/widget/credit_card_view.dart';
import 'package:squick/modules/wallet/screen/add_new_card_screen.dart';
import 'package:squick/utils/helpers/networking.dart';
import 'package:squick/widgets/flutter_ticket.dart';
import 'package:squick/widgets/squick_button.dart';
import 'package:stripe_payment/stripe_payment.dart';

import 'dart:io';

import '../../../models/stripe_transaction_response.dart';
import '../../../utils/helpers/payment.dart';
import '../../../widgets/ticket_content.dart';
import '../../wallet/model/credit_card.dart' as TScanCreditCard;

class TicketInformation extends StatefulWidget {
  static const String id = "/ticket_information";

  @override
  _TicketInformationState createState() => _TicketInformationState();
}

class _TicketInformationState extends State<TicketInformation> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  NetworkHelper networkHelper =
      NetworkHelper(Uri.parse('$baseEndpoint/transactions'));
  bool loading = false;
  late DatabaseProvider _databaseProvider;

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
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    final ticket = ModalRoute.of(context)!.settings.arguments as TicketInfo;
    _databaseProvider = Provider.of<DatabaseProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 10.0),
          child: Stack(
            children: [
              AbsorbPointer(
                absorbing: loading,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(IconlyLight.arrow_left_2, color: colorBlueDark,),
                              ),
                            ),
                            Expanded(
                              flex: 12,
                              child: Text(
                                'Информации за билет',
                                style: font18Bold.copyWith(color: colorBlueDark),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Center(
                        child: FlutterTicketWidget(
                          width: 1500.0,
                          height: 1500.0,
                          isCornerRounded: true,
                          child: TicketContent(ticket: ticket),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: SquickButton(
                                  buttonText: !loading ? 'Плати' : 'Се плаќа...',
                                  onTap: _databaseProvider.count == 0
                                      ? null
                                      : () async {

                                    String? userId;
                                    if (Platform.isAndroid) {
                                      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                                      userId = androidInfo.id;
                                    }else if (Platform.isIOS) {
                                      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
                                      userId = iosInfo.identifierForVendor;
                                    }

                                    setState(() {
                                      loading = true;
                                    });

                                    int index = _databaseProvider.getPrimaryCard();
                                    List<TScanCreditCard.CreditCard> cards = await _databaseProvider.getAllCreditCards();
                                    TScanCreditCard.CreditCard card = cards[index];

                                    StripeTransactionResponse response = await payTicket(price: ticket.price, userId: userId, ticketId: ticket.id, card: card);

                                    // TransactionDto transaction = TransactionDto(
                                    //     userId.toString(),
                                    //     ticket.id,
                                    //     ticket.price,
                                    //     response.success ? PaymentStatus.SUCCESSFUL.toString().split(".")[1] : PaymentStatus.UNSUCCESSFUL.toString().split(".")[1]);
                                    //
                                    // bool result = await networkHelper
                                    //     .newTransaction(transaction, context);

                                    setState(() {
                                      loading = false;
                                    });

                                    Navigator.pushReplacementNamed(
                                        context, CompletedTransactionScreen.id,
                                        arguments: response.success);

                                  })),
                          TextButton(
                            child: Text(
                              _databaseProvider.count == 0
                                  ? 'Додади картичка'
                                  : 'Промени Картичка',
                              style: _databaseProvider.count == 0 ? font14Bold.copyWith(color: Colors.black) : font12Regular.copyWith(color: Colors.black),
                            ),
                            onPressed: _databaseProvider.count == 0
                                ? () {
                              var backToPayment = true;
                              Navigator.pushNamed(context, AddCardScreen.id,
                                  arguments: backToPayment);
                            }
                                : () {
                              showModalBottomSheet(
                                context: context,
                                builder: (_) => CreditCardView(
                                  primaryIndex: _databaseProvider.getPrimaryCard(),
                                  ticket: ticket,
                                  deviceInfo: deviceInfo,
                                  onPayTapped: () {
                                    setState(() {
                                      loading = true;
                                    });
                                  }
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (loading) kLoader
            ]
          ),
        ),
      ),
    );
  }
}
