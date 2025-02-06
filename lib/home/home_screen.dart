import 'package:flutter/material.dart';
import 'package:stripe_payment_app/paymob_payment/paymob_manager.dart';
import 'package:stripe_payment_app/stripe_payment/stripe_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> payWithStripe({required int amount, required String currency}) async {
    StripePaymentManager.payWithStripe(amount, currency);
  }

  Future<void> payWithPaymob({required int amount}) async {
    PaymobPaymentManager().payWithPayMob(amount: amount).then((String paymentKey) {
      Uri.parse("https://accept.paymob.com/api/acceptance/iframes/791787?payment_token=$paymentKey");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 1,
        title: const Text("Stripe Payment"),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Make Payment with Stripe", style: TextStyle(color: Colors.white)),
              onPressed: () => payWithStripe(amount: 10, currency: "USD"),
            ),
          ),
          SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Make Payment with Paymob", style: TextStyle(color: Colors.white)),
              onPressed: () => payWithPaymob(amount: 10),
            ),
          ),
        ],
      ),
    );
  }
}
