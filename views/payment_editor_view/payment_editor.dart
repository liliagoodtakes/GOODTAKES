import 'package:com_goodtakes/model/payment_method.dart';
import 'package:com_goodtakes/service/payment_service.dart';
import 'package:com_goodtakes/service/routing/paths.dart';
import 'package:com_goodtakes/states/authentication_state.dart';
import 'package:com_goodtakes/static/content/standard_asset_image.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/content/standard_interaction_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/views/payment_editor_view/payment_creator_view.dart';
import 'package:com_goodtakes/widgets/display/payment_chip.dart';
import 'package:com_goodtakes/widgets/interaction/appbar/static_appbar.dart';
import 'package:com_goodtakes/widgets/interaction/tapgable_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class PaymentEditorView extends StatefulWidget {
  const PaymentEditorView({Key? key}) : super(key: key);

  @override
  State<PaymentEditorView> createState() => _PaymentEditorViewState();
}

class _PaymentEditorViewState extends State<PaymentEditorView> {
  final GlobalKey<FormState> fromKey = GlobalKey();
  PaymentMethod? focus;
  bool onEdit = false;

  void setFocus(PaymentMethod card) {
    focus = card;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return OnBuilder(
        listenTo: RM.get<AuthenticationState>(),
        builder: () {
          final model = RM.get<AuthenticationState>();
          final paymentMethods = model.state.profile!.paymentMethods;
          debugPrint(
              "model.state.profile!.paymentMethods length: ${model.state.profile!.paymentMethods.length}");
          return Scaffold(
              appBar: StaticAppBar(
                  actions: [
                    GestureDetector(
                        onTap: () {
                          onEdit = !onEdit;
                          setState(() {});
                        },
                        child: Container(
                            color: Colors.transparent,
                            margin: const EdgeInsets.only(right: 10),
                            child: Text(
                                onEdit
                                    ? StandardInteractionTextType
                                        .generalCompleteLabel.label
                                    : StandardInteractionTextType
                                        .generalEditLabel.label,
                                style: StandardTextStyle.black14U)))
                  ],
                  title:
                      StandardInappContentType.generalPaymentMethodTitle.label),
              body: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: paymentMethods.length + 1,
                  itemBuilder: (_, int index) {
                    if (index == paymentMethods.length) {
                      return Container(
                          margin: const EdgeInsets.only(bottom: 13),
                          child: TapableTile(
                              decoration: const BoxDecoration(
                                  color: StandardColor.white,
                                  borderRadius:
                                      StandardSize.generalChipBorderRadius),
                              constraints: const BoxConstraints(maxHeight: 72),
                              suffix: const ImageIcon(
                                  AssetImage(StandardAssetImage.iconRight),
                                  size: StandardSize.generalNavTileIconSize,
                                  color: StandardColor.yellow),
                              message: StandardInteractionTextType
                                  .addNewCreditCardStatement.label,
                              onTap: () {
                                Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (_) =>
                                        const PaymentMethodCreatorView()));
                              }));
                    } else {
                      final method = paymentMethods.elementAt(index);
                      return Container(
                          margin: const EdgeInsets.only(bottom: 13),
                          child: PaymentChip(
                              onEdit: onEdit,
                              focus: focus == method,
                              paymentMethod: paymentMethods.elementAt(index),
                              onDelete: (PaymentMethod paymentMethod) {
                                focus = paymentMethod;
                                setState(() {});
                              },
                              onDeleteComfirm: (PaymentMethod paymentMethod) {
                                deletePaymentMethod(paymentMethod);
                                RM.get<AuthenticationState>().setState((s) => s
                                    .profile!.paymentMethods
                                    .remove(paymentMethod));
                              }));
                    }
                  }));
        });
  }
}
