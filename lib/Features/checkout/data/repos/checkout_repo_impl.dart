import 'dart:developer';
import 'package:checkout_payment/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:checkout_payment/Features/checkout/data/repos/checkout_repo.dart';
import 'package:checkout_payment/core/errors/failure.dart';
import 'package:checkout_payment/core/utils/stripe_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class CheckoutRepoImpl extends CheckoutRepo {
  final StripeService stripeService = StripeService();
  @override
  Future<Either<Failure, void>> makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel}) async {
    try {
      await stripeService.makePayment(
          paymentIntentInputModel: paymentIntentInputModel);
      return right(null);
    } on StripeException catch (e) {
      log(e.error.message ?? 'Oops there was an error');
      return left(ServerFailure(
          errMessage: e.error.message ?? 'Oops there was an error'));
    } catch (e) {
      log(e.toString());
      return left(ServerFailure(errMessage: e.toString()));
    }
  }
}
