import 'package:com_goodtakes/model/base/meta_tag.dart';
import 'package:com_goodtakes/model/user/user_extension.dart';
import 'package:com_goodtakes/service/database/database_u.dart';
import 'package:com_goodtakes/service/image_hosting_service.dart';
import 'package:com_goodtakes/service/image_picking_service.dart';
import 'package:com_goodtakes/service/launcher_service.dart';
import 'package:com_goodtakes/service/routing/paths.dart';
import 'package:com_goodtakes/service/sharing_service.dart';
import 'package:com_goodtakes/states/authentication_state.dart';
import 'package:com_goodtakes/states/my_restro_state.dart';
import 'package:com_goodtakes/static/content/standard_asset_image.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/content/standard_interaction_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/views/my_profile_view/my_profile_editor_view.dart';
import 'package:com_goodtakes/views/my_restro_profile/restro_profile_view.dart';
import 'package:com_goodtakes/views/webview_launcher/webview_launcher.dart';
import 'package:com_goodtakes/widgets/display/double_layer_display_box.dart';
import 'package:com_goodtakes/widgets/display/double_layer_message_bill_board.dart';
import 'package:com_goodtakes/widgets/interaction/tapgable_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class MyProfileView extends StatelessWidget {
  const MyProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final topHeight = StandardSize.generalViewPadding.top +
    //     StandardSize.appbarHeightAfterSafeArea;
    return OnBuilder(
        listenTo: RM.get<AuthenticationState>(),
        builder: () {
          final model = RM.get<AuthenticationState>();
          final profile = model.state.profile!;
          final int creationMd = profile.meta[dbMetaCreation] as int;
          final int daysFromJoin = DateTime.now()
              .difference(DateTime.fromMillisecondsSinceEpoch(creationMd))
              .inDays;
          debugPrint("profile image: ${profile.profileImage}");
          return Stack(children: [
            Positioned(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Container(
                    decoration:
                        const BoxDecoration(color: StandardColor.white))),
            Positioned(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SafeArea(
                    child: Container(
                  margin: const EdgeInsets.only(top: 50),
                  decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15)),
                      color: StandardColor.lightGrey),
                ))),
            SafeArea(
                child: ListView(
                    padding: EdgeInsets.only(
                        top: StandardSize.generalViewPadding.top,
                        bottom: StandardSize.generalViewPadding.bottom),
                    children: [
                  Container(
                      margin: EdgeInsets.only(
                          left: StandardSize.generalViewPadding.left + 20,
                          right: StandardSize.generalViewPadding.right),
                      child: SizedBox(
                          height: 85,
                          child: Row(children: [
                            GestureDetector(
                                onTap: () async {
                                  final image = await localImage;
                                  if (image != null) {
                                    final String link = await hostImage(
                                        file: image,
                                        fileRef: FirebaseStorageFileLocation
                                            .profile);

                                    updateProfile(
                                        {UserDBKey.profileImage.dbKey: link});
                                  }
                                },
                                child: SizedBox(
                                    width: 85,
                                    child: profile.profileImage != null
                                        ? Container(
                                            clipBehavior: Clip.antiAlias,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle),
                                            child: Image(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    profile.profileImage!)),
                                          )
                                        : Image(
                                            fit: BoxFit.cover,
                                            image: AssetImage(profile.sex == 0
                                                ? StandardAssetImage
                                                    .femaleProfileProfileImageReplacement
                                                : StandardAssetImage
                                                    .maleProfileProfileImageReplacement)))),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                  Text(
                                    model.state.profile!.name,
                                    maxLines: 1,
                                    textWidthBasis: TextWidthBasis.longestLine,
                                    overflow: TextOverflow.ellipsis,
                                    style: StandardTextStyle.black18B,
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          border: Border.all(
                                            color: StandardColor.yellow,
                                          )),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 2),
                                      child: Text(
                                        daysFromJoin == 0
                                            ? StandardInappContentType
                                                .profileNewUserStatement.label
                                            : StandardInappContentType
                                                .profileJoinFromDaysStatement
                                                .label
                                                .replaceFirst(
                                                    valueReplacementTag,
                                                    daysFromJoin.toString()),
                                        style: StandardTextStyle.yellow14SB,
                                      ))
                                ]))
                          ]))),
                  const SizedBox(height: 40),
                  Column(children: [
                    SizedBox(
                        height: 130,
                        child: Row(children: [
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          StandardSize.generalViewPadding.left),
                                  child: DoubleLayerMessageBillBoard(
                                    message: StandardInappContentType
                                        .generalMoneySavedValue.label
                                        .replaceFirst(
                                            valueReplacementTag,
                                            RM
                                                .get<AuthenticationState>()
                                                .state
                                                .profile!
                                                .summary
                                                .moneySaved
                                                .toString()),
                                    title: StandardInappContentType
                                        .generalMoneySavedTitle.label,
                                    icon: const ImageIcon(AssetImage(
                                        StandardAssetImage.iconDollorCircle)),
                                  ))),
                          const SizedBox(width: 20),
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      right: StandardSize
                                          .generalViewPadding.right),
                                  child: DoubleLayerMessageBillBoard(
                                      message: StandardInappContentType
                                          .generalFoodSavedValue.label
                                          .replaceFirst(
                                              valueReplacementTag,
                                              RM
                                                  .get<AuthenticationState>()
                                                  .state
                                                  .profile!
                                                  .summary
                                                  .foodSaved
                                                  .toString()),
                                      title: StandardInappContentType
                                          .generalFoodSavedTitle.label,
                                      icon: const ImageIcon(AssetImage(
                                          StandardAssetImage
                                              .iconSpoonAndFork)))))
                        ])),
                    const SizedBox(height: 30),
                    SizedBox(
                        height: 140,
                        child: Row(children: [
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          StandardSize.generalViewPadding.left,
                                      bottom: 20),
                                  child: DoubleLayerMessageBillBoard(
                                      message: StandardInappContentType
                                          .generalCarbonReductionValue.label
                                          .replaceFirst(
                                              valueReplacementTag,
                                              RM
                                                  .get<AuthenticationState>()
                                                  .state
                                                  .profile!
                                                  .summary
                                                  .carbonEmissionReduction
                                                  .toString()),
                                      title: StandardInappContentType
                                          .generalCarbonReductionTitle.label,
                                      icon: const ImageIcon(AssetImage(
                                          StandardAssetImage.iconLeaf))))),
                          const SizedBox(width: 20),
                          Expanded(
                              child: GestureDetector(
                                  onTap: shareMyProfile,
                                  child: DoubleLayerDisplayBox(
                                      child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ImageIcon(
                                                  const AssetImage(
                                                      StandardAssetImage
                                                          .iconShare),
                                                  size: StandardTextStyle
                                                      .black16B.fontSize,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                    StandardInteractionTextType
                                                        .profileShareMyAchievementLabel
                                                        .label,
                                                    style: StandardTextStyle
                                                        .black16B
                                                        .copyWith(
                                                            height: 1.1,
                                                            letterSpacing: 0))
                                              ])))))
                        ]))
                  ]),
                  const SizedBox(height: 24),
                  Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4)),
                      padding: const EdgeInsets.all(12),
                      margin: StandardSize.generalViewPadding,
                      child: Column(children: [
                        TapableTile(
                            onTap: () {
                              Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (_) => ProfileEditorView()));
                            },
                            message: StandardInteractionTextType
                                .profilePersonalInfo.label,
                            prefix: const ImageIcon(
                                AssetImage(StandardAssetImage.iconProfile),
                                size: StandardSize.generalNavTileIconSize,
                                color: StandardColor.yellow)),
                        OnBuilder<MyRestroState>(
                            listenTo: RM.get<MyRestroState>(),
                            builder: () {
                              final model = RM.get<MyRestroState>();
                              if (model.state.myRestroMeta?.isEmpty ?? true) {
                                return TapableTile(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          CupertinoPageRoute(
                                              builder: (_) => WebViewLauncher(
                                                  title:
                                                      StandardInteractionTextType
                                                          .profileAddRestro
                                                          .label,
                                                  url: StandardInappContentType
                                                      .generalAddRestroURL
                                                      .label)));
                                    },
                                    message: StandardInteractionTextType
                                        .profileAddRestro.label,
                                    prefix: const ImageIcon(
                                        AssetImage(StandardAssetImage.iconShop),
                                        size:
                                            StandardSize.generalNavTileIconSize,
                                        color: StandardColor.yellow));
                              } else {
                                final badgeCount = RM
                                    .get<MyRestroState>()
                                    .state
                                    .uncompletedCount;
                                return TapableTile(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          CupertinoPageRoute(
                                              builder: (_) =>
                                                  const MyRestroProfileView()));
                                    },
                                    message: StandardInteractionTextType
                                        .profileMyRestro.label,
                                    messageStyle: badgeCount == 0
                                        ? null
                                        : StandardTextStyle.yellow14SB,
                                    countInBadge: badgeCount,
                                    prefix: const ImageIcon(
                                        AssetImage(StandardAssetImage.iconShop),
                                        size:
                                            StandardSize.generalNavTileIconSize,
                                        color: StandardColor.yellow));
                              }
                            }),
                        TapableTile(
                            onTap: () {
                              standardLauncher(LauncherType.email);
                            },
                            message: StandardInteractionTextType
                                .profileContactUs.label,
                            prefix: const ImageIcon(
                                AssetImage(StandardAssetImage.iconDirect),
                                size: StandardSize.generalNavTileIconSize,
                                color: StandardColor.yellow))
                      ]))
                ]))
          ]);
        });
  }
}
