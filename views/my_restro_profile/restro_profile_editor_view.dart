import 'package:com_goodtakes/model/restro/restro.dart';
import 'package:com_goodtakes/service/launcher_service.dart';
import 'package:com_goodtakes/states/my_restro_state.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/content/standard_interaction_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/widgets/interaction/appbar/static_appbar.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class RestorProfileEditor extends StatelessWidget {
  const RestorProfileEditor({Key? key}) : super(key: key);

  Widget get inlineSeperator => const SizedBox(height: 20);

  @override
  Widget build(BuildContext context) {
    final Restro restro = RM.get<MyRestroState>().state.restro!;
    final decoration = InputDecoration(
        labelStyle: StandardTextStyle.grey10R,
        contentPadding: const EdgeInsets.only(bottom: 5),
        isDense: true,
        border: const UnderlineInputBorder(
            borderSide: BorderSide(color: StandardColor.grey)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: StandardColor.grey)));
    // labelText: StandardInteractionTextType
    //     .myRestroNameZHLabel.label)
    return Scaffold(
        appBar: StaticAppBar(
            title: StandardInteractionTextType.myRestroAppbarTitle.label,
            foregroundColor: StandardColor.white,
            background: StandardColor.green),
        body: SafeArea(
            child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.network(restro.image,
                  width: MediaQuery.of(context).size.width,
                  height: 220,
                  fit: BoxFit.cover),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.bottomCenter,
                // decoration: BoxDecoration(color: Colors.white),

                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.8),
                margin: StandardSize.generalViewPadding,
                child: ListView(shrinkWrap: true, children: [
                  Material(
                      color: StandardColor.white,
                      borderRadius: StandardSize.generalChipBorderRadius,
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                          padding: StandardSize.generalViewPadding,
                          child: Form(
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                TextFormField(
                                    readOnly: true,
                                    initialValue: restro.name,
                                    style: StandardTextStyle.grey14R,
                                    decoration: decoration.copyWith(
                                        labelText: StandardInteractionTextType
                                            .myRestroNameZHLabel.label)),
                                inlineSeperator,
                                TextFormField(
                                    readOnly: true,
                                    initialValue: (RM
                                            .get<MyRestroState>()
                                            .state
                                            .nameEN
                                            .isEmpty)
                                        ? "N/A"
                                        : RM.get<MyRestroState>().state.nameEN,
                                    style: StandardTextStyle.grey14R,
                                    decoration: decoration.copyWith(
                                        labelText: StandardInteractionTextType
                                            .myRestroNameENLabel.label)),
                                inlineSeperator,
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width: 80,
                                          child: TextFormField(
                                              readOnly: true,
                                              initialValue:
                                                  restro.displayDistrict,
                                              style: StandardTextStyle.grey14R,
                                              decoration: decoration.copyWith(
                                                  labelText:
                                                      StandardInteractionTextType
                                                          .myRestroAreaLabel
                                                          .label))),
                                      const SizedBox(width: 10),
                                      Expanded(
                                          child: Column(children: [
                                        TextFormField(
                                            readOnly: true,
                                            initialValue: restro.address,
                                            style: StandardTextStyle.grey14R,
                                            decoration: decoration.copyWith(
                                                labelText:
                                                    StandardInteractionTextType
                                                        .myRestroAddressZHLabel
                                                        .label)),
                                        inlineSeperator,
                                        TextFormField(
                                            readOnly: true,
                                            initialValue: RM
                                                    .get<MyRestroState>()
                                                    .state
                                                    .addressEN
                                                    .isEmpty
                                                ? "N/A"
                                                : RM
                                                    .get<MyRestroState>()
                                                    .state
                                                    .addressEN,
                                            style: StandardTextStyle.grey14R,
                                            decoration: decoration.copyWith(
                                                labelText:
                                                    StandardInteractionTextType
                                                        .myRestroAddressENLabel
                                                        .label))
                                      ]))
                                    ]),
                                inlineSeperator,
                                TextFormField(
                                    readOnly: true,
                                    initialValue: restro.displayTypes.join(","),
                                    style: StandardTextStyle.grey14R,
                                    decoration: decoration.copyWith(
                                        labelText: StandardInteractionTextType
                                            .myRestroTypeLabel.label)),
                                inlineSeperator,
                                TextFormField(
                                    readOnly: true,
                                    initialValue: restro.email,
                                    style: StandardTextStyle.grey14R,
                                    decoration: decoration.copyWith(
                                        labelText: StandardInteractionTextType
                                            .myRestroEmailLabel.label)),
                                inlineSeperator,
                                TextFormField(
                                    readOnly: true,
                                    initialValue: restro.phone,
                                    style: StandardTextStyle.grey14R,
                                    decoration: decoration.copyWith(
                                        labelText: StandardInteractionTextType
                                            .myRestroPhoneLabel.label)),
                                inlineSeperator,
                                TextFormField(
                                    readOnly: true,
                                    initialValue: restro.description,
                                    style: StandardTextStyle.grey14R,
                                    decoration: decoration.copyWith(
                                        labelText: StandardInteractionTextType
                                            .myRestroDescriptionZHLabel.label)),
                                inlineSeperator
                              ])))),
                  const SizedBox(height: 10),
                  GestureDetector(
                      onTap: () {
                        standardLauncher(LauncherType.email);
                      },
                      child: Container(
                        // height: 80,
                        alignment: Alignment.center,
                        decoration:
                            const BoxDecoration(color: Colors.transparent),
                        // padding: StandardSize.generalViewPadding,
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: StandardInappContentType
                                      .myRestroProfileEditorBottom.label,
                                  style: StandardTextStyle.yellow16R),
                              const TextSpan(text: "\n"),
                              TextSpan(
                                  text: StandardInappContentType
                                      .generalSupprtEmail.label,
                                  style: StandardTextStyle.yellow16U)
                            ])),
                      )),
                  const SizedBox(height: 10)
                ]))
          ],
        )));
  }
}
