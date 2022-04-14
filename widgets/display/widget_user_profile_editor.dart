import 'package:com_goodtakes/static/content/standard_interaction_content.dart';
import 'package:com_goodtakes/static/content/standard_regex.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserProfileEditor extends StatefulWidget {
  final TextEditingController? lastNameController;
  final TextEditingController? firstNameController;
  final TextEditingController? emailController;
  final GlobalKey<FormState>? formKey;
  final String phoneNumber;
  final double padding; //25px
  final int? sex;
  final bool showPhoneNumber;
  const UserProfileEditor(
      {this.lastNameController,
      this.firstNameController,
      this.showPhoneNumber = true,
      this.formKey,
      this.emailController,
      this.sex,
      required this.phoneNumber,
      required this.padding,
      Key? key})
      : super(key: key);

  @override
  UserProfileEditorState createState() => UserProfileEditorState();
}

class UserProfileEditorState extends State<UserProfileEditor> {
  late final TextEditingController firstNameController =
      widget.firstNameController ?? TextEditingController();
  late final TextEditingController lastNameController =
      widget.lastNameController ?? TextEditingController();
  late final TextEditingController emailController =
      widget.emailController ?? TextEditingController();
  late int sex = widget.sex ?? 0;

  late final GlobalKey<FormState> formKey =
      widget.formKey ?? GlobalKey<FormState>();

  bool get dataVailadate {
    return formKey.currentState!.validate();
  }

  Widget get onCheckBox => Container(
      width: 18,
      height: 18,
      margin: const EdgeInsets.only(right: 5),
      decoration: const BoxDecoration(
          shape: BoxShape.circle, color: StandardColor.yellow),
      alignment: Alignment.center,
      child: const Icon(Icons.circle, size: 8, color: StandardColor.white));
  Widget get onUnCheckBox => Container(
      width: 18,
      height: 18,
      margin: const EdgeInsets.only(right: 5),
      decoration: const BoxDecoration(
          shape: BoxShape.circle, color: StandardColor.yellow),
      alignment: Alignment.center,
      child: const Icon(Icons.circle, size: 16, color: StandardColor.white));

  @override
  void dispose() {
    lastNameController.dispose();
    firstNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(widget.padding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // color: StandardColor.darkGrey
        ),
        child: Form(
            key: formKey,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: TextFormField(
                          style: StandardTextStyle.black14R,
                          controller: lastNameController,
                          validator: (value) {
                            return ValidatorType.notEmpty.validator(
                                value,
                                StandardInteractionTextType
                                    .generalLastNameInputLabel.label);
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(StandardRegExp.nonDigits))
                          ],
                          decoration: InputDecoration(
                              isDense: true,
                              labelText: StandardInteractionTextType
                                  .generalLastNameInputLabel.label,
                              labelStyle: StandardTextStyle.grey14R,
                              floatingLabelStyle: StandardTextStyle.grey12R,
                              contentPadding: const EdgeInsets.only(bottom: 5)),
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Expanded(
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(StandardRegExp.nonDigits))
                          ],
                          controller: firstNameController,
                          style: StandardTextStyle.black14R,
                          validator: (value) {
                            return ValidatorType.notEmpty.validator(
                                value,
                                StandardInteractionTextType
                                    .generalFirstNameInputLabel.label);
                          },
                          decoration: InputDecoration(
                              isDense: true,
                              labelText: StandardInteractionTextType
                                  .generalFirstNameInputLabel.label,
                              labelStyle: StandardTextStyle.grey14R,
                              floatingLabelStyle: StandardTextStyle.grey12R,
                              contentPadding: const EdgeInsets.only(bottom: 5)),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    style: StandardTextStyle.black14R,
                    controller: emailController,
                    autovalidateMode: AutovalidateMode.disabled,
                    validator: (value) {
                      return ValidatorType.email.validator(value);
                    },
                    decoration: InputDecoration(
                        isDense: true,
                        labelText: StandardInteractionTextType
                            .generalEmailInputLabel.label,
                        labelStyle: StandardTextStyle.grey14R,
                        floatingLabelStyle: StandardTextStyle.grey12R,
                        contentPadding: const EdgeInsets.only(bottom: 5)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (widget.showPhoneNumber)
                    Column(mainAxisSize: MainAxisSize.min, children: [
                      TextFormField(
                        initialValue: widget.phoneNumber,
                        readOnly: true,
                        style: StandardTextStyle.grey14R,
                        decoration: InputDecoration(
                            prefixText: "+852 ",
                            isDense: true,
                            labelText: StandardInteractionTextType
                                .generalPhoneInputLabel.label,
                            labelStyle: StandardTextStyle.grey14R,
                            floatingLabelStyle: StandardTextStyle.grey12R,
                            contentPadding: const EdgeInsets.only(bottom: 5)),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ]),
                  SizedBox(
                      height: 50,
                      child: Row(children: [
                        Expanded(
                            child: Text(
                          StandardInteractionTextType
                              .generalSexInputLabel.label,
                          style: StandardTextStyle.black14R,
                        )),
                        GestureDetector(
                            onTap: () {
                              sex = 0;
                              setState(() {});
                            },
                            child: Row(children: [
                              sex == 0 ? onCheckBox : onUnCheckBox,
                              Text(StandardInteractionTextType
                                  .generalSexInputChoiceF.label),
                            ])),
                        const SizedBox(width: 20),
                        GestureDetector(
                            onTap: () {
                              sex = 1;
                              setState(() {});
                            },
                            child: Row(children: [
                              sex == 1 ? onCheckBox : onUnCheckBox,
                              Text(StandardInteractionTextType
                                  .generalSexInputChoiceM.label),
                            ])),
                      ]))
                ])));
  }
}
