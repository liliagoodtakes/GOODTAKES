import 'package:com_goodtakes/service/payment_service.dart';
import 'package:com_goodtakes/states/authentication_state.dart';
import 'package:com_goodtakes/static/content/standard_asset_image.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/content/standard_interaction_content.dart';
import 'package:com_goodtakes/static/content/standard_regex.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_button_style.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/widgets/interaction/alert/adaptive_dialog.dart';
import 'package:com_goodtakes/widgets/interaction/alert/simple_alert_dialog.dart';
import 'package:com_goodtakes/widgets/interaction/appbar/static_appbar.dart';
import 'package:com_goodtakes/widgets/interaction/loading_button_builder.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class PaymentMethodCreatorView extends StatelessWidget {
  const PaymentMethodCreatorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey();

    final TextEditingController creditNumberController =
        MaskedTextController(mask: "0000-0000-0000-0000");
    final MaskedTextController expiryController =
        MaskedTextController(mask: "00/00");
    final TextEditingController cvcController =
        MaskedTextController(mask: "000");
    final TextEditingController holderController = TextEditingController();
    const border = UnderlineInputBorder(
      borderSide: BorderSide(),
    );
    final inputDecoration = InputDecoration(
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: border,
        disabledBorder: border,
        focusedErrorBorder: border,
        border: border,
        isDense: false,
        labelStyle: StandardTextStyle.grey14R,
        floatingLabelStyle: StandardTextStyle.grey14R,
        contentPadding: const EdgeInsets.only(bottom: 5));
    return Scaffold(
        appBar: StaticAppBar(
            title: StandardInappContentType.addNewCreditCardTitle.label),
        body: Form(
            key: formKey,
            child: ListView(
                padding: StandardSize.generalViewPadding,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                          color: StandardColor.white,
                          borderRadius: StandardSize.generalChipBorderRadius),
                      padding: StandardSize.generalViewPadding,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        TextFormField(
                            autofocus: true,
                            validator: (String? value) {
                              return ValidatorType.notEmpty.validator(value);
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.number,
                            controller: creditNumberController,
                            decoration: inputDecoration.copyWith(
                                labelText: StandardInteractionTextType
                                    .creditCardNumberLabel.label)),
                        const SizedBox(height: 10),
                        Row(children: [
                          Expanded(
                              child: TextFormField(
                                  validator: (String? value) {
                                    return ValidatorType.notEmpty
                                        .validator(value);
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  controller: expiryController,
                                  keyboardType: TextInputType.number,
                                  decoration: inputDecoration.copyWith(
                                      labelText: StandardInteractionTextType
                                          .creditCardExpiryLabel.label))),
                          const SizedBox(width: 10),
                          Expanded(
                              child: TextFormField(
                                  validator: (String? value) {
                                    return ValidatorType.notEmpty
                                        .validator(value);
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  keyboardType: TextInputType.number,
                                  controller: cvcController,
                                  decoration: inputDecoration.copyWith(
                                      labelText: StandardInteractionTextType
                                          .creditCardCVCLabel.label)))
                        ]),
                        const SizedBox(height: 10),
                        TextFormField(
                            validator: (String? value) {
                              return ValidatorType.notEmpty.validator(value);
                            },
                            controller: holderController,
                            autocorrect: false,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(StandardRegExp.nonDigits))
                            ],
                            decoration: inputDecoration.copyWith(
                                labelText: StandardInteractionTextType
                                    .creditCardHolderNameLabel.label))
                      ])),
                  const SizedBox(height: 20),
                  Text(StandardInappContentType.newCreditCardStatement.label,
                      style: StandardTextStyle.grey12R,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  LoadingButtonBuilder(
                      builder: ((context, loading, startToLoad) =>
                          ElevatedButton(
                              style: StandardButtonStyle.confirmButtonStyle,
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  startToLoad();
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(StandardInteractionTextType
                                    .generalButtonConfirmLabel.label),
                              ))),
                      callback: () async {
                        final res = await createStripePaymentMethod(
                                cardNumber: creditNumberController.text
                                    .replaceAll("-", ""),
                                expMonth: expiryController.text
                                    .substring(0, 3)
                                    .replaceAll("/", ""),
                                expYear: expiryController.text
                                    .replaceAll("/", "")
                                    .substring(2, 4),
                                cvc: cvcController.text)
                            .catchError((onError) {
                          debugPrint(onError);
                          showAdaptiveDialogAlert(context,
                              title: "未能加入信用卡", message: Text("信用卡資訊錯誤"));
                        });

                        if (res != null) {
                          Navigator.of(context).pop();
                          RM.get<AuthenticationState>().setState(
                              (s) => s.profile!.paymentMethods.add(res));
                        }
                      })
                ])));
  }
}
