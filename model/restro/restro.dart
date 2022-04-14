import 'package:com_goodtakes/model/base/base_method.dart';
import 'package:com_goodtakes/model/base/base_model.dart';
import 'package:com_goodtakes/model/basket/basket.dart';
import 'package:com_goodtakes/model/restro/restro_extension.dart';
import 'package:com_goodtakes/model/base/transaction_summary/transaction_summary.dart';
import 'package:com_goodtakes/service/convertor/latlng.dart';
import 'package:com_goodtakes/service/runtime_properties.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:collection/collection.dart';

class Restro extends BaseModel with BaseMethod {
  final String name;
  final String address;
  final String phone;
  final String email;
  final String image;
  final String district;
  final List<String> type;
  final String description;
  final LatLng location;
  final List<Basket> baskets;
  final TransactionSummary summary;

  const Restro._(
      {required this.address,
      required this.name,
      required String restroId,
      required this.phone,
      required this.email,
      required this.image,
      required this.district,
      required this.type,
      required this.description,
      required this.location,
      required this.summary,
      required Map<String, dynamic> meta,
      required this.baskets})
      : super(meta, restroId);

  factory Restro.build(Map restro, String restroId) {
    final Map? basketsMap = restro[RestroDBKey.basket.dbKey];
    late final List<Basket> baskets;
    if (basketsMap != null) {
      final entries = basketsMap.entries;
      baskets = List.generate(entries.length, (index) {
        return Basket.build(entries.elementAt(index).value,
            entries.elementAt(index).key, restroId);
      });
    } else {
      baskets = [];
    }
    return Restro._(
        address: restro[RestroDBKey.address.dbKey]["zh"],
        name: restro[RestroDBKey.name.dbKey]["zh"],
        restroId: restroId,
        phone: restro[RestroDBKey.phone.dbKey],
        email: restro[RestroDBKey.email.dbKey],
        image: restro[RestroDBKey.image.dbKey],
        district: restro[RestroDBKey.district.dbKey],
        type: ((restro[RestroDBKey.type.dbKey] as Map).keys)
            .cast<String>()
            .toList(),
        description: restro[RestroDBKey.description.dbKey]?["zh"] ?? "",
        location: LatLng.fromJson(restro[RestroDBKey.location.dbKey])!,
        summary: TransactionSummary.build(
            restro[RestroDBKey.transactionSummary.dbKey]),
        baskets: baskets,
        meta: (restro[baseModelDBKeyMeta] as Map).cast<String, dynamic>());
  }

  String get displayDistrict {
    final d = RM
        .get<RuntimeProperties>()
        .state
        .district
        .singleWhereOrNull((element) => element.id == district);
    if (d == null) {
      return "";
    } else {
      return d.displayName;
    }
  }

  String get distanceFromAnchor {
    final _distance =
        location.distantFrom(RM.get<RuntimeProperties>().state.position);
    return "距離 ${_distance.toStringAsFixed(1)} 公里";
  }

  Iterable<String> get displayTypes {
    final ts = RM
        .get<RuntimeProperties>()
        .state
        .types
        .where((element) => type.contains(element.id));

    if (ts.isEmpty) {
      return [];
    } else {
      return ts.map((e) => e.displayName);
    }
  }

  @override
  Map<String, dynamic> get dbStructure {
    return {
      RestroDBKey.name.dbKey: name,
      RestroDBKey.district.dbKey: district,
      RestroDBKey.description.dbKey: description,
      RestroDBKey.email.dbKey: email,
      RestroDBKey.image.dbKey: image,
      RestroDBKey.location.dbKey: location.toJson(),
      RestroDBKey.phone.dbKey: phone,
      RestroDBKey.type.dbKey: phone,
    };
  }

  static Restro get demo {
    return Restro.build(restroDemo, restroDemoId);
  }
}
