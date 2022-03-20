import 'package:blur/blur.dart';
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
import 'package:squick/widgets/ticket_content.dart';

import 'dart:io';

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

  @override
  Widget build(BuildContext context) {
    final ticket = ModalRoute.of(context)!.settings.arguments as TicketInfo;


    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 10.0),
          child: Stack(
            children: [
              Column(
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
                      // TODO: add box shadow that will make sense
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
                                buttonText: 'Плати',
                                onTap: Provider.of<DatabaseProvider>(context)
                                    .count ==
                                    0
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
                                  TransactionDto transaction = TransactionDto(
                                      userId.toString(),
                                      ticket.id,
                                      ticket.price,
                                      PaymentStatus.SUCCESSFUL
                                          .toString()
                                          .split(".")[1]);

                                  bool result = await networkHelper
                                      .newTransaction(transaction, context);

                                  // TODO: IMPLEMENT WITH PAYMENT PROVIDER

                                  setState(() {
                                    loading = false;
                                  });

                                  Navigator.pushReplacementNamed(
                                      context, CompletedTransactionScreen.id,
                                      arguments: result);

                                })),
                        TextButton(
                          child: Text(
                            Provider.of<DatabaseProvider>(context).count == 0
                                ? 'Додади картичка'
                                : 'Промени Картичка',
                            style: Provider.of<DatabaseProvider>(context).count == 0 ? font14Bold.copyWith(color: Colors.black) : font12Regular.copyWith(color: Colors.black),
                          ),
                          onPressed:
                          Provider.of<DatabaseProvider>(context).count == 0
                              ? () {
                            var backToPayment = true;
                            Navigator.pushNamed(context, AddCardScreen.id,
                                arguments: backToPayment);
                          }
                              : () {
                            showModalBottomSheet(
                              context: context,
                              builder: (_) => CreditCardView(
                                primaryIndex:
                                Provider.of<DatabaseProvider>(context,
                                    listen: false)
                                    .getPrimaryCard(),
                                ticket: ticket,
                                deviceInfo: deviceInfo,
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
              if (loading) Blur(
                blur: 2.0,
                colorOpacity: 0.5,
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
                                  buttonText: 'Плати',
                                  onTap: () {}
                              ),
                          ),
                          TextButton(
                            child: Text(
                              Provider.of<DatabaseProvider>(context).count == 0
                                  ? 'Додади картичка'
                                  : 'Промени Картичка',
                              style: Provider.of<DatabaseProvider>(context).count == 0 ? font14Bold.copyWith(color: Colors.black) : font12Regular.copyWith(color: Colors.black),
                            ),
                            onPressed: () {}
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
