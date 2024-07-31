import 'dart:developer';
import 'package:checkout_payment/Features/checkout/data/models/amount_model/amount_model.dart';
import 'package:checkout_payment/Features/checkout/data/models/amount_model/details.dart';
import 'package:checkout_payment/Features/checkout/data/models/item_list_model/item.dart';
import 'package:checkout_payment/Features/checkout/data/models/item_list_model/item_list_model.dart';
import 'package:checkout_payment/Features/checkout/presentation/manager/cubit/payment_cubit.dart';
import 'package:checkout_payment/Features/checkout/presentation/views/thank_you_view.dart';
import 'package:checkout_payment/core/utils/api_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../data/models/payment_intent_input_model.dart';
import '../my_cart_view.dart';

class CustomButtonBlocConsumer extends StatelessWidget {
  const CustomButtonBlocConsumer({
    super.key, required this.isPaypal,
  });
  final bool isPaypal;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ThankYouView()),
          );
        }
        if (state is PaymentFailure) {
          Navigator.of(context)
              .pop(); /*to show snack bar as it was behind sheet*/
          SnackBar snackBar = SnackBar(content: Text(state.errMessage));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        return CustomButton(
            onTap: () {
              if(isPaypal){
                var transactionData =getTransactionsData();
                ExecutePayPalPayment(context, transactionData);
              }else{
                excuteStripePayment(context);
              }
            },
            isLoading: state is PaymentLoading ? true : false,
            text: 'Continue');
      },
    );
  }

  void excuteStripePayment(BuildContext context) {
    PaymentIntentInputModel paymentIntentInputModel = PaymentIntentInputModel(
      amount: "100",
      currency: "USD",
      customerId: "cus_QZ6T9BAF7X07T6",
    );
    // /* as i build here one feature and there isnot any login ,so i used id from dashboard */
    BlocProvider.of<PaymentCubit>(context)
        .makePayment(paymentIntentInputModel: paymentIntentInputModel);
  }

  void ExecutePayPalPayment(BuildContext context, ({AmountModel amount, ItemListModel itemList}) transactionData) {
       Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => PaypalCheckoutView(
        sandboxMode: true,/*test mode*/
        clientId: ApiKeys.payPalClientId,
        secretKey: ApiKeys.payPalSecretKey,
        transactions:[
          {
            "amount": transactionData.amount.toJson(),
            "description": "The payment transaction description.",
            "item_list": transactionData.itemList.toJson(),
          }
        ],
        note: "Contact us for any questions on your order.",
        onSuccess: (Map params) async {
          log("onSuccess: $params");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return const ThankYouView();
            }),
                (route) {
                  return false ;
            },
          );
        },
        onError: (error) {
          log("onError: $error");
          SnackBar snackBar = SnackBar(content: Text(error.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return const MyCartView();
            }),
                (route) {
              return false;
            },
          );
        },
        onCancel: () {
          log('cancelled:');
          Navigator.pop(context);
        },
      ),
    ));
  }
  ({AmountModel amount, ItemListModel itemList}) getTransactionsData(){
    /*this is data type Record*/
    var amount =AmountModel(
        total: "100",
        currency: "USD",
        details: Details(
            shipping: "0",
            shippingDiscount: 0,
            subtotal: "100"
        )
    );

    List<OrderItemModel> orders =[
      OrderItemModel(
          currency: "USD",
          name: "Apple",
          price: "4",
          quantity: 10
      ),
      OrderItemModel(
          currency: "USD",
          name: "Apple",
          price: "5",
          quantity: 12
      ),
    ];

    var itemList= ItemListModel(orders: orders);
    return (amount:amount ,itemList:itemList);
    /*we begin first to return and give names to fields , then stand above
    return and it will give you type of Record*/
  }
}