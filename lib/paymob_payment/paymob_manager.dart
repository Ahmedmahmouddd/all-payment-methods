import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:stripe_payment_app/paymob_payment/paymob_keys.dart';

class PaymobPaymentManager {
  Dio dio = Dio();

  Future<String> payWithPayMob({required int amount}) async {
    try {
      String token = await _getToken();
      int orderId = await _getOrderId(authToken: token, amount: (amount * 100).toString());
      String paymentKey = await _getPaymentKey(
          authToken: token, orderId: orderId.toString(), amount: (amount * 100).toString());
      return paymentKey;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> _getToken() async {
    try {
      Response response = await dio.post(
        "https://accept.paymob.com/api/auth/tokens",
        data: {
          "api_key": PaymobApiKeys.apiKey,
        },
      );
      return response.data["token"];
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<int> _getOrderId({required String authToken, amount}) async {
    try {
      Response response = await dio.post(
        'https://accept.paymob.com/api/ecommerce/orders',
        data: {
          "auth_token": authToken,
          "delivery_needed": "false",
          "amount_cents": amount,
          "currency": "EGP",
          "items": [],
        },
      );
      return response.data["id"];
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }

  Future<String> _getPaymentKey({required String authToken, orderId, amount}) async {
    try {
      Response response = await dio.post('https://accept.paymob.com/api/acceptance/payment_keys', data: {
        'auth_token': authToken,
        'amount_cents': amount,
        'expiration': 3600,
        'currency': 'EGP',
        'integration_id': PaymobApiKeys.integrationId,
        'order_id': orderId,
        'billing_data': {
          //  must be values
          'first_name': 'Ahmed',
          'last_name': 'Mahmoud',
          'email': 'ahmedmahmouddd57@gmail.com',
          'phone_number': '01017094431',
          //  can be NA
          'city': 'NA',
          'floor': 'NA',
          'state': 'NA',
          'street': 'NA',
          'country': 'NA',
          'building': 'NA',
          'apartment': 'NA',
          'postal_code': 'NA',
          'shipping_method': 'NA',
        },
      });
      return response.data["token"];
    } catch (e) {
      return e.toString();
    }
  }
}
