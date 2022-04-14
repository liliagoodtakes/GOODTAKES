import 'package:com_goodtakes/model/restro/restro.dart';
import 'package:com_goodtakes/service/routing/paths.dart';
import 'package:com_goodtakes/service/runtime_properties.dart';
import 'package:com_goodtakes/static/content/place_sourc_mixin/all_restro_source.dart';
import 'package:com_goodtakes/static/content/standard_interaction_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/views/home_state_view/homepage_builder.dart';
import 'package:com_goodtakes/views/restro_list_view/restro_list_view.dart';
import 'package:com_goodtakes/widgets/display/header_image_ad.dart';
import 'package:com_goodtakes/widgets/display/decorated_title.dart';
import 'package:com_goodtakes/widgets/display/restro/restro_chip.dart';
import 'package:com_goodtakes/widgets/interaction/page_progress_indicator_builder.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class IndexView extends StatelessWidget {
  const IndexView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnBuilder(
        listenTo: RM.get<RuntimeProperties>(),
        builder: () {
          final model = RM.get<RuntimeProperties>();
          if (model.isWaiting) {
            return Container(
                alignment: Alignment.center,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [SizedBox(width: 50, height: 50)]));
          }

          final nearByRestros = model.state.nearByRestro;
          final newRestros = model.state.newestRestro;

          return RefreshIndicator(
              edgeOffset: StandardSize.refreshIndicatorEdgeOffset,
              onRefresh: () async {
                await RM.get<RuntimeProperties>().state.refreshRestro();
                RM.get<RuntimeProperties>().setState((s) => null);
                return;
              },
              child: CustomScrollView(shrinkWrap: false, slivers: [
                SliverToBoxAdapter(
                    child: SizedBox(
                        height: StandardSize.generalViewPadding.top +
                            StandardSize.appbarHeightAfterSafeArea +
                            20)),
                SliverToBoxAdapter(
                    child: SizedBox(
                        height: 169,
                        child: PageViewIndicator(
                            activeIndicatorColor: StandardColor.white,
                            duration: const Duration(milliseconds: 150),
                            viewportFraction: 0.6,
                            pageLength: model.state.headerAd.length,
                            builder: (context, indicator, contoller,
                                onPageChange, currentPage) {
                              return Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 52,
                                        color: StandardColor.yellow),
                                    Positioned(
                                        bottom: 30,
                                        left: -75,
                                        width:
                                            MediaQuery.of(context).size.width +
                                                75,
                                        height: 120,
                                        child: PageView(
                                            controller: contoller,
                                            onPageChanged: (int index) {
                                              onPageChange.call(index, false);
                                            },
                                            children: model
                                                .state.headerAd.entries
                                                .map((e) => HeaderImageAd(
                                                    title: e.value["title"],
                                                    image: e.value["image"],
                                                    target: e.value["target"]))
                                                .toList())),
                                    Positioned(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        bottom: 0,
                                        left: 20,
                                        child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: indicator))
                                  ]);
                            }))),
                SliverToBoxAdapter(
                    child:
                        SizedBox(height: StandardSize.generalViewPadding.top)),
                SliverToBoxAdapter(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Container(
                          margin: StandardSize.generalViewPadding,
                          child: Row(children: [
                            const Expanded(child: DecoratedTitle(title: "附近")),
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(PageTransition(
                                      child: const RestroListView(
                                          type: RestroListViewType.nearby),
                                      type: bottomSheetTransitionType));
                                },
                                child: Container(
                                    color: Colors.transparent,
                                    child: Text(
                                      StandardInteractionTextType
                                          .generalAllLabel.label,
                                      style: StandardTextStyle.yellow14U,
                                    )))
                          ])),
                      SizedBox(
                          height: 180,
                          child: ListView.builder(
                            itemBuilder: ((context, index) {
                              final restro = nearByRestros.elementAt(index);

                              return Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  child: RestroChip(restro: restro));
                            }),
                            itemCount: nearByRestros.length >= 20
                                ? 20
                                : nearByRestros.length,
                            padding: EdgeInsets.only(
                                left: StandardSize.generalViewPadding.left,
                                bottom: StandardSize.generalViewPadding.bottom),
                            scrollDirection: Axis.horizontal,
                          )),
                    ])),
                SliverToBoxAdapter(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Container(
                          margin: StandardSize.generalViewPadding,
                          child: Row(children: [
                            const Expanded(
                                child: DecoratedTitle(title: "最新食店")),
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(PageTransition(
                                      child: const RestroListView(
                                          type: RestroListViewType.newest),
                                      type: bottomSheetTransitionType));
                                },
                                child: Container(
                                    color: Colors.transparent,
                                    child: Text(
                                      StandardInteractionTextType
                                          .generalAllLabel.label,
                                      style: StandardTextStyle.yellow14U,
                                    )))
                          ])),
                      SizedBox(
                          height: 180,
                          child: ListView.builder(
                            itemBuilder: ((context, index) {
                              final restro = newRestros.elementAt(index);

                              return Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  child: RestroChip(restro: restro));
                            }),
                            itemCount: newRestros.length >= 20
                                ? 20
                                : newRestros.length,
                            padding: EdgeInsets.only(
                                left: StandardSize.generalViewPadding.left,
                                bottom: StandardSize.generalViewPadding.bottom),
                            scrollDirection: Axis.horizontal,
                          ))
                    ])),
                SliverToBoxAdapter(
                    child: Container(
                        margin: StandardSize.generalViewPadding,
                        child: Row(children: [
                          const Expanded(child: DecoratedTitle(title: "全部食店")),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(PageTransition(
                                    child: const RestroListView(
                                        type: RestroListViewType.newest),
                                    type: bottomSheetTransitionType));
                              },
                              child: Container(
                                  color: Colors.transparent,
                                  child: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: StandardSize
                                          .generalIconButtonIconSize,
                                      color: StandardColor.yellow)))
                        ])))
              ]));
        });
  }
}
