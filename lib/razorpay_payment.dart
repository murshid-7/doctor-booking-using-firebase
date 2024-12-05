import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPayment extends StatefulWidget {
  const RazorpayPayment({super.key});

  @override
  State<RazorpayPayment> createState() => _RazorpayPaymentState();
}

class _RazorpayPaymentState extends State<RazorpayPayment> {
  Razorpay razorpay = Razorpay();
  TextEditingController amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
