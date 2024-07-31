import 'package:checkout_payment/Features/checkout/data/models/ephemeral_key_model/ephemeral_key_model.dart';
import 'package:checkout_payment/Features/checkout/data/models/init_payment_sheet_input_model.dart';
import 'package:checkout_payment/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:checkout_payment/Features/checkout/data/models/payment_intent_models/payment_intent_model.dart';
import 'package:checkout_payment/core/utils/api_keys.dart';
import 'package:checkout_payment/core/utils/api_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:dio/dio.dart';

// class StripeService {
//   final ApiService apiService = ApiService();

//   Future<PaymentIntentModel> createPaymentIntent(
//       PaymentIntentInputModel paymentIntentInputModel) async {
//     var response = await apiService.post(
//       body: paymentIntentInputModel.toJson(),
//       contentType: Headers.formUrlEncodedContentType,
//       url: 'https://api'
//           '.stripe.com/v1/payment_intents',
//       token: ApiKeys.secretKey,
//     );

//     var paymentIntentModel = PaymentIntentModel.fromJson(response.data);
//     return paymentIntentModel;
//   }

//   Future initPaymentSheet(
//       {required InitiPaymentSheetInputModel initModel}) async {
//     await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//             paymentIntentClientSecret: initModel.clientSecret,
//             customerEphemeralKeySecret: initModel.ephemeralKeySecret,
//             customerId: initModel.customerId,
//             merchantDisplayName: 'Toqua'));
//   }

//   Future displayPaymentSheet() async {
//     await Stripe.instance.presentPaymentSheet();
//   }

//   Future makePayment(
//       {required PaymentIntentInputModel paymentIntentInputModel}) async {
//     var paymentIntentModel = await createPaymentIntent(paymentIntentInputModel);
//     /*althought this doesnot return anything , but we must make it await as
//     there is another step after it*/
//     var ephemeralKeyModel = await createEphemeralKey(
//         customerId: paymentIntentInputModel.customerId);

//     var initPaymentSheetInputModel = InitiPaymentSheetInputModel(
//         clientSecret: paymentIntentModel.clientSecret!,
//         customerId: paymentIntentInputModel.customerId,
//         ephemeralKeySecret: ephemeralKeyModel.secret!);
//     await initPaymentSheet(initModel: initPaymentSheetInputModel);
//     await displayPaymentSheet();
//   }

//   Future<PaymentIntentModel> createCustomer(
//       PaymentIntentInputModel paymentIntentInputModel) async {
//     var response = await apiService.post(
//       body: paymentIntentInputModel.toJason(),
//       contentType: Headers.formUrlEncodedContentType,
//       url: 'https://api.stripe.com/v1/customers',
//       token: ApiKeys.secretKey,
//     );

//     var paymentIntentModel = PaymentIntentModel.fromJson(response.data);
//     return paymentIntentModel;
//   }

//   Future<EphemeralKeyModel> createEphemeralKey(
//       {required String customerId}) async {
//     /*we didnot make model as it's only one field */
//     var response = await apiService.post(
//         body: {'customer': customerId},
//         contentType: Headers.formUrlEncodedContentType,
//         url: 'https://api.stripe.com/v1/ephemeral_keys',
//         token: ApiKeys.secretKey,
//         headers: {
//           'Authorization': "Bearer ${ApiKeys.secretKey}",
//           'Stripe-Version': '2024-06-20'
//         });

//     var ephemeralKey = EphemeralKeyModel.fromJson(response.data);
//     return ephemeralKey;
//   }
// }

class StripeService {
  final ApiService apiService = ApiService();
  Future<PaymentIntentModel> createPaymentIntent(
      PaymentIntentInputModel paymentIntentInputModel) async {
    var response = await apiService.post(
        body: paymentIntentInputModel.toJson(),
        contentType: Headers.formUrlEncodedContentType,
        url: "https://api.stripe.com/v1/payment_intents",
        token: ApiKeys.secretKey);

    var paymentIntentModel = PaymentIntentModel.fromJson(response.data);

    return paymentIntentModel;
  }

  Future initPaymentSheet(
      {required InitPaymentSheetInputModel initiPaymentSheetInputModel}) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: initiPaymentSheetInputModel.clientSecret,
        customerEphemeralKeySecret:
            initiPaymentSheetInputModel.ephemeralKeySecret,
        customerId: initiPaymentSheetInputModel.customerId,
        merchantDisplayName: "Toqua",
      ),
    );
  }

  Future displayPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }

  Future makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel}) async {
    var paymentIntentModel = await createPaymentIntent(paymentIntentInputModel);
    var ephemeralKeyModel = await createEphemeralKey(
        customerId: paymentIntentInputModel.customerId);
    var initPaymentSheetInputModel = InitPaymentSheetInputModel(
        clientSecret: paymentIntentModel.clientSecret!,
        customerId: paymentIntentInputModel.customerId,
        ephemeralKeySecret: ephemeralKeyModel.secret!);
    await initPaymentSheet(
        initiPaymentSheetInputModel: initPaymentSheetInputModel);
    await displayPaymentSheet();
  }

  Future<EphemeralKeyModel> createEphemeralKey(
      {required String customerId}) async {
    var response = await apiService.post(
        body: {"customer": customerId},
        contentType: Headers.formUrlEncodedContentType,
        url: "https://api.stripe.com/v1/ephemeral_keys",
        token: ApiKeys.secretKey,
        headers: {
          "Authorization": "Bearer ${ApiKeys.secretKey}",
          "Stripe-Version": "2023-08-16",
        });

    var ephermeralKey = EphemeralKeyModel.fromJson(response.data);

    return ephermeralKey;
  }
}
