import 'package:com_goodtakes/model/base/meta_tag.dart';
import 'package:com_goodtakes/model/in_app_notification/in_app_notification.dart';
import 'package:com_goodtakes/states/authentication_state.dart';
import 'package:com_goodtakes/static/firebase_ref_path.dart';

import 'package:states_rebuilder/states_rebuilder.dart';

class MyNotificationState {
  final List<InAppNotification> notifications = [];
  int get myNotificationReadMd =>
      RM
          .get<AuthenticationState>()
          .state
          .profile!
          .meta[dbMetaNotificationReadMd] ??
      0;

  void addNoti(InAppNotification notification) {
    notifications.add(notification);
  }

  bool get haveUnreadedNotification {
    return notifications
        .any((element) => element.meta[dbMetaCreation] > myNotificationReadMd);
  }

  Future<void> init() async {
    if (RM.get<AuthenticationState>().state.user != null) {
      final notis = await DatabaseRootMethod.userDBReference(
              type: UserRootReferenceType.notification)
          ?.orderByChild("meta/creation")
          .get();
      final Iterable<InAppNotification>? inAppNotis =
          (notis?.value as Map?)?.entries.map((e) {
        // debugPrint("$e");
        return InAppNotification.build(e.value, e.key);
      });
      if (inAppNotis?.isNotEmpty ?? false) {
        notifications.addAll(inAppNotis!);
      }
    }
  }

  void clear() {
    notifications.clear();
  }
}
