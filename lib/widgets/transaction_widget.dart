import 'package:flutter/material.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/modules/past_transactions/model/transaction.dart';
import 'package:squick/utils/helpers/date.dart';

class TransactionWidget extends StatelessWidget {
  double height;
  SingleTransaction transaction;

  TransactionWidget({Key? key, required this.transaction, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.1 * height,
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(image: NetworkImage(transaction.ticket.parking.imageUrlMedium),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.ticket.parking.name,
                      style: font16Regular.copyWith(color: colorBlueDark),
                    ),
                    Text(
                      DateHelper.getFormattedDateForTransaction(transaction.createdAt),
                      style: font12Regular.copyWith(color: colorBlueDarkLightest),
                    )
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${transaction.price.toString()} ден.',
                  style: font16Bold.copyWith(color: colorBlueDark),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
