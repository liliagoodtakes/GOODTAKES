import 'package:com_goodtakes/model/base/base_model.dart';

enum InAppNotificationType { system, restro, transaction }

class InAppNotification extends BaseModel {
  InAppNotification(
      {required this.body,
      required this.title,
      required Map<String, dynamic> meta,
      required String id})
      : super(meta, id);

  final String title;
  final String body;

  factory InAppNotification.build(Map inAppNotification, String id) {
    return InAppNotification(
        body: inAppNotification["body"]["zh"],
        title: inAppNotification["title"]["zh"],
        meta: (inAppNotification[baseModelDBKeyMeta] as Map)
            .cast<String, dynamic>(),
        id: id);
  }

  static InAppNotification get demo {
    return InAppNotification(body: "body", title: "title", meta: {}, id: "id");
  }
}
