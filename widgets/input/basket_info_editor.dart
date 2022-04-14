import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/content/standard_regex.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/content/standard_interaction_content.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/views/basket_editor_view/basket_editor_view.dart';
import 'package:com_goodtakes/widgets/input/text_form_field_sufix.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BasketInfoEditor extends StatelessWidget {
  final TextEditingController nameEditingController;
  final TextEditingController oriPriceEditingController;
  final TextEditingController promotePriceEditingController;
  final TextEditingController descriptionEditingController;
  final GlobalKey<FormState> formKey;
  final List<String> tags;
  final ImageProvider image;
  final VoidCallback? onTagSelect;
  final VoidCallback? onImageEdit;
  final bool locked;

  const BasketInfoEditor(
      {Key? key,
      required this.formKey,
      this.locked = false,
      required this.image,
      required this.tags,
      required this.descriptionEditingController,
      required this.nameEditingController,
      required this.oriPriceEditingController,
      required this.promotePriceEditingController,
      required this.onTagSelect,
      required this.onImageEdit})
      : super(key: key);

  SizedBox get verticalSeperator => const SizedBox(height: 5);
  SizedBox get horizontalSeperator => const SizedBox(width: 10);
  double get inputBoxHight => 100.0;

  String? oriPriceVaildator(String? value) {
    if (value == null || value.isEmpty) {
      debugPrint("oriPriceVaildator : value == null || value.isEmpty");
      return StandardInteractionTextType.generalInputEmptyAlert.label
          .replaceAll(valueReplacementTag,
              StandardInteractionTextType.basketEditorOriPrice.label);
    } else if (double.parse(value) < 30) {
      return StandardInteractionTextType.generalLowPriceAlert.label
          .replaceAll(valueReplacementTag, "30");
    } else {
      return null;
    }
  }

  String? promoPriceVaildator(String? value) {
    if (value == null || value.isEmpty) {
      return StandardInteractionTextType.generalInputEmptyAlert.label
          .replaceAll(valueReplacementTag,
              StandardInteractionTextType.basketEditorPromotePrice.label);
    } else if (double.parse(value) < 30) {
      return StandardInteractionTextType.generalLowPriceAlert.label
          .replaceAll(valueReplacementTag, "30");
    } else if (oriPriceEditingController.text.isEmpty) {
      return null;
    } else if (double.parse(value) >
        double.parse(oriPriceEditingController.text)) {
      return StandardInteractionTextType.generalRelativeLowPriceAlert.label;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    const border = UnderlineInputBorder(
      borderSide: BorderSide(color: StandardColor.closeToBlack),
    );

    // final descriptionScrollController = ScrollController();
    const InputDecoration decoration = InputDecoration();

    return Container(
        padding: StandardSize.generalChipBorderPadding,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Form(
            key: formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        margin: const EdgeInsets.only(right: 10),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(fit: StackFit.expand, children: [
                          Image(image: image, fit: BoxFit.cover),
                          Positioned(
                              top: 12,
                              left: 12,
                              width: 32,
                              height: 32,
                              child: Offstage(
                                  offstage: locked,
                                  child: Material(
                                      shape: const CircleBorder(),
                                      clipBehavior: Clip.antiAlias,
                                      child: IconButton(
                                          onPressed: onImageEdit,
                                          icon: const Icon(Icons.edit_outlined),
                                          color: StandardColor.yellow,
                                          iconSize: 20,
                                          padding: const EdgeInsets.all(0)))))
                        ])),
                    Expanded(
                        child: Column(children: [
                      /// Setter : 福袋名稱
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              StandardInteractionTextType
                                  .basketEditorName.label,
                              style: StandardTextStyle.grey10R,
                            ),
                            TextFormField(
                                onChanged: (value) {
                                  BasketEditorView.of(context)
                                      ?.onChangeCallback();
                                },
                                readOnly: locked,
                                validator: (value) {
                                  return ValidatorType.notEmpty.validator(
                                      value,
                                      StandardInteractionTextType
                                          .basketEditorName.label);
                                },
                                decoration: decoration.copyWith(
                                    // suffix: Offstage(
                                    //     offstage: locked,
                                    //     child: TextFormFieldSuffix(
                                    //         controller: nameEditingController))
                                    ),
                                controller: nameEditingController)
                          ]),
                      verticalSeperator,

                      /// Setter : 籤

                      Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: StandardColor.closeToBlack))),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    StandardInteractionTextType
                                        .basketEditorTag.label,
                                    style: StandardTextStyle.grey10R),
                                GestureDetector(
                                    onTap: onTagSelect,
                                    child: Row(children: [
                                      Expanded(
                                          child: Text(
                                        tags.join(","),
                                        style: StandardTextStyle.black14R,
                                      )),
                                      Icon(Icons.expand_more_rounded,
                                          color: locked
                                              ? StandardColor.grey
                                              : StandardColor.yellow)
                                    ]))
                              ])),
                      verticalSeperator,

                      /// Setter : 價錢
                      SizedBox(
                          // height: inputBoxHight,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text(
                                      StandardInteractionTextType
                                          .basketEditorOriPrice.label,
                                      style: StandardTextStyle.grey10R),
                                  TextFormField(
                                      onChanged: (value) {
                                        BasketEditorView.of(context)
                                            ?.onChangeCallback();
                                      },
                                      readOnly: locked,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.done,
                                      controller: oriPriceEditingController,
                                      autocorrect: false,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: oriPriceVaildator,
                                      decoration: decoration.copyWith(
                                          // suffix: Offstage(
                                          //     offstage: locked,
                                          //     child: TextFormFieldSuffix(
                                          //         controller:
                                          //             oriPriceEditingController)),
                                          errorMaxLines: 3,
                                          prefixText: "HK\$ "))
                                ])),
                            horizontalSeperator,
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        StandardInteractionTextType
                                            .basketEditorPromotePrice.label,
                                        style: StandardTextStyle.grey10R),
                                    TextFormField(
                                        onChanged: (value) {
                                          BasketEditorView.of(context)
                                              ?.onChangeCallback();
                                        },
                                        readOnly: locked,
                                        keyboardType: TextInputType.number,
                                        controller:
                                            promotePriceEditingController,
                                        autocorrect: false,
                                        textInputAction: TextInputAction.done,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: promoPriceVaildator,
                                        decoration: decoration.copyWith(
                                            // suffix: Offstage(
                                            //     offstage: locked,
                                            //     child: TextFormFieldSuffix(
                                            //         controller:
                                            //             promotePriceEditingController)),
                                            errorMaxLines: 3,
                                            prefixText: "HK\$ "))
                                  ]),
                            )
                          ]))
                    ]))
                  ]),
                  verticalSeperator,
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            StandardInteractionTextType
                                .basketEditorDescription.label,
                            style: StandardTextStyle.grey10R),
                        TextFormField(
                            readOnly: locked,
                            validator: ValidatorType.notEmpty.validator,
                            controller: descriptionEditingController,
                            maxLines: 4,
                            minLines: 4,
                            // maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            // scrollController: descriptionScrollController,
                            onChanged: (input) async {
                              BasketEditorView.of(context)?.onChangeCallback();
                              // debugPrint("e is empty == ${input.isEmpty}");

                              //   await Future.delayed(const Duration(milliseconds: 50));
                              //   final old =
                              //   if (descriptionScrollController
                              //           .position.maxScrollExtent >
                              //       0.0) {
                              //     descriptionEditingController.text = descriptionEditingController.;
                              //   } else {
                              //     oldText = input;
                              //   }
                            },
                            keyboardType: TextInputType.multiline,
                            decoration: decoration.copyWith(
                                // suffix: Offstage(
                                //     offstage: locked,
                                //     child: TextFormFieldSuffix(
                                //         controller: descriptionEditingController)),
                                hintText: StandardInteractionTextType
                                    .basketEditorDescriptionHelperText.label,
                                hintStyle: StandardTextStyle.grey14R))
                      ])
                ])));
  }
}
