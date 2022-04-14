import 'package:com_goodtakes/service/authentication_service.dart';
import 'package:com_goodtakes/states/authentication_state.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/content/standard_interaction_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_button_style.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/widgets/display/gootake_logo_view.dart';
import 'package:com_goodtakes/widgets/display/widget_login_text.dart';
import 'package:com_goodtakes/widgets/display/widget_user_profile_editor.dart';
import 'package:com_goodtakes/widgets/interaction/appbar/static_appbar.dart';
import 'package:com_goodtakes/widgets/interaction/gt_icon_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class ProfileCreatorView extends StatelessWidget {
  final String phoneNumber;
  final User user;
  final bool optin;
  ProfileCreatorView(
      {required this.user,
      required this.optin,
      required this.phoneNumber,
      Key? key})
      : super(key: key);

  final GlobalKey<UserProfileEditorState> editor = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final smallDeviceAlert = MediaQuery.of(context).size.height <
        StandardSize.smallDeviceSizeCelling;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: smallDeviceAlert,
        appBar: StaticAppBar(
          background: Colors.transparent,
          leading: GTIconButton(
              foregroundColor: StandardColor.yellow,
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () {
                Navigator.of(context)
                    .popUntil(((route) => route.settings.name == "/"));
              }),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(
                horizontal: StandardSize.generalViewPadding.right),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 12),
                  SizedBox(
                      height: 345,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                height: smallDeviceAlert ? 88 : null,
                                child: const GoodTakeLogo()),
                            const Expanded(child: SizedBox()),
                            LoginText(
                                title: StandardInappContentType
                                    .registerPersonalInfoTitle.label,
                                content: StandardInappContentType
                                    .registerPersonalContent.label),
                            const Expanded(child: SizedBox()),
                            UserProfileEditor(
                                formKey: formKey,
                                key: editor,
                                showPhoneNumber: false,
                                phoneNumber: phoneNumber,
                                padding: 0),
                            const Expanded(child: SizedBox()),
                          ])),
                  ElevatedButton(
                    style: StandardButtonStyle.regularYellowButtonStyle,
                    onPressed: () async {
                      if (editor.currentState?.dataVailadate ?? true) {
                        debugPrint("call to create Profile");
                        final sex = editor.currentState!.sex;

                        final email = editor.currentState!.emailController.text;
                        if (editor.currentState!.firstNameController.text
                                .isNotEmpty &&
                            editor.currentState!.lastNameController.text
                                .isNotEmpty &&
                            email.isNotEmpty) {
                          final profile = await requestNewProfile(user,
                              lastName:
                                  editor.currentState!.lastNameController.text,
                              firstName:
                                  editor.currentState!.firstNameController.text,
                              email: email,
                              phone: user.phoneNumber!,
                              sex: sex,
                              optin: optin);
                          if (profile != null) {
                            debugPrint("call to update at homeRunner");
                            RM
                                .get<AuthenticationState>()
                                .setState((s) => s.signIn(user, profile));
                            Navigator.of(context).popUntil(
                                (route) => route.settings.name == "/");
                          }
                        }
                      }
                      // debugPrint(
                      //     "any empty : sex = ${sex == null} ... name: ${name.isNotEmpty} ... email ${email.isNotEmpty}");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(StandardInteractionTextType
                          .generalCreateAccountLabel.label),
                    ),
                  )
                ])));
  }
}
