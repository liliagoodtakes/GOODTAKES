import 'package:com_goodtakes/model/base/base_method.dart';
import 'package:com_goodtakes/model/base/base_model.dart';
import 'package:com_goodtakes/model/basket/basket_extension.dart';
import 'package:com_goodtakes/service/convertor/datetime.dart';
import 'package:com_goodtakes/service/runtime_properties.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/scr/state_management/state_management.dart';

class Basket extends BaseModel with BaseMethod {
  final String name;
  final String image;
  final double originalPrice;
  final double promotionPrice;
  final Set<String> tags;
  final String restroId;
  final DateTimeRange? pickupTime;
  final String description;
  BasketStatus status;
  int stock;

  Basket._(
      {required this.restroId,
      required String basketId,
      required this.pickupTime,
      required this.stock,
      required this.image,
      required this.name,
      required this.originalPrice,
      required this.promotionPrice,
      required this.status,
      required this.tags,
      required this.description,
      required Map<String, dynamic> meta})
      : super(meta, basketId);

  factory Basket.build(Map basket, String basketId, String restroId) {
    // debugPrint("tags: ${basket[BasketDBKey.tag.dbKey]}");
    // debugPrint("keys: ${basket.keys}");

    final Map? dt = basket[BasketDBKey.pickupTime.dbKey];
    final DateTimeRange? pickupTime = dt == null
        ? null
        : DateTimeRange(
            start: DateTime.fromMillisecondsSinceEpoch(
                basket[BasketDBKey.pickupTime.dbKey]["start"] as int),
            end: DateTime.fromMillisecondsSinceEpoch(
                (basket[BasketDBKey.pickupTime.dbKey]["close"] as int)));

    return Basket._(
        restroId: restroId,
        meta: (basket[baseModelDBKeyMeta] as Map).cast<String, dynamic>(),
        basketId: basketId,
        description: basket[BasketDBKey.description.dbKey]["zh"],
        stock: basket[BasketDBKey.stock.dbKey],
        image: basket[BasketDBKey.image.dbKey],
        pickupTime: pickupTime,
        name: basket[BasketDBKey.name.dbKey]["zh"],
        originalPrice:
            (basket[BasketDBKey.originalPrice.dbKey] as num).toDouble(),
        promotionPrice:
            (basket[BasketDBKey.promotionPrice.dbKey] as num).toDouble(),
        status: BasketStatusMethod.statusAt(basket[BasketDBKey.status.dbKey]),
        tags: (basket[BasketDBKey.tag.dbKey] as Map?)
                ?.keys
                .toSet()
                .cast<String>() ??
            {});
  }

  int get availableStock {
    if (status != BasketStatus.available ||
        (pickupTime == null || pickupTime!.end.isBefore(DateTime.now()))) {
      return 0;
    } else {
      return stock -
          (meta["in_payment_progress"] as int? ?? 0) -
          (meta["locked_item"] as int? ?? 0);
    }
  }

  @override
  Map<String, dynamic> get dbStructure => {
        BasketDBKey.name.dbKey: {"zh": name},
        BasketDBKey.image.dbKey: image,
        BasketDBKey.originalPrice.dbKey: originalPrice,
        BasketDBKey.promotionPrice.dbKey: promotionPrice,
        BasketDBKey.stock.dbKey: stock,
        BasketDBKey.status.dbKey: status,
        BasketDBKey.pickupTime.dbKey: {
          "start": pickupTime?.start.millisecondsSinceEpoch,
          "close": pickupTime?.end.millisecondsSinceEpoch
        },
        BasketDBKey.tag.name:
            Map<String, bool>.fromEntries(tags.map((e) => MapEntry(e, true))),
      };

  TimeOfDay? get pickUpStartTimeOfDay {
    if (pickupTime != null) {
      return TimeOfDay.fromDateTime(pickupTime!.start);
    } else {
      return null;
    }
  }

  TimeOfDay? get pickUpCloseTimeOfDay {
    if (pickupTime != null) {
      return TimeOfDay.fromDateTime(pickupTime!.end);
    } else {
      return null;
    }
  }

  String? get generalPickUpTimeRangeStatement {
    if (pickupTime != null) {
      return pickupTime!.generalPickUpTimeRangeStatement;
    } else {
      debugPrint('pickupTime null');

      return null;
    }
  }

  Iterable<String> get displayTags {
    final ts = RM
        .get<RuntimeProperties>()
        .state
        .tags
        .where((element) => tags.contains(element.id));
    if (ts.isEmpty) {
      return [];
    } else {
      return ts.map((e) => e.displayName);
    }
  }

  static Basket get demo {
    return Basket.build(basketDemo, basketDemoID, "");
  }
}
