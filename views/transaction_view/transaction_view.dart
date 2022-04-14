import 'package:com_goodtakes/model/base/receipt/receipt_base.dart';
import 'package:com_goodtakes/model/base/receipt/receipt_extension.dart';
import 'package:com_goodtakes/model/receipt/restro_receipt.dart';
import 'package:com_goodtakes/model/receipt/user_receipt.dart';
import 'package:com_goodtakes/static/content/standard_asset_image.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/views/my_restro_profile/restro_transaction_detail_view.dart';
import 'package:com_goodtakes/views/transaction_detail_view/transaction_detail_view.dart';
import 'package:com_goodtakes/widgets/display/transaction/my_transaction_chip.dart';
import 'package:com_goodtakes/widgets/display/transaction/restro_transaction_chip.dart';
import 'package:com_goodtakes/widgets/interaction/gt_tab_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionListView extends StatefulWidget {
  final List<ReceiptBase> receipts;
  final bool isRestro;

  const TransactionListView(
      {required this.receipts, this.isRestro = false, Key? key})
      : super(key: key);

  @override
  State<TransactionListView> createState() => _TransactionListViewState();
}

class _TransactionListViewState extends State<TransactionListView>
    with SingleTickerProviderStateMixin {
  late final completed = widget.receipts.where((element) {
    return element.status == ReceiptStatus.complete;
  });
  late final pending = widget.receipts.where((element) {
    // debugPrint("element.status : ${element.status}");
    return element.status != ReceiptStatus.complete;
  });
  Widget get emptyReplacement => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
                image: AssetImage(StandardAssetImage.emptyListReplacement)),
            const SizedBox(height: 10),
            Text(
                StandardInappContentType.generalEmptyListReplacementLabel.label,
                style: StandardTextStyle.grey18R)
          ]);

  late final TabController controller = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            alignment: Alignment.center,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    GTTabbarButton(
                      onTap: () {
                        controller.animateTo(0);
                        setState(() {});
                      },
                      label: StandardInappContentType
                          .orderViewOnProgressTitle.label,
                      onFocus: controller.index == 0,
                      badgeCount: pending.length,
                    ),
                    GTTabbarButton(
                        onTap: () {
                          controller.animateTo(1);
                          setState(() {});
                        },
                        onFocus: controller.index == 1,
                        badgeCount: 0,
                        label: StandardInappContentType
                            .orderViewCompletedTitle.label)
                  ]),
                  Expanded(
                      child: TabBarView(controller: controller, children: [
                    if (pending.isEmpty)
                      emptyReplacement
                    else
                      ListView.builder(
                          itemCount: pending.length,
                          padding: StandardSize.generalViewPadding,
                          itemBuilder: (context, index) {
                            final data = pending.elementAt(index);
                            return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        StandardSize.generalChipBorderRadius),
                                child: GestureDetector(
                                    onTap: () {
                                      if (widget.isRestro) {
                                        Navigator.of(context).push(
                                            CupertinoPageRoute(
                                                builder: (_) =>
                                                    RestroTransactionDetailView(
                                                        receipt: data
                                                            as RestroReceipt)));
                                      } else {
                                        Navigator.of(context).push(
                                            CupertinoPageRoute(
                                                builder: (_) =>
                                                    TransactionDetailView(
                                                        receiptId: data.id)));
                                      }
                                    },
                                    child: widget.isRestro
                                        ? RestroTransactionChip(
                                            receipt: data as RestroReceipt)
                                        : MyTransactionChip(
                                            receipt: data as UserReceipt)));
                          }),
                    if (completed.isEmpty)
                      emptyReplacement
                    else
                      ListView.builder(
                          itemCount: completed.length,
                          padding: StandardSize.generalViewPadding,
                          itemBuilder: (context, index) {
                            final data = completed.elementAt(index);
                            return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        StandardSize.generalChipBorderRadius),
                                child: GestureDetector(
                                    onTap: () {
                                      if (widget.isRestro) {
                                        Navigator.of(context).push(
                                            CupertinoPageRoute(
                                                builder: (_) =>
                                                    RestroTransactionDetailView(
                                                        receipt: data
                                                            as RestroReceipt)));
                                      } else {
                                        Navigator.of(context).push(
                                            CupertinoPageRoute(
                                                builder: (_) =>
                                                    TransactionDetailView(
                                                        receiptId: data.id)));
                                      }
                                    },
                                    child: widget.isRestro
                                        ? RestroTransactionChip(
                                            receipt: data as RestroReceipt)
                                        : MyTransactionChip(
                                            receipt: data as UserReceipt)));
                          })
                  ]))
                ])));
  }
}
