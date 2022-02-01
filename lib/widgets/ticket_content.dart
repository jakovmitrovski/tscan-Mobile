import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/models/ticket_info.dart';
import 'package:squick/utils/helpers/parse_utils.dart';
import 'package:squick/widgets/enter_exit_timestamp.dart';
import 'package:squick/widgets/vertical_dashed_line.dart';

import 'horisontal_dashed_line.dart';

class TicketContent extends StatelessWidget {

  TicketInfo ticket;

  TicketContent({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Image.asset('assets/images/parking_logo.png'),
                    ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      'Паркинг Билет (${ticket.parking.hourlyPrice}ден/час)',
                      style: font18Bold.copyWith(
                          color: colorBlueDarkLight),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: colorOrange),
                                          shape: BoxShape.circle
                                      ),
                                    )
                                ),
                                Expanded(
                                  flex: 5,
                                  child: VerticalDashedLine(
                                    color: colorOrange,
                                    length: 150,
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: colorOrange,
                                          border: Border.all(color: colorOrange),
                                          shape: BoxShape.circle
                                      ),
                                    )
                                ),
                              ],
                            )
                        ),
                        Expanded(
                          flex: 9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  EnterExitTimestamp(
                                    texts: ['Влез', ParseUtils.parseTimeToStr(ticket.entered), ParseUtils.parseDateToStr(ticket.entered)],
                                  ),
                                  EnterExitTimestamp(
                                    texts: ['Излез', ParseUtils.parseTimeToStr(ticket.exited), ParseUtils.parseDateToStr(ticket.exited)],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(flex: 1, child: Image.asset('assets/images/parked_car.png')),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Вкупно:',
                                          style: font12Light.copyWith(
                                              color: colorGrayDark
                                          ),
                                        ),
                                        Text(
                                          ParseUtils.parseDifferenceToString(ticket.entered, ticket.exited),
                                          style: font16Bold.copyWith(
                                              color: colorBlueDarkLight
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
        Expanded(
          flex: 1,
          child: Stack(
            alignment: Alignment.center,
            children: [
              HorizontalDashedLine(
                color: Colors.grey,
                length: 850,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.network(
                  ticket.parking.imageUrl,
                ),
              ),
            ]
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      ticket.parking.name,
                      style: font14Bold.copyWith(
                          color: colorBlueDarkLight,
                      ),
                    ),
                    Text(
                      ticket.parking.locationAddress,
                      style: font10Bold.copyWith(
                          color: colorGrayDark,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: BarcodeWidget(
                    barcode: Barcode.codabar(),
                    data: ticket.ticketValue,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                    ),
                    color: colorBlueDarkLight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Вкупно',
                          style: font14Medium.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${ticket.price} денари',
                          style: font18Bold.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
