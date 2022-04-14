import 'package:com_goodtakes/model/user/user_extension.dart';
import 'package:com_goodtakes/service/database/database_u.dart';
import 'package:com_goodtakes/service/launcher_service.dart';
import 'package:com_goodtakes/service/preference_service.dart';
import 'package:com_goodtakes/states/authentication_state.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/content/standard_interaction_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/views/payment_editor_view/payment_editor.dart';
import 'package:com_goodtakes/views/webview_launcher/webview_launcher.dart';
import 'package:com_goodtakes/widgets/interaction/appbar/static_appbar.dart';
import 'package:com_goodtakes/widgets/interaction/tapgable_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  Widget _layouting({required List<Widget> children}) {
    return Container(
        padding: StandardSize.generalViewPadding.copyWith(left: 0, right: 0),
        decoration: const BoxDecoration(
          color: StandardColor.white,
          borderRadius: StandardSize.generalChipBorderRadius,
        ),
        child: Column(children: children));
  }

  Widget _inlineBlockSeperator([Size size = const Size(10, 14)]) {
    return SizedBox(height: size.height, width: size.width);
  }

  final tapRowConstrains = const BoxConstraints(minHeight: 50);
  @override
  Widget build(BuildContext context) {
    const EdgeInsets horizontalPad =
        EdgeInsets.symmetric(horizontal: 36, vertical: 10);

    final model = RM.get<SharedPreferences>();
    return Scaffold(
        backgroundColor: StandardColor.lightGrey,
        appBar: StaticAppBar(
            title: StandardInappContentType.settingsAppbarTitle.label),
        body: ListView(
            padding:
                StandardSize.generalViewPadding.copyWith(top: 20, bottom: 20),
            children: [
              _layouting(children: [
                TapableTile(
                    padding: horizontalPad,
                    constraints: tapRowConstrains,
                    message:
                        StandardInteractionTextType.settingsLangTapLabel.label,
                    prefix: null,
                    onTap: () {},
                    suffix: Text(
                      "繁體中文",
                      style: StandardTextStyle.grey14R,
                    )),
                OnBuilder(
                    listenTo: model,
                    builder: () => TapableTile(
                        padding: horizontalPad,
                        constraints: tapRowConstrains,
                        message: StandardInteractionTextType
                            .settingsNotificationTapLabel.label,
                        prefix: null,
                        onTap: () {},
                        suffix: SizedBox(
                          height: 20,
                          child: Switch.adaptive(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              activeColor: StandardColor.yellow,
                              value: PreferenceType
                                      .pushNotificationEnable.booleanValue ??
                                  false,
                              onChanged: (value) {
                                model.setState((s) => PreferenceType
                                    .pushNotificationEnable
                                    .updateBoolean(value));
                              }),
                        ))),
                OnBuilder(
                    listenTo: RM.get<AuthenticationState>(),
                    builder: () => TapableTile(
                        padding: horizontalPad,
                        constraints: tapRowConstrains,
                        message: StandardInteractionTextType
                            .settingsMktOptInTapLabel.label,
                        prefix: null,
                        onTap: () {},
                        suffix: SizedBox(
                            height: 20,
                            child: Switch.adaptive(
                                activeColor: StandardColor.yellow,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                value: RM
                                        .get<AuthenticationState>()
                                        .state
                                        .profile
                                        ?.emailOptin ??
                                    false,
                                onChanged: (value) {
                                  RM.get<AuthenticationState>().setState((s) =>
                                      RM
                                          .get<AuthenticationState>()
                                          .state
                                          .profile!
                                          .emailOptin = value);
                                  updateProfile(
                                      {UserDBKey.emailOptin.dbKey: value});
                                }))))
              ]),
              _inlineBlockSeperator(),
              _layouting(children: [
                TapableTile(
                    padding: horizontalPad,
                    constraints: tapRowConstrains,
                    message: StandardInteractionTextType
                        .settingsPaymentMethodTapLabel.label,
                    // suffix: null,
                    onTap: () {
                      debugPrint("push PaymentEditorView");
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (_) => const PaymentEditorView()));
                    })
              ]),
              _inlineBlockSeperator(),
              _layouting(children: [
                TapableTile(
                    padding: horizontalPad,
                    constraints: tapRowConstrains,
                    message:
                        StandardInteractionTextType.settingsQATapLabel.label,
                    // suffix: null,
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (_) => WebViewLauncher(
                              url: "https://google.com",
                              title: StandardInteractionTextType
                                  .settingsQATapLabel.label)));
                    }),
                TapableTile(
                    padding: horizontalPad,
                    constraints: tapRowConstrains,
                    message: StandardInteractionTextType
                        .settingsContactTapLabel.label,
                    // suffix: null,
                    onTap: () {
                      standardLauncher(LauncherType.email);
                    }),
                TapableTile(
                    padding: horizontalPad,
                    constraints: tapRowConstrains,
                    message: StandardInteractionTextType
                        .settingsAdviceTapLabel.label,
                    // suffix: null,
                    onTap: () {
                      standardLauncher(LauncherType.email);
                    }),
                TapableTile(
                    padding: horizontalPad,
                    constraints: tapRowConstrains,
                    message: StandardInteractionTextType
                        .settingsRateMeTapLabel.label,
                    // suffix: null,
                    onTap: () {})
              ]),
              _inlineBlockSeperator(),
              _layouting(children: [
                TapableTile(
                    padding: horizontalPad,
                    messageStyle: StandardTextStyle.yellow14R,
                    constraints: tapRowConstrains,
                    message: StandardInteractionTextType
                        .generalButtonSignOutLabel.label,
                    prefix: null,
                    suffix: null,
                    onTap: () {
                      Navigator.of(context).popUntil((r) {
                        return r.settings.name == "/";
                      });
                      RM
                          .get<AuthenticationState>()
                          .setState((s) => s.signOut());
                    })
              ]),
              _inlineBlockSeperator(),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(style: StandardTextStyle.black12R, children: [
                    TextSpan(
                        text: StandardInappContentType
                            .generalCopyrightStatement.label),
                    const TextSpan(text: "\n"),
                    TextSpan(
                        text: StandardInappContentType
                            .generalCopyrightVersionStatement.label),
                    const TextSpan(text: "\n\n"),
                    TextSpan(
                        text: StandardInappContentType
                            .generalUserRegulation.label,
                        style: StandardTextStyle.yellow12U,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (_) => WebViewLauncher(
                                      url: StandardInappContentType
                                          .generalUserRegulationURL.label,
                                      title: StandardInappContentType
                                          .generalUserRegulation.label,
                                    )));
                          }),
                    WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            width: 3,
                            height: 3,
                            decoration: const BoxDecoration(
                                color: StandardColor.black,
                                shape: BoxShape.circle))),
                    TextSpan(
                        style: StandardTextStyle.yellow12U,
                        text:
                            StandardInappContentType.generalPrivacyPolicy.label,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (_) => WebViewLauncher(
                                      url: StandardInappContentType
                                          .generalPrivacyStatementURL.label,
                                      title: StandardInappContentType
                                          .generalPrivacyPolicy.label,
                                    )));
                          }),
                  ])),
              _inlineBlockSeperator(const Size(0, 50))
            ]));
  }
}
