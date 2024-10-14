import 'dart:convert';
import 'dart:io';

import 'package:fab_analytics/constants.dart';
import 'package:fab_analytics/models/attachment_credentials_model.dart';
import 'package:fab_analytics/models/attachment_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:http_parser/http_parser.dart' as httpParser;

String token =
    "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2MDUyN2E0MmYzZGM3N2NjYTIwNWIxZiIsImlhdCI6MTcyODcxOTg0MCwiZXhwIjoxNzI5MzI0NjQwfQ.vZb4rB7ghxqXokvL6W0rRteY17XukRcjhwcF2mMpgdY";

class FileUploadService {
  Future<AttachmentCredentialsModel> getSecureStorageToken({
    required String tenantId,
    required String storageId,
    required String fileName,
  }) async {
    try {
      String url =
          '${constants.API_HOST}/api/tenant/$tenantId/file/credentials?filename=$fileName&storageId=$storageId';
      var response = await http.get(Uri.parse(url), headers: {
        "Authorization": token,
      });
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        AttachmentCredentialsModel creds =
            AttachmentCredentialsModel.fromJson(jsonResponse);
        return creds;
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<AttachmentModel?> uploadScreenshot({
    required String tenantId,
    required File image,
    required BuildContext context,
  }) async {
    var uuid = Uuid();
    String fileId = uuid.v4();
    List<String> parts = image.path.split(".");
    String fileExtension = parts[parts.length - 1];
    String fileName = "$fileId.$fileExtension";

    AttachmentModel? attachmentModel;

    try {
      AttachmentCredentialsModel? attachCreds = await getSecureStorageToken(
        tenantId: tenantId,
        storageId: "screenTraceImage",
        fileName: fileName,
      );
      if (attachCreds.uploadCredentials!.fields!.key != null) {
        var fileBytes = image.readAsBytesSync();

        var formData = attachCreds.uploadCredentials!.fields!.toJson();
        // formData['file'] = fileBytes.toString();

        var request = http.MultipartRequest(
          'POST',
          Uri.parse(constants.fileUploadUrl),
        );

        formData.forEach((key, value) {
          request.fields[key] = value;
        });

        var multipartFile = http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: fileName,
          contentType: httpParser.MediaType('application', 'octet-stream'),
        );
        request.files.add(multipartFile);

        var response = await request.send();

        // var response = await http.post(
        //   Uri.parse(fileUploadUrl),
        //   headers: {
        //     'Content-Type': 'application/x-www-form-urlencoded',
        //   },
        //   body: formData,
        // );
        print("FILE UPLOAD RESPONSE : " + response.statusCode.toString());
        print("FILE UPLOADED AT: " + attachCreds.downloadUrl.toString());

        attachmentModel = AttachmentModel(
          downloadUrl: attachCreds.downloadUrl,
          id: fileId,
          name: fileName,
          isNew: true,
          privateUrl: attachCreds.privateUrl,
          publicUrl: attachCreds.uploadCredentials!.publicUrl,
          sizeInBytes: fileBytes.length,
          // createdAt: DateTime.now().toIso8601String(),
          // updatedAt: DateTime.now().toIso8601String(),
        );
        return attachmentModel;
      }
    } catch (e) {
      print("ERROR uploadAvatar: $e");
    }
  }

  Future<dynamic> getMetadata({required String tenantId}) async {
    try {
      var response = await http.get(Uri.parse(
          "${constants.API_HOST}/api/tenant/$tenantId/screen-trace/metadata"));
      return jsonDecode(response.body);
    } catch (e) {
      print("ERROR getMetadata " + e.toString());
    }
  }

  Future<bool> updateMetadata({
    required String tenantId,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      var response = await http.put(
          Uri.parse(
              "${constants.API_HOST}/api/tenant/$tenantId/screen-trace/$id"),
          body: jsonEncode(data),
          headers: {
            "Authorization": token,
            'Content-Type': 'application/json; charset=UTF-8',
          });
      print("RESPONSE updateMetadata " + response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
      // return jsonDecode(response.body);
    } catch (e) {
      print("ERROR updateMetadata " + e.toString());
      return false;
    }
  }
}
