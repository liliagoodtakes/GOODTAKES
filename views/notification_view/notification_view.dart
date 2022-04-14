import 'package:com_goodtakes/states/my_notification_state.dart';
import 'package:com_goodtakes/static/content/standard_asset_image.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/widgets/display/in_app_notification.dart';
import 'package:com_goodtakes/widgets/interaction/appbar/static_appbar.dart';
import 'package:com_goodtakes/widgets/interaction/gt_icon_button.dart';

import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class InAppNotificationView extends StatelessWidget {
  const InAppNotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnBuilder<MyNotificationState>(
      listenTo: RM.get<MyNotificationState>(),
      builder: () {
        final model = RM.get<MyNotificationState>();

        final notifications = model.state.notifications;
        debugPrint("notifications.length: ${notifications.length}");
        late final Widget body;
        if (notifications.isEmpty && !model.isWaiting) {
          body = Align(
              alignment: Alignment.center,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(StandardAssetImage.emptyListReplacement),
                    const SizedBox(height: 5),
                    Text(
                        StandardInappContentType
                            .generalEmptyListReplacementLabel.label,
                        style: StandardTextStyle.grey18R)
                  ]));
        } else if (model.isWaiting) {
          body = const Align(
              alignment: Alignment.center,
              child: SizedBox(
                  width: 50, height: 50, child: CircularProgressIndicator()));
        } else {
          body = ListView.builder(
              padding: StandardSize.generalViewPadding,
              itemCount: notifications.length,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 11),
                  child: InAppNotificationChip(
                      notification: notifications.elementAt(index)),
                );
              }));
        }

        return Scaffold(
            backgroundColor: StandardColor.lightGrey,
            appBar: StaticAppBar(
                leading: GTIconButton(
                    foregroundColor: StandardColor.yellow,
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                title: StandardInappContentType.notificationAppbarTitle.label),
            body: body);
      },
    );
  }
}
