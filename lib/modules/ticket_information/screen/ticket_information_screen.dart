import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/models/ticket_info.dart';
import 'package:squick/modules/completed_transaction/screen/completed_transaction.dart';
import 'package:squick/widgets/flutter_ticket.dart';
import 'package:squick/utils/helpers/parse_utils.dart';
import 'package:squick/widgets/squick_button.dart';
import 'package:squick/widgets/ticket_content.dart';

class TicketInformation extends StatefulWidget {
  static const String id = "/ticket_information";

  @override
  _TicketInformationState createState() => _TicketInformationState();
}

class _TicketInformationState extends State<TicketInformation> {
  @override
  Widget build(BuildContext context) {
    final ticket = ModalRoute.of(context)!.settings.arguments as TicketInfo;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                  // TODO: add boxshadow that will make sense
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
                        onTap: () {
                          //TODO: PAYMENT and API CALL to insert in transactions!
                          bool transactionSuccessful = false;
                          Navigator.pushReplacementNamed(
                              context, CompletedTransactionScreen.id,
                              arguments: transactionSuccessful);
                        },
                        backgroundColor: colorOrange,
                      ),
                    ),
                    TextButton(
                      child: Text(
                        'Промени Картичка',
                        style: font12Regular.copyWith(color: Colors.black),
                      ),
                      onPressed: () {
                        //TODO: IMPLEMENT ON CHANGE CREDIT CARD.
                        print('Change');
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
