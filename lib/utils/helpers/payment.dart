import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:squick/constants/api_constants.dart';
import 'package:squick/utils/helpers/networking.dart';
import 'package:stripe_payment/stripe_payment.dart';

import '../../models/stripe_transaction_response.dart';

class StripeService {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String secret = 'sk_test_51LC0INLW8XCKeq9cKhheTE3OyZ3KjUhVB3Sb889KG7U3NCRIPjFTJLONMkz5l7Zx6jPyidMwR9zX57Fr4VWn3YS900TYJ92gEz';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  static init() {
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: "pk_test_51LC0INLW8XCKeq9cf39dD2fa7bqEe5xanIWrj6c6LCpWmaAgIfVSFeUbcpWPvOiKE5RgT4LgARlwqgjVTEcifAhP0031DB6oOj",
        merchantId: "Test-Tscan",
        androidPayMode: 'test-Tscan',
      ),
    );
  }

  static Future<StripeTransactionResponse> payViaExistingCard({required int price, required String userId, required int ticketId, required CreditCard card}) async{
    try {
      var paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: card)
      );

      NetworkHelper networkHelper = NetworkHelper(Uri.parse('$baseEndpoint/stripe/payment-intent'));

      final intent = await networkHelper.createPaymentIntent(
        userId: userId,
        ticketId: ticketId,
        price: price,
      );

      var response = await StripePayment.confirmPaymentIntent(
          PaymentIntent(
              clientSecret: intent['clientSecret'],
              paymentMethodId: paymentMethod.id
          )
      );

      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
            message: 'Transaction successful',
            success: true
        );
      } else {
        return new StripeTransactionResponse(
            message: 'Transaction failed',
            success: false
        );
      }
    } on PlatformException catch(err) {
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}',
          success: false
      );
    }
  }

  static getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return StripeTransactionResponse(
        message: message,
        success: false
    );
  }

  static Future<Map<String, dynamic>?> createPaymentIntent(int amount) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount.toString(),
        'currency': 'USD',
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse(StripeService.paymentApiUrl),
          body: body,
          headers: StripeService.headers
      );
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return null;
  }
}