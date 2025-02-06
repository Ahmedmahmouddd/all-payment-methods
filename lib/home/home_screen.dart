import 'package:flutter/material.dart';
import 'package:stripe_payment_app/stripe_payment/payment_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 1,
        title: const Text("Stripe Payment"),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: const Text("Make Payment", style: TextStyle(color: Colors.white)),
          onPressed: () => PaymentManager.makePayment(10, "USD"),
        ),
      ),
    );
  }
}
