import 'package:com_goodtakes/model/base/base_model.dart';

const _dbKeyDescription = "description";
const _dbKeyDisplay = "display";
const _dbKeyIcon = "icon";

class ConfigModel extends BaseModel {
  final String description;
  final String displayName;
  final String? icon;

  const ConfigModel._(
      {required this.description,
      required this.displayName,
      required this.icon,
      required String id,
      required Map<String, dynamic> meta})
      : super(meta, id);

  factory ConfigModel.build(Map asset, String assetId) {
    return ConfigModel._(
        meta: (asset["meta"] as Map? ?? {}).cast<String, dynamic>(),
        description: asset[_dbKeyDescription]["zh"],
        displayName: asset[_dbKeyDisplay]["zh"],
        icon: asset[_dbKeyIcon],
        id: assetId);
  }
}
