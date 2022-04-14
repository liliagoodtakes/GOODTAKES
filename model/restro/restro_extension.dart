enum RestroDBKey {
  name,
  address,
  image,
  owner,
  phone,
  email,
  district,
  type,
  description,
  location,
  transactionSummary,
  basket
}

extension RestroDBKeyMethod on RestroDBKey {
  static RestroDBKey typeOf(String type) {
    switch (type) {
      case "basket":
        return RestroDBKey.basket;
      case "address":
        return RestroDBKey.address;
      case "name":
        return RestroDBKey.name;
      case "image":
        return RestroDBKey.image;
      case "owner":
        //   return RestroDBKey.owner;
        // case "phone":
        return RestroDBKey.phone;
      case "email":
        return RestroDBKey.email;
      case "district":
        return RestroDBKey.district;
      case "type":
        return RestroDBKey.type;
      case "description":
        return RestroDBKey.description;
      case "location":
        return RestroDBKey.location;
      case "transaction_summary":
        return RestroDBKey.transactionSummary;
      default:
        throw ArgumentError.value(type);
    }
  }

  String get dbKey {
    switch (this) {
      case RestroDBKey.basket:
        return "basket";
      case RestroDBKey.name:
        return "name";
      case RestroDBKey.image:
        return "image";
      case RestroDBKey.address:
        return "address";
      case RestroDBKey.phone:
        return "phone";
      case RestroDBKey.email:
        return "email";
      case RestroDBKey.district:
        return "district";
      case RestroDBKey.type:
        return "type";
      case RestroDBKey.description:
        return "description";
      case RestroDBKey.location:
        return "location";
      case RestroDBKey.transactionSummary:
        return "transaction_summary";
      default:
        throw ArgumentError.value(this);
    }
  }
}

const restroDemoId = "-MwHTC2mCko9K008AEL0";
const restroDemo = {
  "area": "zhone_1",
  "address": {"zh": "尖沙咀漢口道24號地下B舖"},
  "basket": {
    "52030ea1a74b": {
      "tag": {"tag-!": true, "tag-#": true, "tag-sa": true},
      "description": {"zh": "測試中的三明治禮包內，會有3個三明治\n甜品一件"},
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
      "name": {"zh": "測試中的三明治禮包"},
      "original_price": 213,
      "promotion_price": 48,
      "status": "disable",
      "stock": 5
    }
  },
  "description": {"zh": "測試餐廳描述"},
  "email": "abc@email.com",
  "image":
      "https://c.pxhere.com/photos/95/9c/cafe_coffee_woman_chair_table-8104.jpg!d",
  "location": [22.312228, 114.223711],
  "meta": {
    "bill_count": 0,
    "creation": 1645282382065,
    "md": 1645282382065,
    "owner": "BgjVTLPpPcXFaDc3HjsDfD3HMI63",
    "ref_id": "0001",
    "status": "normal"
  },
  "name": {"zh": "測試餐廳"},
  "phone": "+852 91234567",
  "transaction_summary": {
    "carbon_emission_reduction": 0,
    "meal_saved": 0,
    "money_saved": 0
  },
  "type": {"type_1": true}
};
