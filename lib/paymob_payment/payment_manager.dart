import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:stripe_payment_app/paymob_payment/paymob_keys.dart';

class PaymentManager {
  Dio dio = Dio();

  Future<String> payWithPayMob({required int amount}) async {
    try {
      String token = await getToken();
      int orderId = await getOrderId(token: token, amount: (amount * 100).toString());
      String paymentKey =
          await getPaymentKey(token: token, orderId: orderId.toString(), amount: (amount * 100).toString());
      return paymentKey;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> getToken() async {
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

  Future<int> getOrderId({required String token, required String amount}) async {
    try {
      Response response = await dio.post('https://accept.paymob.com/api/ecommerce/orders', data: {
        "auth_token": token,
        "delivery_needed": "true",
        "amount_cents": amount,
        "currency": "EGP",
        "items": [],
      });
      return response.data["id"];
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }

  Future<String> getPaymentKey(
      {required String token, required String orderId, required String amount}) async {
    try {
      Response response = await dio.post('https://accept.paymob.com/api/acceptance/payment_keys', data: {
        'auth_token': token,
        'amount_cents': amount,
        'currency': 'EGP',
        'integration_id': PaymobApiKeys.integrationId,
        'lock_order_when_paid': true,
        'order_id': orderId,
        'billing_data': {
          'apartment': 'NA',
          'email': 'ahmed@gmail.com',
          'floor': 'NA',
          'first_name': 'ahmed',
          'street': 'NA',
          'building': 'NA',
          'phone_number': '0123456789',
          'shipping_method': 'NA',
          'postal_code': 'NA',
          'city': 'NA',
          'country': 'NA',
          'last_name': 'mohamed',
          'state': 'NA',
        },
      });
      return response.data["token"];
    } catch (e) {
      return e.toString();
    }
  }
}
