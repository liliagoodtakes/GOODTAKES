import 'package:com_goodtakes/model/base/meta_tag.dart';
import 'package:com_goodtakes/model/basket/basket.dart';
import 'package:com_goodtakes/model/basket/basket_extension.dart';
import 'package:com_goodtakes/model/config_model/config_mode.dart';
import 'package:com_goodtakes/service/convertor/datetime.dart';
import 'package:com_goodtakes/service/database/database_u.dart';
import 'package:com_goodtakes/service/image_hosting_service.dart';
import 'package:com_goodtakes/service/image_picking_service.dart';
import 'package:com_goodtakes/service/runtime_properties.dart';
import 'package:com_goodtakes/states/my_restro_state.dart';
import 'package:com_goodtakes/static/content/standard_asset_image.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_button_style.dart';
import 'package:com_goodtakes/static/content/standard_interaction_content.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/widgets/display/basket/basket_edit_alert_statement.dart';
import 'package:com_goodtakes/widgets/display/gt_chip.dart';
import 'package:com_goodtakes/widgets/input/basket_info_editor.dart';
import 'package:com_goodtakes/widgets/interaction/alert/simple_alert_dialog.dart';
import 'package:com_goodtakes/widgets/interaction/appbar/notifiable_appbar.dart';
import 'package:com_goodtakes/widgets/interaction/tag_selector.dart';
import 'package:com_goodtakes/widgets/interaction/time_range_picker/time_range_24h_picker.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'dart:io' as io;

class BasketEditorView extends StatefulWidget {
  final Basket? basket;
  const BasketEditorView({this.basket, Key? key}) : super(key: key);

  @override
  _BasketEditorViewState createState() => _BasketEditorViewState();

  static _BasketEditorViewState? of(BuildContext context) {
    return context.findAncestorStateOfType<_BasketEditorViewState>();
  }
}

class _BasketEditorViewState extends State<BasketEditorView> {
  late Basket? basket = widget.basket;
  final GlobalKey<NotifiableAppbarState> appbar = GlobalKey();
  late final TextEditingController nameController =
      TextEditingController(text: widget.basket?.name);
  late final TextEditingController descriptionController =
      TextEditingController(text: widget.basket?.description);
  late final TextEditingController promoPriceController = TextEditingController(
      text: widget.basket?.promotionPrice.ceil().toString());
  late final TextEditingController oriPriceController = TextEditingController(
      text: widget.basket?.originalPrice.ceil().toString());
  late DateTime availablePickupTime = widget.basket?.pickupTime?.start ??
      DateTime.now().add(const Duration(hours: 2));
  late DateTime close = widget.basket?.pickupTime?.end ??
      availablePickupTime.add(const Duration(hours: 1));
  late int stock = widget.basket?.stock ?? 1;

  late Set<ConfigModel> tags = widget.basket == null
      ? {}
      : RM.get<RuntimeProperties>().state.tagsAtIds(widget.basket!.tags);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void ensureEmptyFocus() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  /// image
  io.File? cacheImage;
  late String? image = widget.basket?.image;

  Future<Map<String, dynamic>> newBasketBuilder([bool listing = false]) async {
    final Map<String, dynamic> structuredBasket = {};
    late final String? imageUrl;
    if (cacheImage != null) {
      imageUrl = await hostImage(
          file: cacheImage!, fileRef: FirebaseStorageFileLocation.basket);
    } else {
      imageUrl = image;
    }
    final md = DateTime.now().millisecondsSinceEpoch;
    structuredBasket[BasketDBKey.name.dbKey] = {"zh": nameController.text};
    structuredBasket[BasketDBKey.description.dbKey] = {
      "zh": descriptionController.text
    };
    structuredBasket[BasketDBKey.originalPrice.dbKey] =
        double.parse(oriPriceController.text);
    structuredBasket[BasketDBKey.promotionPrice.dbKey] =
        double.parse(promoPriceController.text);
    structuredBasket[BasketDBKey.pickupTime.dbKey] = {
      "start": availablePickupTime.millisecondsSinceEpoch,
      "close": close.millisecondsSinceEpoch
    };
    structuredBasket[BasketDBKey.stock.dbKey] = stock;
    structuredBasket[BasketDBKey.status.dbKey] =
        listing ? BasketStatus.available.name : BasketStatus.disable.name;
    structuredBasket[BasketDBKey.tag.dbKey] =
        Map<String, bool>.fromEntries(tags.map((e) => MapEntry(e.id, true)));
    structuredBasket[BasketDBKey.image.dbKey] = imageUrl;
    structuredBasket["meta"] = {
      dbMetaCreation: basket?.meta[dbMetaCreation] ?? md,
      dbMetaModify: md,
      dbMetaLockedItem: 0,
      dbMetaInPaymentProgress: 0,
      dbMetaSessionLock: 0,
    };
    return structuredBasket;
  }

  void onChangeCallback() {
    final checker = _conditionChecker;
    if (checker != conditionChecker) {
      conditionChecker = checker;
      setState(() {});
      // debugPrint("ON CHANGE CALLBACK");
    }
  }

  late bool conditionChecker = _conditionChecker;
  bool get _conditionChecker {
    final bool imageNull = cacheImage != null || image != null;
    final bool availableTimeNull = availablePickupTime != null && close != null;
    final bool inputDataNotNull = nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        oriPriceController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        promoPriceController.text.isNotEmpty;
    final bool dataVaild = formKey.currentState?.validate() ?? false;
    return imageNull && availableTimeNull && inputDataNotNull && dataVaild;
  }

  Future<void> onSave([bool listing = false]) async {
    if (formKey.currentState!.validate()) {
      final newBasket = await updateBasket(
          basket: await newBasketBuilder(listing),
          restroId: RM.get<MyRestroState>().state.restro!.id,
          basketId: basket?.id);
      basket = newBasket;
      RM.get<MyRestroState>().setState((s) => s.updateBasket(newBasket));
      if (listing) {
        appbar.currentState?.sendNotification(
            message: StandardInteractionTextType
                .basketEditorAppbarOnListMessage.label,
            icon: Icons.check_circle_outline);
      } else {
        appbar.currentState?.sendNotification(
            message: StandardInteractionTextType
                .basketEditorAppbarOnSaveMessage.label,
            icon: Icons.check_circle_outline);
      }

      setState(() {});
    }
  }

  Future<void> unlist() async {
    debugPrint("unlist basket!");
    await unListBasket(restroId: basket!.restroId, basketId: basket!.id);
    basket = Basket.build(
        (await newBasketBuilder(false)), basket!.id, basket!.restroId);
    RM.get<MyRestroState>().setState((s) => s.updateBasket(basket!));
    appbar.currentState?.sendNotification(
        message:
            StandardInteractionTextType.basketEditorAppbarOnUnlistMessage.label,
        icon: Icons.check_circle_outline,
        onMessageBackgroundColor: StandardColor.red);
    setState(() {});
  }

  Widget get lockedBusketBody {
    return Column(children: [
      Expanded(
          child: ListView(padding: StandardSize.generalViewPadding, children: [
        BasketInfoEditor(
            formKey: formKey,
            locked: true,
            onImageEdit: null,
            onTagSelect: null,
            oriPriceEditingController: oriPriceController,
            promotePriceEditingController: promoPriceController,
            tags: tags.map((e) => e.displayName).toList(),
            nameEditingController: nameController,
            descriptionEditingController: descriptionController,
            image: NetworkImage(basket!.image)),
        const SizedBox(height: 20),
        Container(
            padding: StandardSize.generalChipBorderPadding,
            decoration: const BoxDecoration(
                color: StandardColor.white,
                borderRadius: StandardSize.generalChipBorderRadius),
            child: Column(children: [
              Row(children: [
                Expanded(
                    child: Text(
                        StandardInteractionTextType
                            .basketEditorNumberOfBasketLabel.label,
                        style: StandardTextStyle.black14R)),
                Container(
                    height: 37.5,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: StandardColor.lightGrey),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: StandardButtonStyle.countButtonStyle,
                              onPressed: null,
                              child: const Icon(Icons.remove, size: 16)),
                          const SizedBox(width: 15),
                          Container(
                              width: 26,
                              alignment: Alignment.center,
                              child: Text(stock.toString(),
                                  style: StandardTextStyle.black18B)),
                          const SizedBox(width: 15),
                          ElevatedButton(
                              style: StandardButtonStyle.countButtonStyle,
                              onPressed: null,
                              child: const Icon(
                                Icons.add,
                                size: 16,
                              ))
                        ]))
              ]),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(
                    child: Text(
                        StandardInteractionTextType
                            .basketEditorPickUpTimeLabel.label,
                        style: StandardTextStyle.black14R)),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                      StandardInteractionTextType
                          .basketEditorPickUpTimeSelectorStatement.label
                          .split(valueReplacementTag)
                          .first,
                      style: StandardTextStyle.grey14R),
                  const SizedBox(width: 5),
                  GTChip(
                      message: TimeOfDay.fromDateTime(availablePickupTime)
                          .formatAsTwoDigit(),
                      textStyle: StandardTextStyle.yellow14R,
                      backgroundColor: StandardColor.lightGrey,
                      foregroundColor: StandardColor.yellow),
                  const SizedBox(width: 5),
                  Text(
                      StandardInteractionTextType
                          .basketEditorPickUpTimeSelectorStatement.label
                          .split(valueReplacementTag)[1],
                      style: StandardTextStyle.grey14R),
                  const SizedBox(width: 5),
                  GTChip(
                      message: TimeOfDay.fromDateTime(close).formatAsTwoDigit(),
                      textStyle: StandardTextStyle.yellow14R,
                      backgroundColor: StandardColor.lightGrey,
                      foregroundColor: StandardColor.yellow)
                ]),
              ]),
              const SizedBox(height: 20),
              const BasketEditorAlertStatement()
            ]))
      ])),
      Padding(
          padding: StandardSize.generalViewPadding,
          child: ElevatedButton(
              style: StandardButtonStyle.regularRedButtonStyle,
              onPressed: () async {
                final bool? alertResult = await showSimpleAlert<bool>(
                    context: context,
                    actions: [
                      ElevatedButton(
                          style: StandardButtonStyle.cancelButtonStyle,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(StandardInteractionTextType
                              .generalButtonCancelLabel.label)),
                      ElevatedButton(
                          style: StandardButtonStyle.confirmButtonStyle,
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Text(StandardInteractionTextType
                              .basketEditorUnlist.label))
                    ],
                    icon: const Image(
                        image: AssetImage(StandardAssetImage.popupWarning)),
                    message: StandardInteractionTextType
                        .basketEditorUnlistAlertStatement.label,
                    title: StandardInteractionTextType
                        .basketEditorUnlistAlertTitle.label);

                if (alertResult == true) {
                  unlist();
                }
              },
              child: Container(
                  alignment: Alignment.center,
                  child: Text(
                      StandardInteractionTextType.basketEditorUnlist.label))))
    ]);
  }

  Widget get activeBasketEditorView {
    return Column(children: [
      Expanded(
          child: ListView(padding: StandardSize.generalViewPadding, children: [
        BasketInfoEditor(
            formKey: formKey,
            onImageEdit: () async {
              io.File? image = await localImage;
              if (image != null) {
                cacheImage = image;
                setState(() {});
              }
            },
            onTagSelect: () async {
              ensureEmptyFocus();
              scf.currentState?.showBottomSheet((context) => TagBottomSelector(
                    appbar: appbar,
                    datas: RM.get<RuntimeProperties>().state.tags,
                    initialVales: tags,
                    onComplete: (value) {
                      // debugPrint(value.map((e) => e.id).join(","));
                      tags = value;
                      setState(() {});
                    },
                  ));
            },
            oriPriceEditingController: oriPriceController,
            promotePriceEditingController: promoPriceController,
            tags: tags.map((e) => e.displayName).toList(),
            nameEditingController: nameController,
            descriptionEditingController: descriptionController,
            image: cacheImage != null
                ? FileImage(cacheImage!)
                : ((widget.basket == null
                    ? const AssetImage(StandardAssetImage.emptyBoxReplacement)
                        as ImageProvider
                    : NetworkImage(widget.basket!.image)))),
        const SizedBox(height: 20),
        Container(
            padding: StandardSize.generalChipBorderPadding,
            decoration: const BoxDecoration(
                color: StandardColor.white,
                borderRadius: StandardSize.generalChipBorderRadius),
            child: Column(children: [
              Row(children: [
                Expanded(
                    child: Text(
                        StandardInteractionTextType
                            .basketEditorNumberOfBasketLabel.label,
                        style: StandardTextStyle.black14R)),
                Container(
                    height: 37.5,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: StandardColor.lightGrey),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: StandardButtonStyle.countButtonStyle,
                              onPressed: () {
                                if (stock > 1) {
                                  stock -= 1;
                                  setState(() {});
                                }
                              },
                              child: const Icon(Icons.remove, size: 16)),
                          const SizedBox(width: 15),
                          Container(
                              width: 26,
                              alignment: Alignment.center,
                              child: Text(stock.toString(),
                                  style: StandardTextStyle.black18B)),
                          const SizedBox(width: 15),
                          ElevatedButton(
                              style: StandardButtonStyle.countButtonStyle,
                              onPressed: () {
                                stock += 1;
                                setState(() {});
                              },
                              child: const Icon(
                                Icons.add,
                                size: 16,
                              ))
                        ]))
              ]),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(
                    child: Text(
                        StandardInteractionTextType
                            .basketEditorPickUpTimeLabel.label,
                        style: StandardTextStyle.black14R)),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                      StandardInteractionTextType
                          .basketEditorPickUpTimeSelectorStatement.label
                          .split(valueReplacementTag)
                          .first,
                      style: StandardTextStyle.grey14R),
                  const SizedBox(width: 5),
                  GTChip(
                      onTap: () async {
                        ensureEmptyFocus();
                        final dt = await showLinerTimePicker(
                            context,
                            StandardInteractionTextType
                                .basketEditorPickUpTimeStartingLabel.label,
                            manuallyRemove: [24],
                            deltaInHour: 1,
                            manuallyRejectInterval: [23]);
                        if (dt != null) {
                          availablePickupTime = dt.toDateTime();
                          close =
                              availablePickupTime.add(const Duration(hours: 1));
                          setState(() {});
                        }
                      },
                      message: TimeOfDay.fromDateTime(availablePickupTime)
                          .formatAsTwoDigit(),
                      textStyle: StandardTextStyle.yellow14R,
                      backgroundColor: StandardColor.lightGrey,
                      foregroundColor: StandardColor.yellow),
                  const SizedBox(width: 5),
                  Text(
                      StandardInteractionTextType
                          .basketEditorPickUpTimeSelectorStatement.label
                          .split(valueReplacementTag)[1],
                      style: StandardTextStyle.grey14R),
                  const SizedBox(width: 5),
                  GTChip(
                      onTap: () async {
                        ensureEmptyFocus();

                        if (availablePickupTime.hour < 23) {
                          final dt = await showLinerTimePicker(
                              context,
                              StandardInteractionTextType
                                  .basketEditorPickUpTimeClosingLabel.label,
                              anchorDT: TimeOfDay.fromDateTime(
                                availablePickupTime,
                              ),
                              manuallyRejectInterval: [24],
                              deltaInHour: 1);
                          if (dt != null) {
                            close = dt.toDateTime();
                            setState(() {});
                          }
                        }
                      },
                      message: TimeOfDay.fromDateTime(close).formatAsTwoDigit(),
                      textStyle: StandardTextStyle.yellow14R,
                      backgroundColor: StandardColor.lightGrey,
                      foregroundColor: StandardColor.yellow)
                ]),
              ]),
              const SizedBox(height: 20),
              const BasketEditorAlertStatement()
            ]))
      ])),
      Padding(
          padding: StandardSize.generalViewPadding,
          child: Column(children: [
            ElevatedButton(
                style: StandardButtonStyle.regularYellowButtonStyle,
                onPressed: _conditionChecker
                    ? () async {
                        final bool? alertResult = await showSimpleAlert<bool>(
                            context: context,
                            actions: [
                              ElevatedButton(
                                  style: StandardButtonStyle.cancelButtonStyle,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(StandardInteractionTextType
                                      .generalButtonCancelLabel.label)),
                              ElevatedButton(
                                  style: StandardButtonStyle.confirmButtonStyle,
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text(StandardInteractionTextType
                                      .basketEditorList.label))
                            ],
                            icon: const Image(
                                image: AssetImage(
                                    StandardAssetImage.popupWarning)),
                            message: StandardInteractionTextType
                                .basketEditorListingAlertStatement.label,
                            title: StandardInteractionTextType
                                .basketEditorListingAlertTitle.label);

                        if (alertResult == true) {
                          onSave(true);
                        } else {
                          onSave(false);
                        }
                      }
                    : null,
                child: Container(
                    alignment: Alignment.center,
                    child: Text(
                        StandardInteractionTextType.basketEditorList.label))),
            const SizedBox(height: 12),
            ElevatedButton(
                style: StandardButtonStyle.regularGreenButtonStyle,
                onPressed: onSave,
                child: Container(
                    alignment: Alignment.center,
                    child: Text(
                        StandardInteractionTextType.basketEditorSave.label)))
          ]))
    ]);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    promoPriceController.dispose();
    oriPriceController.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> scf = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: scf,
        appBar: PreferredSize(
            child: NotifiableAppbar(
                onMessageBackgroundColor: StandardColor.yellow,
                key: appbar,
                title: StandardInappContentType
                    .restroDetailAvailableBasketAtDayTitle.label),
            preferredSize:
                const Size.fromHeight(StandardSize.appbarHeightAfterSafeArea)),
        body: SafeArea(
            child: GestureDetector(
                onVerticalDragStart: (drag) {
                  debugPrint("darg start");
                },
                onTap: () {
                  ensureEmptyFocus();
                },
                child: basket?.status == BasketStatus.available
                    ? lockedBusketBody
                    : activeBasketEditorView)));
  }
}
