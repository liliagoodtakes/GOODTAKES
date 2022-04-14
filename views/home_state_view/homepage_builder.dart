import 'dart:async';

import 'package:badges/badges.dart';
import 'package:com_goodtakes/model/in_app_notification/in_app_notification.dart';
import 'package:com_goodtakes/model/receipt/restro_receipt.dart';
import 'package:com_goodtakes/model/receipt/user_receipt.dart';
import 'package:com_goodtakes/model/user/usr_profile.dart';
import 'package:com_goodtakes/service/database/database_r.dart';
import 'package:com_goodtakes/service/database/database_u.dart';
import 'package:com_goodtakes/service/location_service.dart';
import 'package:com_goodtakes/service/routing/paths.dart';
import 'package:com_goodtakes/service/runtime_properties.dart';
import 'package:com_goodtakes/states/authentication_state.dart';
import 'package:com_goodtakes/states/my_notification_state.dart';
import 'package:com_goodtakes/states/my_receipt_state.dart';
import 'package:com_goodtakes/states/my_restro_state.dart';
import 'package:com_goodtakes/static/content/standard_asset_image.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_button_style.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/views/index_view/index_view.dart';
import 'package:com_goodtakes/views/my_profile_view/my_profile_view.dart';
import 'package:com_goodtakes/views/notification_view/notification_view.dart';
import 'package:com_goodtakes/views/settings/setting_view.dart';
import 'package:com_goodtakes/views/transaction_view/transaction_view.dart';
import 'package:com_goodtakes/widgets/interaction/alert/full_page_loader.dart';
import 'package:com_goodtakes/widgets/interaction/alert/simple_alert_dialog.dart';
import 'package:com_goodtakes/widgets/interaction/alert/simple_loading.dart';
import 'package:com_goodtakes/widgets/interaction/appbar/bottom_navigator.dart';
import 'package:com_goodtakes/widgets/interaction/appbar/static_appbar.dart';
import 'package:com_goodtakes/widgets/interaction/gt_icon_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:states_rebuilder/scr/state_management/state_management.dart';
import 'package:uni_links/uni_links.dart';

class HomepageView extends StatelessWidget {
  const HomepageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Injector(
        inject: [
          Inject<RuntimeProperties>(() => RuntimeProperties()),
          Inject<MyNotificationState>(() => MyNotificationState()),
          Inject<MyReceiptState>(() => MyReceiptState()),
          Inject<MyRestroState>(() => MyRestroState())
        ],
        builder: (_) {
          return FutureBuilder<void>(
              future: Future.wait([
                RM.get<RuntimeProperties>().state.init(),
                RM.get<MyNotificationState>().state.init(),
                RM.get<MyNotificationState>().state.init(),
                RM.get<MyReceiptState>().state.init(),
                RM
                    .get<MyRestroState>()
                    .setState((s) async => await s.init())
                    .then((value) {
                  final model = RM.get<MyRestroState>();
                  if (model.state.myRestroMeta != null) {
                    myRestroNotificationStreamQuery(
                            restroId: model.state.restro!.id)
                        .onChildAdded
                        .listen((event) {
                      final newNoti = InAppNotification.build(
                          event.snapshot.value as Map, event.snapshot.key!);
                      model.setState((s) => s.notifications.add(newNoti));
                    });

                    myRestroReceiptStreamQuery(restroId: model.state.restro!.id)
                        .onChildAdded
                        .listen((event) {
                      final receipt = RestroReceipt.build(
                          event.snapshot.value as Map, event.snapshot.key!);
                      model.setState((s) => s.receipts.add(receipt));
                    });
                  }
                })
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Scaffold(body: GTFullPageLoader());
                }
                return OnBuilder(
                    listenToMany: [
                      RM.get<RuntimeProperties>(),
                      RM.get<MyNotificationState>(),
                      RM.get<MyReceiptState>(),
                      RM.get<MyRestroState>()
                    ],
                    builder: () {
                      return HomepageBuilder(builder: (
                          {required Widget bottomNavigator,
                          required int focus,
                          required PreferredSizeWidget appbar,
                          required Widget view}) {
                        return Scaffold(
                            backgroundColor: StandardColor.lightGrey,
                            extendBodyBehindAppBar: true,
                            appBar: appbar,
                            bottomNavigationBar: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15)),
                                    color: StandardColor.white,
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 2,
                                          offset: Offset(0, 0),
                                          color: Color.fromRGBO(0, 0, 0, 0.05))
                                    ]),
                                // margin: const EdgeInsets.only(top: 10),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: SafeArea(
                                    bottom: true,
                                    left: false,
                                    right: false,
                                    top: false,
                                    child: bottomNavigator)),
                            body: view);
                      });
                    });
              });
        });
  }
}

class HomepageBuilder extends StatefulWidget {
  final Widget Function(
      {required int focus,
      required Widget bottomNavigator,
      required PreferredSizeWidget appbar,
      required Widget view})? builder;
  final ValueSetter<int>? onFocusChange;
  final int initFocus;
  const HomepageBuilder({
    this.builder,
    this.initFocus = 0,
    this.onFocusChange,
    Key? key,
  }) : super(key: key);

  static _HomepageBuilderState? of(BuildContext context) {
    return context.findAncestorStateOfType<_HomepageBuilderState>();
  }

  @override
  _HomepageBuilderState createState() => _HomepageBuilderState();
}

class _HomepageBuilderState extends State<HomepageBuilder> {
  int focus = 0;

  // bool initLoading = true;

  Widget get bottomNavigator {
    return GTBottomNavigator(
        focus: focus,
        onTap: (int index) {
          if (focus != index) {
            focus = index;
            setState(() {});
          }
        });
  }

  PreferredSizeWidget get appbar {
    switch (focus) {
      case 0:
        return StaticAppBar(
            background: Colors.transparent,
            automaticApplyPlaceHolder: false,
            automaticInplementLeading: false,
            leading: GestureDetector(
                child: Row(children: [
              const SizedBox(width: 10),
              const ImageIcon(AssetImage(StandardAssetImage.iconLocation),
                  color: StandardColor.yellow),
              const SizedBox(width: 5),
              Text("紅磡", style: StandardTextStyle.black18R)
            ])),
            actions: [
              OnBuilder(
                  listenToMany: [
                    RM.get<MyNotificationState>(),
                    RM.get<AuthenticationState>()
                  ],
                  builder: () {
                    final model = RM.get<MyNotificationState>();
                    debugPrint("notification bell rebuild");
                    return Badge(
                        elevation: 0,
                        position: BadgePosition.topEnd(end: 10, top: 8),
                        showBadge: model.state.haveUnreadedNotification,
                        padding: const EdgeInsets.all(5),
                        badgeColor: StandardColor.yellow,
                        child: GTIconButton(
                            foregroundColor: Colors.grey,
                            iconSize: 25,
                            icon: const ImageIcon(AssetImage(
                                StandardAssetImage.iconNotifiBellDefault)),
                            onPressed: () async {
                              await Navigator.of(context).push(
                                  CupertinoPageRoute(
                                      builder: (_) =>
                                          const InAppNotificationView()));
                              updateMyNotificationReadMd();
                            }));
                  })
            ]);

      case 1:
        return StaticAppBar(
            automaticApplyPlaceHolder: false,
            automaticInplementLeading: false,
            title: StandardInappContentType.myReceiptAppbarTitle.label);
      case 2:
        return StaticAppBar(
            automaticApplyPlaceHolder: false,
            automaticInplementLeading: false,
            title: StandardInappContentType.profileAppbarTitle.label,
            actions: [
              GTIconButton(
                  iconSize: StandardSize.generalAppbarTrailingIconSize,
                  foregroundColor: StandardColor.yellow,
                  icon: const ImageIcon(
                      AssetImage(StandardAssetImage.iconSettings)),
                  onPressed: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (_) => const SettingsView()));
                  })
            ]);

      default:
        return StaticAppBar(title: "Hello World 1");
    }
  }

  Widget get view {
    switch (focus) {
      case 0:
        return const IndexView();
      case 1:
        return OnBuilder(
            listenTo: (RM.get<MyReceiptState>()),
            builder: () {
              final model = RM.get<MyReceiptState>();
              // debugPrint(
              //     "OnBuilder ::: TransactionListView ${model.state.completedTransaction.length} ::: ${model.state.onProcessTransaction.length}");
              return TransactionListView(receipts: model.state.receipt);
            });

      case 2:
        return const MyProfileView();
      default:
        return Container();
    }
  }

  // Future<void> initData() async {
  //   final position = await userPosition.onError(positionErrorHandler);
  //   // debugPrint("position ${position?.latitude} ::: ${position?.longitude}");
  //   if (position != null) {
  //     RM
  //         .get<RuntimeProperties>()
  //         .state
  //         .sortByDistant(LatLng(position.latitude, position.longitude));
  //   }

  //   _newRestro.addAll(await newRestro);
  //   // _allRestro.addAll(await restros(ids));
  //   _nearByRestro.addAll(await restros(
  //       RM.get<RuntimeProperties>().state.indexs.map((e) => e.placeId).toList(),
  //       limit: 10));
  //   initLoading = false;
  //   setState(() {});
  // }

  // Future<void> updateBasket(Basket basket) async {
  //   final newRIndex =
  //       _newRestro.indexWhere((element) => element.id == basket.restroId);
  //   final nearByRIndex =
  //       _nearByRestro.indexWhere((element) => element.id == basket.restroId);
  //   final allByRIndex =
  //       _allRestro.indexWhere((element) => element.id == basket.restroId);

  //   debugPrint("update basket at restro ::: ");
  //   if (nearByRIndex != -1) {
  //     _nearByRestro.elementAt(nearByRIndex).baskets.clear();
  //     _nearByRestro.elementAt(nearByRIndex).baskets.add(basket);
  //   }
  //   if (newRIndex != -1) {
  //     _newRestro.elementAt(newRIndex).baskets.clear();
  //     _newRestro.elementAt(newRIndex).baskets.add(basket);
  //   }
  //   if (allByRIndex != -1) {
  //     _allRestro.elementAt(allByRIndex).baskets.clear();
  //     _allRestro.elementAt(allByRIndex).baskets.add(basket);
  //   }
  //   setState(() {});
  // }

  // Future<void> refeashData() async {
  //   _newRestro.clear();
  //   _allRestro.clear();
  //   _nearByRestro.clear();

  //   _newRestro.addAll(await newRestro);
  //   // _allRestro.addAll(await restros(ids));
  //   _nearByRestro.addAll(await restros(
  //       RM.get<RuntimeProperties>().state.indexs.map((e) => e.placeId).toList(),
  //       limit: 10));
  //   initLoading = false;
  //   setState(() {});
  // }

  late final StreamSubscription<DatabaseEvent>? notificationMonitor;
  late final StreamSubscription<DatabaseEvent>? receiptMonitor;
  late final StreamSubscription<DatabaseEvent>? myProfileMonitor;

  Future<void> initPosition([bool? shouldRetry]) async {
    try {
      final position = await userPosition;
      if (position != null) {
        RM
            .get<RuntimeProperties>()
            .state
            .updateUserPosition(LatLng(position.latitude, position.longitude));
      }

      setState(() {});
    } catch (e) {
      debugPrint(
          "initPosition -> location -> $e is auto login ${RM.get<AuthenticationState>().state.isAutoLogin}");
      bool _shouldRetry = shouldRetry ?? false;
      if (!RM.get<AuthenticationState>().state.isAutoLogin ||
          _shouldRetry != false) {
        final permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          await showSimpleAlert(
              context: context,
              icon: const Image(
                  image: AssetImage(StandardAssetImage.popupLocator)),
              title: "開啟定位服務\n去搵你附近嘅食店",
              message: "設定 > 私隱 > 定位服務 > 開啟Goodtakes",
              actions: [
                ElevatedButton(
                    style: StandardButtonStyle.cancelButtonStyle,
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: Text("取消")),
                ElevatedButton(
                    style: StandardButtonStyle.regularYellowButtonStyle,
                    onPressed: () async {
                      _shouldRetry = await openAppSettings();
                    },
                    child: Text("設定")),
              ]);
        }
      }
      if (_shouldRetry) {
        initPosition(shouldRetry = false);
      } else {
        setState(() {});
      }
    }
  }

  void initRoute() {
    uriLinkStream.listen((uri) {
      if (uri != null) {
        final String link = "${uri.path}?${uri.query.isEmpty ? "" : uri.query}";
        // print("init route called $link");
        showSimpleAlert(
            context: context, icon: Container(), message: link, title: "LINK");
      }
    });
  }

  @override
  void initState() {
    super.initState();

    notificationMonitor = myNotificationStream?.listen((event) {
      final noti = InAppNotification.build(
          event.snapshot.value as Map, event.snapshot.key!);
      RM.get<MyNotificationState>().setState((s) {
        s.notifications.insert(0, noti);
        debugPrint(
            "noti : add and setstage alert, message count ${s.notifications.length}");
        return;
      });
    });

    receiptMonitor = myReceiptStream?.listen((event) {
      final receipt =
          UserReceipt.build(event.snapshot.value as Map, event.snapshot.key!);
      RM.get<MyReceiptState>().setState((s) {
        debugPrint("new receipt value : ${event.snapshot.value}");
        s.receipt.insert(0, receipt);
        debugPrint(
            "receipt : add and setstage alert, message count ${s.receipt.length}");
        return;
      });
    });

    myProfileMonitor = myProfileStream.listen((event) {
      debugPrint(
          "new profile value : ${event.snapshot.key}: ${event.snapshot.value}");
      RM.get<AuthenticationState>().setState((s) => s.updateProfile(event));
    });
    initPosition();
  }

  @override
  void dispose() {
    super.dispose();
    notificationMonitor?.cancel();
    receiptMonitor?.cancel();
    myProfileMonitor?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder!.call(
        focus: focus,
        bottomNavigator: bottomNavigator,
        view: view,
        appbar: appbar);
  }
}
