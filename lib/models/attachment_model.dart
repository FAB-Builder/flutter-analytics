class AttachmentModel {
  String? id;
  String? name;
  int? sizeInBytes;
  String? privateUrl;
  String? publicUrl;
  String? downloadUrl;
  bool? isNew;

  AttachmentModel({
    this.id,
    this.name,
    this.sizeInBytes,
    this.privateUrl,
    this.publicUrl,
    this.downloadUrl,
    this.isNew,
  });

  AttachmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sizeInBytes = json['sizeInBytes'];
    privateUrl = json['privateUrl'];
    publicUrl = json['publicUrl'];
    downloadUrl = json['downloadUrl'];
    isNew = json['new'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['sizeInBytes'] = this.sizeInBytes;
    data['privateUrl'] = this.privateUrl;
    data['publicUrl'] = this.publicUrl;
    data['downloadUrl'] = this.downloadUrl;
    data['new'] = this.isNew;

    return data;
  }
}
