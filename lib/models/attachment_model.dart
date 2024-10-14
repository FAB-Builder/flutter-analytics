class AttachmentModel {
  String? id;
  // String? _id;
  String? belongsTo;
  String? belongsToId;
  String? belongsToColumn;
  String? name;
  int? sizeInBytes;
  String? privateUrl;
  String? publicUrl;
  String? createdAt;
  String? updatedAt;
  DateTime? deletedAt;
  String? tenantId;
  String? createdById;
  String? updatedById;
  String? downloadUrl;
  bool? isNew;

  AttachmentModel({
    this.id,
    this.belongsTo,
    this.belongsToId,
    this.belongsToColumn,
    this.name,
    this.sizeInBytes,
    this.privateUrl,
    this.publicUrl,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.tenantId,
    this.createdById,
    this.updatedById,
    this.downloadUrl,
    this.isNew,
  });

  AttachmentModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    belongsTo = json['belongsTo'];
    belongsToId = json['belongsToId'];
    belongsToColumn = json['belongsToColumn'];
    name = json['name'];
    sizeInBytes = json['sizeInBytes'];
    privateUrl = json['privateUrl'];
    publicUrl = json['publicUrl'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    tenantId = json['tenantId'];
    createdById = json['createdById'];
    updatedById = json['updatedById'];
    downloadUrl = json['downloadUrl'];
    isNew = json['new'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['belongsTo'] = this.belongsTo;
    data['belongsToId'] = this.belongsToId;
    data['belongsToColumn'] = this.belongsToColumn;
    data['name'] = this.name;
    data['sizeInBytes'] = this.sizeInBytes;
    data['privateUrl'] = this.privateUrl;
    data['publicUrl'] = this.publicUrl;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    data['tenantId'] = this.tenantId;
    data['createdById'] = this.createdById;
    data['updatedById'] = this.updatedById;
    data['downloadUrl'] = this.downloadUrl;
    data['new'] = this.isNew;

    return data;
  }
}
