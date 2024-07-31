class PaymentIntentInputModel {
  final String amount;
  final String currency;
  final String customerId;

  PaymentIntentInputModel(
      {required this.customerId, required this.amount, required this.currency});

  toJson() {
    final numAmount = num.parse(amount) * 100;
    return {
      'amount': numAmount.toString(),
      'currency': currency,
      'customer': customerId /*from paymentIntent Api */
    };
  }
}
