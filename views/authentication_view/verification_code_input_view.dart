import 'package:com_goodtakes/service/authentication_service.dart' as service;
import 'package:com_goodtakes/service/location_service.dart';
import 'package:com_goodtakes/service/routing/paths.dart';
import 'package:com_goodtakes/states/authentication_state.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/content/standard_interaction_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_button_style.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/views/authentication_view/phone_input_view.dart';
import 'package:com_goodtakes/views/authentication_view/profile_creator.dart';
import 'package:com_goodtakes/widgets/display/count_down_interval.dart';
import 'package:com_goodtakes/widgets/display/widget_verification_container.dart';
import 'package:com_goodtakes/widgets/display/widget_verification_text.dart';
import 'package:com_goodtakes/widgets/interaction/alert/full_page_loader.dart';
import 'package:com_goodtakes/widgets/interaction/appbar/static_appbar.dart';
import 'package:com_goodtakes/widgets/interaction/digit_grid_input.dart';
import 'package:com_goodtakes/widgets/display/gootake_logo_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class VerificationInputView extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final String areaCode;
  final SignInMode mode;
  final bool optin;
  const VerificationInputView(
      {Key? key,
      required this.optin,
      required this.mode,
      required this.verificationId,
      required this.areaCode,
      required this.phoneNumber})
      : super(key: key);

  @override
  _VerificationInputViewState createState() => _VerificationInputViewState();
}

class _VerificationInputViewState extends State<VerificationInputView> {
  final GlobalKey<CountDownIntervalState> countDownInterval = GlobalKey();
  final List<String> verificationCode = [];
  late String verificationId = widget.verificationId;

  late final String phoneNumner = "+${widget.areaCode} ${widget.phoneNumber}";
  bool onError = false;

  void pushProfileCreator(final User user) {
    Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(
            builder: (_) => ProfileCreatorView(
                optin: widget.optin,
                user: user,
                phoneNumber: phoneNumner)), (route) {
      return route.settings.name == "/";
    });
  }

  void signIn() async {
    if (verificationCode.join().length == 6) {
      showDialog(context: context, builder: (_) => const GTFullPageLoader());
      try {
        final UserCredential? userCred = await service
            .signIn(
                verificationId: verificationId, code: verificationCode.join())
            .whenComplete(() => Navigator.of(context).pop());
        if (userCred?.user != null) {
          if (userCred!.additionalUserInfo!.isNewUser) {
            // debugPrint("new user alert");
            pushProfileCreator(userCred.user!);
          } else {
            // pushProfileCreator(userCred.user!);

            final profile = await service.retrieveUsrProfile(userCred.user!);
            if (profile == null) {
              debugPrint("no profile alert");

              pushProfileCreator(userCred.user!);
            } else {
              RM
                  .get<AuthenticationState>()
                  .setState((s) => s.signIn(userCred.user!, profile));

              Navigator.of(context)
                  .popUntil((route) => route.settings.name == "/");
            }
          }
        }
      } catch (e) {
        debugPrint("error $e");
        onError = true;
        setState(() {});
      }
    } else {
      onError = true;
      setState(() {});
    }
  }

  late final smallDeviceAlert =
      MediaQuery.of(context).size.height < StandardSize.smallDeviceSizeCelling;
  @override
  Widget build(BuildContext context) {
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
                        VerifiText(
                            title: StandardInappContentType
                                .loginPhoneVerifyCodeInputContent.label,
                            content: StandardInappContentType
                                .registerPhoneVerifyCodeInputContent.label,
                            phoneNumber: phoneNumner),
                        const Expanded(child: SizedBox()),
                        SizedBox(
                            height: 60,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: List.generate(6, (index) {
                                        if (verificationCode.length - 1 >=
                                            index) {
                                          return VerifiContainer(
                                              onError: onError,
                                              number: verificationCode
                                                  .elementAt(index));
                                        } else {
                                          return VerifiContainer(
                                              onError: onError,
                                              onFocus: index ==
                                                  verificationCode.length,
                                              number: "");
                                        }
                                      })),
                                  Offstage(
                                      offstage: !onError,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              StandardInteractionTextType
                                                  .generalVerificationCodeError
                                                  .label,
                                              style:
                                                  StandardTextStyle.red12R))),
                                ])),
                        const Expanded(child: SizedBox())
                      ])),
              CountDownInterval(
                  key: countDownInterval,
                  maxCount: 60,
                  builder: (_, int left) {
                    return ElevatedButton(
                        onPressed: left != 0
                            ? null
                            : () async {
                                service.sendVerificationCodeWithPhoneNumber(
                                    widget.areaCode, widget.phoneNumber,
                                    verificationFailed: (e) {
                                  onError = true;
                                  setState(() {});
                                }, codeSent: (String verificationId,
                                        int? resentTokent) {
                                  this.verificationId = verificationId;

                                  debugPrint(
                                      "$verificationId ::: id = send count = $resentTokent");
                                }
                                    // }).then((value) {
                                    //   countDownInterval.currentState!
                                    //       .reset();
                                    // }).catchError((onError) {
                                    //   showSimpleAlert(
                                    //       context: context,
                                    //       icon: Icon(Icons.error),
                                    //       message: "$onError",
                                    //       title: "Debug Error");
                                    );
                              },
                        style: StandardButtonStyle.regularYellowButtonStyle,
                        child: Align(
                            alignment: Alignment.center,
                            child: left == 0
                                ? Text(
                                    StandardInteractionTextType
                                        .generalPhoneVerifyCountDownCompleteMessage
                                        .label,
                                    // style: StandardTextStyle.yellow12U,
                                  )
                                : Text(
                                    "$left ${StandardInteractionTextType.generalPhoneVerifyCodeOnCountDownMessage.label}",
                                    // style: StandardTextStyle.grey12R
                                  )));
                  }),
              const SizedBox(height: 10),
              Expanded(child: GridDigitInput(onPressed: (String input) {
                if (onError) {
                  onError = false;
                }
                if (verificationCode.isNotEmpty && input == "X") {
                  verificationCode.removeLast();
                  // debugPrint(
                  //     "on remove ::: length: ${verificationCode.length}");

                  setState(() {});
                } else if (input != "X" && verificationCode.length <= 5) {
                  verificationCode.add(input);
                  setState(() {});
                  if (verificationCode.length == 6) {
                    signIn();
                  }
                }
              })),
              const SizedBox(height: 20)
            ])));

    // return ScaffoldBuilder(
    //     title: "",
    //     context: context,
    //     body: Column(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Column(children: const [Text("T3")]),

    //           Container(
    //               margin: const EdgeInsets.symmetric(horizontal: 12),
    //               child: ElevatedButton(
    //                   style: StandardButtonStyle.regularYellowButtonStyle,
    //                   onPressed: () async {
    //                     final userCred = await signIn(
    //                         verificationId: widget.verificationId,
    //                         code: "123456");
    //                     if (userCred.user != null) {
    //                       if (userCred.additionalUserInfo!.isNewUser) {
    //                         pushProfileEditor(userCred.user!);
    //                       } else {
    //                         final profile =
    //                             await retrieveUsrProfile(userCred.user!);
    //                         if (profile == null) {
    //                           pushProfileEditor(userCred.user!);
    //                         } else {
    //                           RM.get<AuthenticationState>().setState(
    //                               (s) => s.updateUser(userCred.user!, profile));
    //                           Navigator.of(context).popUntil(
    //                               (route) => route.settings.name == "/");
    //                         }
    //                       }
    //                     }
    //                   },
    //                   child: Container(
    //                       alignment: Alignment.center,
    //                       child: const Text("驗證及登入")))),
    //           GridDigitInput(onPressed: (String input) {

    //           })
    //         ]));
  }
}
