import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:squick/constants/api_constants.dart';
import 'package:squick/modules/ticket_information/model/ticket_info.dart';
import 'package:squick/modules/ticket_information/screen/ticket_information_screen.dart';
import 'package:squick/utils/helpers/parse_utils.dart';
import 'package:flutter/material.dart';

import 'networking.dart';

class Scanner {
  static Future<dynamic> _getTicketInfo(
      String ticketIdentifier, BuildContext context) async {
    var url = Uri.parse('$baseEndpoint/tickets/$ticketIdentifier');
    NetworkHelper networkHelper = NetworkHelper(url);

    var result = networkHelper.scanTicket(context);

    return result;
  }

  static Future<dynamic> scan(context) async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#000000", "Откажи", true, ScanMode.BARCODE);

    if (barcodeScanRes == '-1') {
      print("Cancel was pressed");
      return -1;
    }

    final apiTicketData = await _getTicketInfo(barcodeScanRes, context);

    if(apiTicketData!=null) {
      TicketInfo ticketInfo =
      ParseUtils.parseTicketInfo(apiTicketData, barcodeScanRes);

      return ticketInfo;
    }

    return null;
  }
}
