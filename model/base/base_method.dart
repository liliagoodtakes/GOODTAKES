/// For Ensuring method implemented
mixin BaseMethod {
  /// The method will retrun MAP that for direct replace remote DB,
  /// The id, meta and summary should always exclude what should be controlled in cloud
  Map<String, dynamic> get dbStructure;
}
