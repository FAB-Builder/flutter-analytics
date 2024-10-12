class AttachmentCredentialsModel {
  String? privateUrl;
  String? downloadUrl;
  UploadCredentials? uploadCredentials;

  AttachmentCredentialsModel(
      {this.privateUrl, this.downloadUrl, this.uploadCredentials});

  AttachmentCredentialsModel.fromJson(Map<String, dynamic> json) {
    privateUrl = json['privateUrl'];
    downloadUrl = json['downloadUrl'];
    uploadCredentials = json['uploadCredentials'] != null
        ? UploadCredentials.fromJson(json['uploadCredentials'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['privateUrl'] = privateUrl;
    data['downloadUrl'] = downloadUrl;
    if (uploadCredentials != null) {
      data['uploadCredentials'] = uploadCredentials!.toJson();
    }
    return data;
  }
}

class UploadCredentials {
  String? url;
  Fields? fields;
  String? publicUrl;

  UploadCredentials({this.url, this.fields, this.publicUrl});

  UploadCredentials.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    fields = json['fields'] != null ? Fields.fromJson(json['fields']) : null;
    publicUrl = json['publicUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    if (fields != null) {
      data['fields'] = fields!.toJson();
    }
    data['publicUrl'] = publicUrl;
    return data;
  }
}

class Fields {
  String? key;
  String? acl;
  String? bucket;
  String? xAmzAlgorithm;
  String? xAmzCredential;
  String? xAmzDate;
  String? policy;
  String? xAmzSignature;

  Fields(
      {this.key,
      this.acl,
      this.bucket,
      this.xAmzAlgorithm,
      this.xAmzCredential,
      this.xAmzDate,
      this.policy,
      this.xAmzSignature});

  Fields.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    acl = json['acl'];
    bucket = json['bucket'];
    xAmzAlgorithm = json['X-Amz-Algorithm'];
    xAmzCredential = json['X-Amz-Credential'];
    xAmzDate = json['X-Amz-Date'];
    policy = json['Policy'];
    xAmzSignature = json['X-Amz-Signature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['acl'] = this.acl;
    data['bucket'] = this.bucket;
    data['X-Amz-Algorithm'] = this.xAmzAlgorithm;
    data['X-Amz-Credential'] = this.xAmzCredential;
    data['X-Amz-Date'] = this.xAmzDate;
    data['Policy'] = this.policy;
    data['X-Amz-Signature'] = this.xAmzSignature;
    return data;
  }
}
