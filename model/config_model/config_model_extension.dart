enum ConfigType { tag, type, district, placeIndex, headerAd }

extension ConfigTypeMethod on ConfigType {
  String get dbKey {
    switch (this) {
      case ConfigType.placeIndex:
        return "place_index";
      case ConfigType.tag:
        return "tag";
      case ConfigType.district:
        return "district";
      case ConfigType.type:
        return "type";
      case ConfigType.headerAd:
        return "header_ad";
      default:
        throw ArgumentError.value(this);
    }
  }
}
