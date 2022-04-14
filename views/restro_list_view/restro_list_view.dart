import 'package:com_goodtakes/model/restro/restro.dart';
import 'package:com_goodtakes/service/convertor/datetime.dart';
import 'package:com_goodtakes/service/runtime_properties.dart';
import 'package:com_goodtakes/static/content/standard_asset_image.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_button_style.dart';
import 'package:com_goodtakes/widgets/display/empty_list_replacement.dart';
import 'package:com_goodtakes/widgets/display/restro/restro_list_chip.dart';
import 'package:com_goodtakes/widgets/display/widget_timer_select.dart';
import 'package:com_goodtakes/widgets/interaction/appbar/static_appbar.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

enum RestroListViewType { all, nearby, newest }

class RestroListView extends StatefulWidget {
  final RestroListViewType type;
  const RestroListView({required this.type, Key? key}) : super(key: key);

  @override
  _RestroListViewState createState() => _RestroListViewState();
}

class _RestroListViewState extends State<RestroListView> {
  TimeOfDay? starting;
  TimeOfDay? ending;
  bool showTimeSelector = false;

  get timeSlotActive => starting != null || ending != null;

  get appbarTitle {
    if (widget.type == RestroListViewType.all) {
      return StandardInappContentType.allRestroAppbarTitle.label;
    } else if (widget.type == RestroListViewType.nearby) {
      return StandardInappContentType.nearByRestroAppbarTitle.label;
    } else {
      return StandardInappContentType.latestRestroAppbarTitle.label;
    }
  }

  Iterable<Restro> get restros {
    final model = RM.get<RuntimeProperties>();
    late final List<Restro> source;

    if (widget.type == RestroListViewType.all) {
      source = model.state.restros;
    } else if (widget.type == RestroListViewType.nearby) {
      source = model.state.nearByRestro;
    } else {
      source = model.state.newestRestro;
    }
    if (starting != null || ending != null) {
      return source.where((element) {
        if (element.baskets.isEmpty) {
          return false;
        }
        final startCheck = starting == null
            ? null
            : element.baskets.first.pickupTime?.start
                    .isAfterTimeOfDay(starting!) ??
                false;
        final closeCheck = ending == null
            ? null
            : element.baskets.first.pickupTime?.end
                    .isBeforeTimeOfDay(ending!) ??
                false;
        // debugPrint(
        //     "id: ${element.id} .. $startCheck && closeCheck .. $closeCheck :: ${element.baskets.first.generalPickUpTimeRangeStatement}");
        if (startCheck != null && closeCheck != null) {
          if (element.baskets.first.pickupTime!.start
              .isAfterTimeOfDay(ending!)) {
            return false;
          } else if (element.baskets.first.pickupTime!.end
              .isBeforeTimeOfDay(starting!)) {
            return false;
          } else if (!startCheck && !closeCheck) {
            return true;
          } else {
            return startCheck || closeCheck;
          }
        } else {
          return ((startCheck ?? true) && (closeCheck ?? true));
        }
      });
    } else {
      return source;
    }
  }

  @override
  Widget build(BuildContext context) {
    final restros = this.restros;
    return RefreshIndicator(
        edgeOffset: StandardSize.refreshIndicatorEdgeOffset,
        onRefresh: () async {
          await RM.get<RuntimeProperties>().state.refreshRestro();
          RM.get<RuntimeProperties>().setState((s) => null);
          return;
        },
        child: Scaffold(
            appBar: StaticAppBar(
                leadingIcon: Icons.close,
                title: appbarTitle,
                actions: [
                  ElevatedButton(
                      style: timeSlotActive
                          ? StandardButtonStyle.pickupTimeSelectButtonStyle
                          : StandardButtonStyle.pickupTimeUnselectButtonStyle,
                      onPressed: () {
                        debugPrint("pickUptime Appbar Panel Called");
                        showTimeSelector = !showTimeSelector;
                        setState(() {});
                      },
                      child: const Text("選擇提取時間")),
                  const SizedBox(width: 10)
                ]),
            body: OnBuilder(
                listenTo: RM.get<RuntimeProperties>(),
                builder: () {
                  return Stack(fit: StackFit.expand, children: [
                    if (restros.isNotEmpty)
                      ListView.builder(
                          padding: StandardSize.generalViewPadding,
                          itemCount: restros.length,
                          itemBuilder: (context, index) {
                            final restro = restros.elementAt(index);
                            return Container(
                                child: RestroListChip(restro: restro),
                                margin: const EdgeInsets.only(bottom: 17));
                          })
                    else
                      const EmptyListReplacement(),
                    AnimatedPositioned(
                        duration: const Duration(milliseconds: 200),
                        top: showTimeSelector ? 0 : -200,
                        left: 0,
                        width: MediaQuery.of(context).size.width,
                        child: TimeSelector(
                          onComplete: ({ending, starting}) {
                            setState(() {
                              showTimeSelector = false;
                              this.starting = starting;
                              this.ending = ending;
                              // debugPrint(
                              //     "start at ${starting?.format(context)} , ending at start at ${ending?.format(context)}");
                            });
                          },
                          ending: ending,
                          starting: starting,
                        ))
                  ]);
                })));
  }
}
