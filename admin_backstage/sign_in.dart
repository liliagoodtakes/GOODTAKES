import 'package:com_goodtakes/admin_backstage/main_state.dart';
import 'package:com_goodtakes/admin_backstage/method_list.dart';
import 'package:com_goodtakes/admin_backstage/web_form_view.dart';
import 'package:com_goodtakes/service/routing/paths.dart';
import 'package:com_goodtakes/static/content/standard_interaction_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_button_style.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/widgets/display/gootake_logo_view.dart';
import 'package:com_goodtakes/widgets/display/widget_verification_container.dart';
import 'package:com_goodtakes/widgets/interaction/alert/simple_loading.dart';
import 'package:com_goodtakes/widgets/interaction/digit_grid_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

const pincode = "123456";

class StaticAdminSignInView extends StatefulWidget {
  const StaticAdminSignInView({Key? key}) : super(key: key);

  @override
  State<StaticAdminSignInView> createState() => _StaticAdminSignInViewState();
}

class _StaticAdminSignInViewState extends State<StaticAdminSignInView> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final List<String> verificationCode = [];
  bool onError = false;

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: StandardColor.lightGrey,
                borderRadius: StandardSize.generalChipBorderRadius),
            child: Container(
                clipBehavior: Clip.antiAlias,
                padding: const EdgeInsets.symmetric(vertical: 50),
                decoration: const BoxDecoration(color: StandardColor.white),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const GoodTakeLogo(),
                  const SizedBox(height: 20),
                  Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (index) {
                        if (verificationCode.length - 1 >= index) {
                          return VerifiContainer(
                              onError: onError,
                              number: verificationCode.elementAt(index));
                        } else {
                          return VerifiContainer(
                              onError: onError,
                              onFocus: index == verificationCode.length,
                              number: "");
                        }
                      })),
                  SizedBox(
                      width: 350,
                      height: 280,
                      child: Scrollbar(
                          isAlwaysShown: false,
                          child: GridDigitInput(
                              // constraints:
                              //     BoxConstraints(maxWidth: 200, maxHeight: 200),
                              onPressed: (String input) {
                            if (onError) {
                              onError = false;
                            }
                            if (verificationCode.isNotEmpty && input == "X") {
                              verificationCode.removeLast();
                              // debugPrint(
                              //     "on remove ::: length: ${verificationCode.length}");

                              setState(() {});
                            } else if (input != "X" &&
                                verificationCode.length <= 5) {
                              verificationCode.add(input);
                              setState(() {});
                            }
                          }))),
                  const SizedBox(height: 20),
                  SizedBox(
                      width: 240,
                      child: ElevatedButton(
                          style: StandardButtonStyle.regularYellowButtonStyle,
                          onPressed: () {
                            debugPrint(verificationCode.join());
                            if (verificationCode.join() == pincode) {
                              Navigator.of(context)
                                  .pushReplacement(CupertinoPageRoute(
                                      builder: (_) => Injector(
                                          inject: [Inject(() => MainState())],
                                          initState: () {
                                            RM.get<MainState>().setState(
                                                (s) async => await s.init());
                                          },
                                          builder: (_) {
                                            return OnBuilder(
                                                listenTo: RM.get<MainState>(),
                                                builder: () {
                                                  final model =
                                                      RM.get<MainState>();
                                                  if (model.isWaiting) {
                                                    return Scaffold(
                                                        body: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            child:
                                                                SimpleLoader()));
                                                  } else {
                                                    return WebFormView();
                                                  }
                                                });
                                          })));
                            }
                          },
                          child: const Align(
                              alignment: Alignment.center,
                              child: Text("Login"))))
                ]))));
  }
}
