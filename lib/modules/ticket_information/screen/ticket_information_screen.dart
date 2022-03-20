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
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 15.0, top: 15.0, bottom: 15.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Material(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(color: colorBlueDark),
                                ),
                                child: IconButton(
                                  padding: const EdgeInsets.all(2),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(IconlyLight.arrow_left_2),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Text(
                            'Информации за билет',
                            style: font24Bold.copyWith(color: colorBlueDarkLight),
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: SizedBox(width: 500.0),
                        ),
                      ],
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 15.0, top: 15.0, bottom: 15.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Material(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(color: colorBlueDark),
                                  ),
                                  child: IconButton(
                                    padding: const EdgeInsets.all(2),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(IconlyLight.arrow_left_2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Text(
                              'Информации за билет',
                              style: font20Bold.copyWith(color: colorBlueDarkLight),
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: SizedBox(width: 500.0),
                          ),
                        ],
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
              ),
              if (loading) kLoader
            ]
          ),
        ),
      ),
    );
  }
}
