import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_payment_app/stripe_payment/stripe_keys.dart';

abstract class PaymentManager {
  static Future<void> makePayment(int amount, String currency) async {
    try {
      String clientSecret = await _getClientSecret((amount * 100).toString(), currency);
      await _initializePaymentSheet(clientSecret);
      await Stripe.instance.presentPaymentSheet();
    } catch (error) {
      if (error is StripeException && error.error.localizedMessage == "The payment flow has been canceled") {
        log("Payment has been cancelled by user");
      } else {
        print("حدث خطأ: ${error.toString()}");
        throw Exception("Error happened: ${error.toString()}");
      }
    }
  }

  static Future<String> _getClientSecret(String amount, String currency) async {
    Dio dio = Dio();
    var response = await dio.post(
      "https://api.stripe.com/v1/payment_intents",
      options: Options(
        headers: {
          'Authorization': "Bearer ${ApiKeys.secretKey}",
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      ),
      data: {
        'amount': amount,
        'currency': currency,
      },
    );
    return response.data["client_secret"];
  }

  static Future<void> _initializePaymentSheet(String clientSecret) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret, merchantDisplayName: "AHMED CO"),
    );
  }
}
