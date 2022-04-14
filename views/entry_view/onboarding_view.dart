import 'package:com_goodtakes/service/preference_service.dart';
import 'package:com_goodtakes/service/routing/paths.dart';
import 'package:com_goodtakes/static/content/standard_asset_image.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/content/standard_interaction_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_button_style.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/views/authentication_view/phone_input_view.dart';
import 'package:com_goodtakes/widgets/display/message_display_with_background_image.dart';
import 'package:com_goodtakes/widgets/interaction/page_progress_indicator_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class EntryView extends StatelessWidget {
  final int initPage;
  const EntryView({Key? key, this.initPage = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final smallDeviceAlert = MediaQuery.of(context).size.height <
        StandardSize.smallDeviceSizeCelling;
    return PageViewIndicator(
        initIndex: initPage,
        duration: const Duration(milliseconds: 250),
        pageLength: 3,
        builder: (BuildContext context,
            Widget indicator,
            PageController controller,
            void Function(int page, bool manuallySetPage) onPageChange,
            int currentFocus) {
          return Scaffold(
              appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  actions: [
                    Container(
                        margin: const EdgeInsets.only(right: 12),
                        alignment: Alignment.center,
                        child: Offstage(
                            offstage: currentFocus == 2,
                            child: GestureDetector(
                                onTap: () {
                                  onPageChange(2, true);
                                },
                                child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.transparent),
                                    alignment: Alignment.center,
                                    child: Text(
                                        StandardInteractionTextType
                                            .generalButtonSkipLabel.label,
                                        style:
                                            StandardTextStyle.darkGrey16U)))))
                  ]),
              extendBodyBehindAppBar: true,
              body: Stack(children: [
                Positioned(
                    top: 12,
                    left: 0,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: PageView(
                        physics: const PageScrollPhysics(),
                        controller: controller,
                        onPageChanged: (page) {
                          if (page == 2) {
                            PreferenceType.isFirstLaunch.updateBoolean(false);
                          }
                          onPageChange(page, false);
                        },
                        children: [
                          MessageDisplayWithBackgroundImage(
                              messageAlignment: const Alignment(-1, -0.65),
                              title: StandardInappContentType
                                  .onBoardingPageOneTitle.label,
                              content: StandardInappContentType
                                  .onBoardingPageOneContent.label,
                              imagePath:
                                  StandardAssetImage.onBoardingPageOneImage),
                          MessageDisplayWithBackgroundImage(
                              messageAlignment:
                                  Alignment(-1, smallDeviceAlert ? 0.3 : 0.1),
                              title: StandardInappContentType
                                  .onBoardingPageTwoTitle.label,
                              content: StandardInappContentType
                                  .onBoardingPageTwoContent.label,
                              imagePath:
                                  StandardAssetImage.onBoardingPageTwoImage),
                          MessageDisplayWithBackgroundImage(
                              messageAlignment: const Alignment(-1, -0.65),
                              title: StandardInappContentType
                                  .onBoardingPageThreeTitle.label,
                              content: StandardInappContentType
                                  .onBoardingPageThreeContent.label,
                              imagePath:
                                  StandardAssetImage.onBoardingPageThreeImage)
                        ])),
                Positioned(
                    bottom: 0,
                    right: 0,
                    width: MediaQuery.of(context).size.width,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      indicator,
                      // Expanded(child: SizedBox()),
                      const SizedBox(height: 28),
                      Container(
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  StandardSize.generalChipBorderPadding.right),
                          child: ElevatedButton(
                              style: currentFocus == 2
                                  ? StandardButtonStyle.regularGreenButtonStyle
                                  : StandardButtonStyle
                                      .regularYellowButtonStyle,
                              onPressed: () async {
                                if (currentFocus < 2) {
                                  await controller.animateToPage(
                                      currentFocus + 1,
                                      duration:
                                          const Duration(milliseconds: 250),
                                      curve: Curves.linear);
                                  onPageChange(currentFocus + 1, false);
                                } else {
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (_) => const PhoneInputView(
                                          mode: SignInMode.signIn)));
                                }
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Text(currentFocus == 2
                                      ? StandardInteractionTextType
                                          .generalButtonSignInLabel.label
                                      : StandardInteractionTextType
                                          .generalButtonNextStepLabel.label)))),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 24,
                        child: Offstage(
                          offstage: currentFocus != 2,
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: StandardInteractionTextType
                                    .onBoardingRegesterNotice1.label,
                                style: StandardTextStyle.black16R),
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                        CupertinoPageRoute(
                                            builder: (_) =>
                                                const PhoneInputView(
                                                    mode: SignInMode.reg)));
                                  },
                                text: StandardInteractionTextType
                                    .onBoardingRegesterNotice2.label,
                                style: StandardTextStyle.yellow16U)
                          ])),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height < 750
                              ? 36
                              : MediaQuery.of(context).size.height *
                                  StandardSize.onBoardingMessageCTABottomRatio)
                    ]))
              ]));
        });
  }
}
