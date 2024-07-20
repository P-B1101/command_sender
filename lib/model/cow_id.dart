class CowId {
  final String? id;
  final String? refId;

  const CowId({
    required this.id,
    required this.refId,
  });

  factory CowId.fromRefId(String refId) => CowId(id: null, refId: refId);

  String? get serialize {
    if (id == null && refId == null) return null;
    if (id == null) return refId;
    if (refId == null) return id;
    return '$id:$refId';
  }
}
