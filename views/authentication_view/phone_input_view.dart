import 'package:com_goodtakes/service/authentication_service.dart';
import 'package:com_goodtakes/service/routing/paths.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/content/standard_interaction_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_button_style.dart';
import 'package:com_goodtakes/views/authentication_view/verification_code_input_view.dart';
import 'package:com_goodtakes/widgets/display/widget_login_text.dart';
import 'package:com_goodtakes/widgets/display/widget_registration_text.dart';
import 'package:com_goodtakes/widgets/display/widget_text_phone_number.dart';
import 'package:com_goodtakes/widgets/interaction/alert/simple_alert_dialog.dart';
import 'package:com_goodtakes/widgets/interaction/appbar/static_appbar.dart';
import 'package:com_goodtakes/widgets/interaction/digit_grid_input.dart';
import 'package:com_goodtakes/widgets/display/gootake_logo_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum SignInMode { reg, signIn }

class PhoneInputView extends StatelessWidget {
  final SignInMode mode;
  const PhoneInputView({this.mode = SignInMode.reg, Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    final smallDeviceAlert = MediaQuery.of(context).size.height <
        StandardSize.smallDeviceSizeCelling;

    final GlobalKey<TextPhoneNumberState> textPhoneNumberState = GlobalKey();
    void onVerificationCodeSend(String verificationId, int? resentTokent) {
      Navigator.of(context).push(CupertinoPageRoute(
          builder: (_) => VerificationInputView(
              mode: mode,
              optin: textPhoneNumberState.currentState!.optin,
              verificationId: verificationId,
              areaCode: textPhoneNumberState.currentState!.areaCode,
              phoneNumber: textPhoneNumberState.currentState!.phoneNumber)));
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: smallDeviceAlert,
        appBar: StaticAppBar(
            background: Colors.transparent, automaticInplementLeading: true),
        body: Container(
            padding: EdgeInsets.symmetric(
                horizontal: StandardSize.generalViewPadding.right),
            child: Column(children: [
              const SizedBox(height: 12),
              SizedBox(
                  height: 340,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            height: smallDeviceAlert ? 88 : null,
                            child: const GoodTakeLogo()),
                        const Expanded(child: SizedBox()),
                        if (mode == SignInMode.reg)
                          const RegistText()
                        else
                          LoginText(
                              title: StandardInappContentType
                                  .loginPhoneInputTitle.label,
                              content: StandardInappContentType
                                  .loginPhoneInputContent.label),
                        const Expanded(child: SizedBox()),
                        TextPhoneNumber(
                            key: textPhoneNumberState,
                            hideOptInButton: mode == SignInMode.signIn),
                        const Expanded(child: SizedBox())
                      ])),
              ElevatedButton(
                  style: StandardButtonStyle.regularYellowButtonStyle,
                  onPressed: () async {
                    if (textPhoneNumberState.currentState!.vaildate) {
                      final phone =
                          textPhoneNumberState.currentState!.phoneNumber;
                      debugPrint(
                          "phone number: ${textPhoneNumberState.currentState!.areaCode} + $phone");
                      await sendVerificationCodeWithPhoneNumber(
                              textPhoneNumberState.currentState!.areaCode,
                              phone, verificationFailed: (e) {
                        showSimpleAlert(
                            context: context,
                            icon: Icon(Icons.error),
                            message:
                                "${(e as FirebaseException).code} , ${(e as FirebaseException).message}",
                            title: "Debug Error");
                      }, codeSent: onVerificationCodeSend)
                          .catchError((onError) {
                        showSimpleAlert(
                            context: context,
                            icon: Icon(Icons.error),
                            message: "$onError",
                            title: "Debug Error");
                      });
                    }
                  },
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(StandardInteractionTextType
                          .generalButtonNextStepLabel.label))),
              const SizedBox(height: 10),
              Expanded(child: GridDigitInput(onPressed: (String input) {
                textPhoneNumberState.currentState!.updatePhoneNumber(input);
              })),
              const SizedBox(height: 20)
            ])));
  }
}
