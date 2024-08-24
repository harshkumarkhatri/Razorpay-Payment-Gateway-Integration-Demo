import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Razorpay Payment demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Razorpay payment demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
// Create a Razorpay instance
  Razorpay razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    // Attach Listeners for Payment Events
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, paymentSuccessHandler);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, paymentErrorHandler);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWalletHandler);
  }

  void paymentSuccessHandler(PaymentSuccessResponse response) {
    log('Payment Successful: ${response.paymentId}');
  }

  void paymentErrorHandler(PaymentFailureResponse response) {
    log('Payment Error: ${response.code} - ${response.message}');
  }

  void externalWalletHandler(ExternalWalletResponse response) {
    log('External Wallet: ${response.walletName}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              'Some count',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openCheckout();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), 
    );
  }

  void _openCheckout() {
    var options = {
      'key': 'Your razor pay api key',
      'amount': 2000,
      'name': 'Harsh\'s Store',
      'description': 'Payment for your order',
      // These can be sent prefilled or we can allow the user to fill it.
      'prefill': {'contact': '9876543210', 'email': 'customer@example.com'},
    };
    try {
      razorpay.open(options);
    } catch (e) {
      log('Error: $e');
    }
  }
}
