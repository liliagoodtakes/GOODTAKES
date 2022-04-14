import 'package:com_goodtakes/model/basket/basket.dart';

enum BasketDBKey {
  name,
  image,
  originalPrice,
  promotionPrice,
  tag,
  stock,
  status,
  pickupTime,
  description
}

enum BasketStatus { available, disable, inhibit, sold }

extension BasketStatusMethod on BasketStatus {
  static BasketStatus statusAt(String status) {
    switch (status) {
      case "available":
        return BasketStatus.available;
      case "disable":
        return BasketStatus.disable;
      case "sold":
        return BasketStatus.sold;
      case "inhibit":
        return BasketStatus.inhibit;
      default:
        throw ArgumentError.value(status);
    }
  }
}

extension BasketDBKeyDBKeyMethod on BasketDBKey {
  static BasketDBKey typeOf(String type) {
    switch (type) {
      case "name":
        return BasketDBKey.name;
      case "image":
        return BasketDBKey.image;
      case "original_price":
        return BasketDBKey.originalPrice;
      case "promotion_price":
        return BasketDBKey.promotionPrice;
      case "tag":
        return BasketDBKey.tag;
      case "stock":
        return BasketDBKey.stock;
      case "status":
        return BasketDBKey.status;
      case "pickup_time":
        return BasketDBKey.pickupTime;
      case "description":
        return BasketDBKey.description;
      default:
        throw ArgumentError.value(type);
    }
  }

  String get dbKey {
    switch (this) {
      case BasketDBKey.description:
        return "description";
      case BasketDBKey.name:
        return "name";
      case BasketDBKey.image:
        return "image";
      case BasketDBKey.originalPrice:
        return "original_price";
      case BasketDBKey.promotionPrice:
        return "promotion_price";
      case BasketDBKey.tag:
        return "tag";
      case BasketDBKey.stock:
        return "stock";
      case BasketDBKey.status:
        return "status";
      case BasketDBKey.pickupTime:
        return "pickup_time";
      default:
        throw ArgumentError.value(this);
    }
  }
}

const basketDemoID = "52030ea1a74b";
const basketDemo = {
  "description": {"zh": " cqwdq feq"},
  "image":
      "https://c.pxhere.com/photos/95/9c/cafe_coffee_woman_chair_table-8104.jpg!d",
  "meta": {
    "creation": 1645507677941,
    "in_payment_progress": 0,
    "locked_item": 0,
    "md": 1645507677941,
    "session_lock": 0
  },
  "pickup_time": {"start": 0, "close": 0},
  "name": {"zh": "三明治"},
  "original_price": 213.0,
  "promotion_price": 48.0,
  "status": "disable",
  "stock": 0,
  "tag": {"tag-!": true, "tag-#": true, "tag-sa": true}
};
