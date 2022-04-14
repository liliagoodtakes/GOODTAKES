import 'package:com_goodtakes/model/config_model/config_mode.dart';
import 'package:com_goodtakes/model/config_model/config_model_extension.dart';
import 'package:com_goodtakes/service/database/database_r.dart';
import 'package:flutter/material.dart';

class MainState {
  late final List<ConfigModel> district;
  late final List<ConfigModel> types;

  Future<void> init() async {
    final _appUniversal = await adminPortalUniversal;

    district = ((_appUniversal[ConfigType.district.dbKey] as Map?) ?? {})
        .entries
        .map((e) => ConfigModel.build(e.value as Map, e.key))
        .toList();

    types = ((_appUniversal[ConfigType.type.dbKey] as Map?) ?? {})
        .entries
        .map((e) => ConfigModel.build(e.value as Map, e.key))
        .toList();
    debugPrint(
        "Main State Init : types ${types.length} ::: district ${district.length}");
  }

  final localeZhKey = "zh";
  Set<String> get l1DistrictSelector =>
      district.map((e) => e.meta["group"][0][localeZhKey] as String).toSet();
  Set<String> l2DistrictSelector(String key) => district
      .where((e) => e.meta["group"][0][localeZhKey] as String == key)
      .map((e) => e.meta["group"][1][localeZhKey] as String)
      .toSet();
  Set<ConfigModel> l3DistrictSelector(String key) => district.where((e) {
        final k = e.meta["group"][1][localeZhKey];
        debugPrint("$k == $key");
        return k == key;
      }).toSet();

  Set<String> get l1TypeSelector =>
      types.map((e) => e.meta["group"][0][localeZhKey] as String).toSet();
  Set<ConfigModel> l2TypeSelector(String key) => types
      .where((e) => e.meta["group"][0][localeZhKey] as String == key)
      .toSet();
}
