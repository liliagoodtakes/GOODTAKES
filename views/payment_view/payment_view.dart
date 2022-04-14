import 'package:com_goodtakes/model/payment_session.dart';
import 'package:com_goodtakes/model/receipt/user_receipt.dart';
import 'package:com_goodtakes/model/restro/restro.dart';
import 'package:com_goodtakes/service/convertor/int.dart';
import 'package:com_goodtakes/service/database/database_u.dart';
import 'package:com_goodtakes/service/payment_service.dart';
import 'package:com_goodtakes/service/routing/paths.dart';
import 'package:com_goodtakes/states/authentication_state.dart';
import 'package:com_goodtakes/static/content/standard_asset_image.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/content/standard_interaction_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_button_style.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/views/transaction_detail_view/transaction_detail_view.dart';
import 'package:com_goodtakes/widgets/display/count_down_interval.dart';
import 'package:com_goodtakes/widgets/display/decorated_title.dart';
import 'package:com_goodtakes/widgets/display/payment_chip_selector.dart';
import 'package:com_goodtakes/widgets/display/payment_session.dart/payment_session_restro_info.dart';
import 'package:com_goodtakes/widgets/display/widget_order_detail.dart';
import 'package:com_goodtakes/widgets/interaction/alert/simple_alert_dialog.dart';
import 'package:com_goodtakes/widgets/interaction/appbar/static_appbar.dart';
import 'package:com_goodtakes/widgets/interaction/loading_button_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class PaymentView extends StatefulWidget {
  final PaymentSession session;
  final Restro restro;
  const PaymentView({required this.restro, Key? key, required this.session})
      : super(key: key);

  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  Widget get headlineColSeperator => const SizedBox(height: 20);
  Widget get inlineColSeperator => const SizedBox(height: 10);
  final GlobalKey<CountDownIntervalState> countdownInterval = GlobalKey();
  final GlobalKey<PaymentChipSelectorState> paymentMethod = GlobalKey();

  bool isLoading = false;

  @override
  void dispose() {
    releasePaymentSession(widget.session);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: StaticAppBar(title: "付款"),
        body: SafeArea(
            child: ListView(padding: EdgeInsets.zero, children: [
          Material(
              elevation: 5,
              shadowColor: Colors.black54,
              child: Padding(
                  padding: StandardSize.generalViewPadding,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CountDownInterval(
                            key: countdownInterval,
                            onComplete: () {
                              showSimpleAlert(
                                  context: context,
                                  actions: [
                                    ElevatedButton(
                                        style: StandardButtonStyle
                                            .regularYellowButtonStyle,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(StandardInteractionTextType
                                            .generalButtonBackLabel.label))
                                  ],
                                  icon: const Image(
                                      image: AssetImage(
                                          StandardAssetImage.popupTimeout)),
                                  message: "",
                                  title: StandardInappContentType
                                      .popUpTimeOutTitle.label);
                            },
                            maxCount: 600,
                            builder: ((context, countDown) {
                              return Container(
                                  decoration: BoxDecoration(
                                      color: StandardColor.white,
                                      borderRadius:
                                          StandardSize.generalChipBorderRadius,
                                      border: Border.all(
                                          color: StandardColor.yellow)),
                                  padding:
                                      StandardSize.generalChipBorderPadding,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              DecoratedTitle(
                                                  title:
                                                      StandardInappContentType
                                                          .paymentCountDownTitle
                                                          .label),
                                              const SizedBox(width: 25),
                                              Text(
                                                  IntMethod.toTimeDisplay(
                                                      value: countDown),
                                                  style: StandardTextStyle
                                                      .yellow14SB)
                                            ]),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                                StandardInteractionTextType
                                                    .generalButtonCancelLabel
                                                    .label,
                                                style: StandardTextStyle
                                                    .yellow14U))
                                      ]));
                            })),
                        headlineColSeperator,
                        OrderRestroInfoP(
                            restro: widget.restro,
                            pickupTimeDisplay:
                                widget.session.generalPickUpTimeRangeStatement,
                            restroId: widget.session.restroId),
                        headlineColSeperator,
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DecoratedTitle(
                                  title: StandardInappContentType
                                      .paymentBillSummaryTitle.label),
                              inlineColSeperator,
                              OrderDetail(details: [widget.session.detail]),
                            ]),
                        headlineColSeperator,
                        DecoratedTitle(
                            title: StandardInappContentType
                                .generalPaymentMethodTitle.label),
                        inlineColSeperator
                      ]))),
          Padding(
              padding: StandardSize.generalViewPadding,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OnBuilder(
                        listenTo: RM.get<AuthenticationState>(),
                        builder: () {
                          return PaymentChipSelector(
                              key: paymentMethod,
                              paymentMethods: RM
                                  .get<AuthenticationState>()
                                  .state
                                  .profile!
                                  .paymentMethods);
                        })
                  ]))
        ])),
        bottomNavigationBar: LoadingButtonBuilder(
            loadingSize: const Size.fromHeight(80),
            callback: () async {
              if (RM
                  .get<AuthenticationState>()
                  .state
                  .profile!
                  .paymentMethods
                  .isEmpty) {
                paymentMethod.currentState!.setError();
              } else if (!isLoading) {
                isLoading = true;
                countdownInterval.currentState?.pause();
                final UserReceipt receipt = await paySession(
                        restroAddress: widget.restro.address,
                        restroName: widget.restro.name,
                        session: widget.session,
                        paymentCard: paymentMethod.currentState!.selected.last4,
                        paymentId: paymentMethod.currentState!.selected.id,
                        issuer: paymentMethod.currentState!.selected.issuer)
                    .catchError((e) {
                  showSimpleAlert(
                      context: context,
                      icon: const Image(
                          image: AssetImage(StandardAssetImage.popupFailed)),
                      message: "請重新購買",
                      title: "付款失敗",
                      actions: [
                        ElevatedButton(
                            style: StandardButtonStyle.regularYellowButtonStyle,
                            onPressed: () {
                              Navigator.of(context).pop();
                              countdownInterval.currentState?.restart();
                            },
                            child: const Text("返回"))
                      ]);
                });
                Navigator.of(context).pushReplacement(CupertinoPageRoute(
                    builder: (_) =>
                        TransactionDetailView(receiptId: receipt.id)));
              }
            },
            builder: (context, loading, onclick) => ElevatedButton(
                style: StandardButtonStyle.purchaseButtonStyle,
                onPressed: onclick,
                child: Align(
                    alignment: Alignment.topCenter,
                    child: RichText(
                        text: TextSpan(
                            style: StandardTextStyle.black18B,
                            children: [
                          TextSpan(
                              text: StandardInteractionTextType
                                  .generalPayCTALabel.label),
                          const TextSpan(text: " ‧ "),
                          TextSpan(
                              text: StandardInappContentType
                                  .generalAmountWithCurrencyStatement.label
                                  .replaceFirst(
                                      valueReplacementTag,
                                      widget.session.payable
                                          .ceil()
                                          .toString())),
                        ]))))));
  }
}
