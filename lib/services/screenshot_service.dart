import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fab_analytics/models/attachment_model.dart';
import 'package:fab_analytics/models/config_model.dart';
import 'package:fab_analytics/services/file_upload_service.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scroll_screenshot/scroll_screenshot.dart';

void takeAndUploadScreenshot(
    {required BuildContext context, required Config config}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );
  try {
    String? selectedOption = 'select';
    TextEditingController displayNameController = TextEditingController();

    bool screenshotUploaded = true;

    FileUploadService service = FileUploadService();
    String? base64String = await ScrollScreenshot.captureAndSaveScreenshot(
      // config.keys["homeScreen"]["key"],
      config.appKey!,
    );
    Uint8List bytes = base64Decode(base64String!);
    Directory tempDir = await getTemporaryDirectory();
    String filePath = '${tempDir.path}/screenshot.png';
    File file = File(filePath);
    file = await file.writeAsBytes(bytes);
    AttachmentModel? attachmentModel = await service.uploadScreenshot(
      tenantId: config.credentials["applicationId"],
      image: file,
      context: context,
    );

    if (attachmentModel != null) {
      // String? selectedOption;
      List<dynamic> response = await service.getMetadata(
        tenantId: config.credentials["applicationId"],
      );
      List<String> options = ['select'];
      response.asMap().forEach((index, map) {
        String displayName = "";
        String identifier = "";
        if (map["screentrace"] != null) {
          if (map["screentrace"]["displayName"] != null) {
            displayName = map["screentrace"]["displayName"];
          }
          if (map["screentrace"]["identifier"] != null) {
            identifier = map["screentrace"]["identifier"];
          }
        } else {
          if (map["_id"] != null) {
            displayName = map["_id"];
            identifier = map["_id"];
          }
        }
        options.add(index.toString() + "-" + displayName + " : " + identifier);
      });
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                  'Which screen do you to want this screenshot to be mapped with?',
                ),
                content: Container(
                  height: 300,
                  padding: EdgeInsets.all(14),
                  child: Column(
                    children: [
                      DropdownButton<String>(
                        isExpanded: true,
                        items: options.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          );
                        }).toList(),
                        value: selectedOption,
                        onChanged: (val) {
                          setState(
                            () {
                              selectedOption = val ?? "";
                            },
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: displayNameController,
                        decoration: InputDecoration(
                          labelText: 'Display Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      screenshotUploaded
                          ? SizedBox(height: 30)
                          : SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(),
                            ),
                      SizedBox(height: 10),
                      ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              screenshotUploaded = false;
                            });
                            int index = int.tryParse(
                                    selectedOption.toString().split("-")[0]) ??
                                -1;
                            var element = response[index];
                            if (element["screentrace"] != null) {
                              // var image =
                              //     attachmentModel.toJson();
                              // image['_id'] =
                              //     element["screentrace"]
                              //         ["_id"];
                              String identifier =
                                  element["screentrace"]["identifier"];
                              Map<String, dynamic> data = {
                                "id": element["screentrace"]["_id"],
                                "data": {
                                  "identifier": identifier,
                                  "displayName":
                                      displayNameController.text.isNotEmpty
                                          ? displayNameController.text
                                          : identifier,
                                  "image": [attachmentModel.toJson()],
                                }
                              };
                              print('IMAGE');
                              print(data.toString());
                              print(attachmentModel.toJson().toString());
                              bool isUpdated = await service.updateMetadata(
                                tenantId: config.credentials["applicationId"],
                                id: element["screentrace"]["_id"],
                                data: data,
                              );
                              if (isUpdated) {
                                setState(() {
                                  screenshotUploaded = true;
                                });
                                Future.delayed(Duration(seconds: 2), () {
                                  Navigator.pop(context);
                                  setState(() {
                                    screenshotUploaded = false;
                                  });
                                });
                              }
                            } else {
                              String identifier = element["_id"];
                              Map<String, dynamic> data = {
                                "data": {
                                  "identifier": identifier,
                                  "displayName":
                                      displayNameController.text.isNotEmpty
                                          ? displayNameController.text
                                          : identifier,
                                  "image": [attachmentModel.toJson()],
                                }
                              };
                              print('IMAGE');
                              print(data.toString());
                              print(attachmentModel.toJson().toString());
                              bool isUpdated = await service.createMetadata(
                                tenantId: config.credentials["applicationId"],
                                data: data,
                              );
                              if (isUpdated) {
                                setState(() {
                                  screenshotUploaded = true;
                                });
                                Future.delayed(Duration(seconds: 2), () {
                                  Navigator.pop(context);
                                  setState(() {
                                    screenshotUploaded = false;
                                  });
                                });
                              }
                            }
                          },
                          child: Text(
                            'save',
                          )),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    } else {
      Navigator.pop(context);
    }
  } catch (e) {
    Navigator.pop(context);
    print(e.toString());
  }
}
