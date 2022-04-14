import 'package:com_goodtakes/model/user/user_extension.dart';
import 'package:com_goodtakes/service/database/database_u.dart';
import 'package:com_goodtakes/states/authentication_state.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/content/standard_interaction_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_button_style.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/widgets/display/widget_user_profile_editor.dart';
import 'package:com_goodtakes/widgets/interaction/appbar/notifiable_appbar.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class ProfileEditorView extends StatelessWidget {
  ProfileEditorView({Key? key}) : super(key: key);

  final GlobalKey<NotifiableAppbarState> appbarKey = GlobalKey();
  final GlobalKey<UserProfileEditorState> editor = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final model = RM.get<AuthenticationState>();
    // debugPrint(
    //     "model.state.profile!.lastName :: ${model.state.profile!.lastName}");
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
            child: NotifiableAppbar(
                key: appbarKey,
                backgroundColor: StandardColor.white,
                foregroundColor: StandardColor.yellow,
                onMessageForegroundColor: StandardColor.white,
                onMessageBackgroundColor: StandardColor.yellow,
                title: StandardInappContentType.profileAppbarTitle.label),
            preferredSize:
                const Size.fromHeight(StandardSize.appbarHeightAfterSafeArea)),
        body: ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: StandardSize.generalViewPadding,
            children: [
              Container(
                  padding: StandardSize.generalViewPadding,
                  decoration: const BoxDecoration(
                      borderRadius: StandardSize.generalChipBorderRadius,
                      color: StandardColor.white),
                  clipBehavior: Clip.antiAlias,
                  child: UserProfileEditor(
                      lastNameController: TextEditingController(
                          text: model.state.profile!.lastName),
                      firstNameController: TextEditingController(
                          text: model.state.profile!.firstName),
                      key: editor,
                      emailController: TextEditingController(
                          text: model.state.profile!.email),
                      phoneNumber: model.state.profile!.phone,
                      padding: 0)),
              const SizedBox(height: 30),
              ElevatedButton(
                  style: StandardButtonStyle.regularYellowButtonStyle,
                  onPressed: () async {
                    if (editor.currentState!.formKey.currentState!.validate()) {
                      await updateProfile({
                        UserDBKey.email.dbKey:
                            editor.currentState!.emailController.text,
                        UserDBKey.name.dbKey: {
                          UserDBKey.lastName.dbKey: {
                            "zh": editor.currentState!.lastNameController.text
                          },
                          UserDBKey.firstName.dbKey: {
                            "zh": editor.currentState!.firstNameController.text
                          }
                        },
                        UserDBKey.sex.dbKey: editor.currentState!.sex,
                      });
                      appbarKey.currentState?.sendNotification(
                          message: "資料已成功儲存",
                          icon: Icons.check_circle_outline_outlined);
                    }
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                        StandardInteractionTextType.generalSaveLabel.label),
                  ))
            ]));
  }
}
