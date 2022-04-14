import 'package:com_goodtakes/model/payment_method.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/views/payment_editor_view/payment_editor.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

enum PaymentType { visa, master }

class PaymentChip extends StatelessWidget {
  final PaymentMethod paymentMethod;
  final ValueSetter<PaymentMethod> onDelete;
  final ValueSetter<PaymentMethod> onDeleteComfirm;
  final double? elevation;
  final bool focus;
  final bool onEdit;
  const PaymentChip(
      {required this.onDelete,
      this.onEdit = false,
      this.focus = false,
      this.elevation = 0.0,
      required this.onDeleteComfirm,
      required this.paymentMethod,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: elevation,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: StandardSize.generalChipBorderRadius),
        child: Container(
          alignment: Alignment.center,
          height: 72,
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(width: StandardSize.generalChipBorderPadding.left),
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(paymentMethod.issuer.toUpperCase(),
                      style: StandardTextStyle.black14SB),
                  Text("**** ${paymentMethod.last4}",
                      style: StandardTextStyle.black14R)
                ])),
            Offstage(
                offstage: !onEdit,
                child: Container(
                    alignment: Alignment.center,
                    width: 65,
                    height: 72,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        GestureDetector(
                            onTap: () => onDelete.call(paymentMethod),
                            child: const SizedBox(
                                width: 65,
                                child: Icon(
                                  Icons.remove_circle,
                                  color: StandardColor.red,
                                ))),
                        AnimatedPositioned(
                            duration: const Duration(milliseconds: 150),
                            top: 0,
                            right: focus ? 0 : -65,
                            width: 65,
                            height: 72,
                            child: GestureDetector(
                                onTap: () =>
                                    onDeleteComfirm.call(paymentMethod),
                                child: Container(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: StandardColor.red,
                                    ),
                                    child: Text(
                                      "移除",
                                      style: StandardTextStyle.white14SB,
                                    )))),
                      ],
                    )))
          ]),
        ));
  }
}
