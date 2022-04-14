import 'package:com_goodtakes/admin_backstage/sign_in.dart';
import 'package:com_goodtakes/model/user/usr_profile.dart';
import 'package:com_goodtakes/service/app_initial_service.dart';
import 'package:com_goodtakes/service/notification_service.dart';
import 'package:com_goodtakes/service/preference_service.dart';
import 'package:com_goodtakes/service/routing/routing_service.dart';
import 'package:com_goodtakes/states/authentication_state.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/views/entry_view/onboarding_view.dart';
import 'package:com_goodtakes/views/home_state_view/homepage_builder.dart';
import 'package:com_goodtakes/views/splash_view/splash_view.dart';
import 'package:com_goodtakes/widgets/debug/standard_widget_testor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  runApp(const MaterialAppSetting());
}

class MaterialAppSetting extends StatelessWidget {
  const MaterialAppSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
            }),
            inputDecorationTheme: InputDecorationTheme(
                isDense: true,
                contentPadding: const EdgeInsets.only(top: 2, bottom: 4),
                prefixStyle: StandardTextStyle.grey14R,
                hintStyle: StandardTextStyle.grey14R,
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: StandardColor.yellow)),
                errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: StandardColor.red)),
                border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: StandardColor.yellow))),
            textSelectionTheme:
                const TextSelectionThemeData(cursorColor: StandardColor.yellow),
            scaffoldBackgroundColor: StandardColor.lightGrey),
        onGenerateRoute: onGenerateRoute,
        home: const AppRunner());

    // const SplashView()
    // home: const StandardWidgetTestor());
  }
}

class AppRunner extends StatelessWidget {
  const AppRunner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return FutureBuilder<Map<AppInitComponent, dynamic>?>(
        future: appInitiator,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            /// Splash View
            return const SplashView();
          } else if (snapshot.hasData) {
            /// App View
            // debugPrint("appInitiator data ${snapshot.data?.keys}");
            // debugPrint(
            //     "available restro ${(snapshot.data?[AppInitComponent.restro] as List).length}");

            return Injector(
                inject: [
                  Inject<SharedPreferences>(
                      () => snapshot.data?[AppInitComponent.pref]),
                  Inject<AuthenticationState>(() => AuthenticationState(
                      user: snapshot.data?[AppInitComponent.user],
                      profile: snapshot.data?[AppInitComponent.userProfile]))
                ],
                builder: (_) {
                  return OnBuilder(
                      listenTo: RM.get<AuthenticationState>(),
                      builder: () {
                        final model = RM.get<AuthenticationState>();
                        final User? user = model.state.user;
                        final UsrProfile? profile = model.state.profile;
                        debugPrint(
                            " user != null ? ${user != null}  // profile ${profile != null}");
                        if (user != null && profile != null) {
                          return const HomepageView();
                          // return ProfileCreator(
                          //     user: user,
                          //     optin: false,
                          //     phoneNumber: "12345667");
                        } else if (PreferenceType.isFirstLaunch.booleanValue !=
                            false) {
                          return const EntryView();
                        } else {
                          return const EntryView(initPage: 3);
                        }
                      });
                });
          } else {
            debugPrint("${snapshot.error}");
            return const SplashView();
          }
        });
  }
}
