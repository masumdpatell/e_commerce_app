import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayment extends StatefulWidget {
  const RazorPayment({Key? key}) : super(key: key);

  @override
  State<RazorPayment> createState() => _RazorPaymentState();
}

class _RazorPaymentState extends State<RazorPayment> {
  final _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear(); // Removes all listeners
  }

  var options = {
    'key': 'rzp_live_wGp0VWYQgWdIto',
    'amount': 10000,
    'name': 'Eateria',
    'description': 'Canteen',
    'prefill': {'contact': '940817250', 'email': 'eateria.support@gmail.com'}
  };

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SP_PAY_RAZOR'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                try {
                  _razorpay.open(options);
                } catch (e) {
                  print(e);
                }
              },
              child: Text('Make Payment'),
            )
          ],
        ),
      ),
    );
  }
}
