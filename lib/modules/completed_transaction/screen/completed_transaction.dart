import 'package:flutter/material.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/modules/ticket_information/screen/ticket_information_screen.dart';
import 'package:squick/utils/helpers/scanner.dart';
import 'package:squick/widgets/squick_button.dart';

class CompletedTransactionScreen extends StatelessWidget {

  static const String id = "/completed-transaction";

  @override
  Widget build(BuildContext context) {

    final success = ModalRoute.of(context)!.settings.arguments as bool;

    return SafeArea(
        child: Scaffold(
          backgroundColor: success ? colorBlueLight : colorRed,
          body: Column(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(70.0),
                      child: success? Image.asset('assets/images/successful_transaction.png') : Image.asset('assets/images/unsuccessful_transaction.png'),
                    ),
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(180),
                      bottomRight: Radius.circular(180),
                    )
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    color: success ? colorBlueLight : colorRed,
                    child: Column(
                      mainAxisAlignment:  MainAxisAlignment.end,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: SizedBox(width: 5.0,)
                        ),
                        Expanded(
                          flex: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center ,
                            children: [
                              Text(
                                success? 'УСПЕШНО ПЛАЌАЊЕ' : 'НЕУСПЕШНА ТРАНСАКЦИЈА',
                                textAlign: TextAlign.center,
                                style: font24Bold.copyWith(color: Colors.white),
                              ),
                              const SizedBox(height: 8.0,),
                              Text(
                                success?
                                'Направивте успешно плаќање на паркинг билетот.' :
                                'Поради грешка со системот трансакцијата не беше успешна, Ве молиме обидете се повторно',
                                textAlign: TextAlign.center,
                                style: font14Light.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: SquickButton(
                            buttonText: success ? 'Продолжи' : 'Обиди се повторно',
                            textColor: success ? Colors.white : colorBlueDark,
                            backgroundColor: success ? colorBlueDark : Colors.white,
                            onTap: () async {
                              Navigator.pop(context);
                              if (!success) {
                                final ticketInfo = await Scanner.scan(context);

                                if (ticketInfo == null || ticketInfo == -1) {
                                  return;
                                }

                                Navigator.pushNamed(context, TicketInformation.id, arguments: ticketInfo);
                              }
                            },
                          ),
                        )
                      ],
                    )
                  ),
                )
              )
            ],
          ),
        )
    );
  }
}
