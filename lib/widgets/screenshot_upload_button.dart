import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fab_analytics/models/attachment_model.dart';
import 'package:fab_analytics/models/config_model.dart';
import 'package:fab_analytics/services/file_upload_service.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scroll_screenshot/scroll_screenshot.dart';

void screenshotUploadButton(Config config, BuildContext context) {
  String? selectedOption = 'select';
  bool loading = false;
  bool screenshotUploaded = true;

  if (config.isDebugMode) {
    OverlayEntry? _overlayEntry;
    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
        builder: (context) => StatefulBuilder(
              builder: (context, setState) {
                return Positioned(
                  right: 10.0,
                  bottom: 100.0,
                  child: GestureDetector(
                    onTap: () async {
                      try {
                        setState(() {
                          loading = true;
                        });
                        FileUploadService service = FileUploadService();
                        String? base64String =
                            await ScrollScreenshot.captureAndSaveScreenshot(
                          // config.keys["homeScreen"]["key"],
                          config.appKey!,
                        );
                        Uint8List bytes = base64Decode(base64String!);
                        Directory tempDir = await getTemporaryDirectory();
                        String filePath = '${tempDir.path}/screenshot.png';
                        File file = File(filePath);
                        file = await file.writeAsBytes(bytes!);
                        AttachmentModel? attachmentModel =
                            await service.uploadScreenshot(
                          tenantId: config.applicationId,
                          image: file,
                          context: context,
                        );

                        if (attachmentModel != null) {
                          // String? selectedOption;
                          List<dynamic> response = await service.getMetadata(
                              tenantId: config.applicationId);
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
                            }
                            options.add(index.toString() +
                                "-" +
                                displayName +
                                " : " +
                                identifier);
                          });
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
                                      height: 200,
                                      padding: EdgeInsets.all(14),
                                      child: Column(
                                        children: [
                                          DropdownButton<String>(
                                            items: options.map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
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
                                          screenshotUploaded
                                              ? SizedBox(height: 30)
                                              : SizedBox(
                                                  height: 30,
                                                  width: 30,
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                          SizedBox(height: 10),
                                          ElevatedButton(
                                              onPressed: () async {
                                                setState(() {
                                                  screenshotUploaded = false;
                                                });
                                                int index = int.tryParse(
                                                        selectedOption
                                                            .toString()
                                                            .split("-")[0]) ??
                                                    -1;
                                                var element = response[index];
                                                if (element["screentrace"] !=
                                                    null) {
                                                  // var image =
                                                  //     attachmentModel.toJson();
                                                  // image['_id'] =
                                                  //     element["screentrace"]
                                                  //         ["_id"];
                                                  Map<String, dynamic> data = {
                                                    "id": element["screentrace"]
                                                        ["_id"],
                                                    "data": {
                                                      "identifier":
                                                          element["screentrace"]
                                                              ["identifier"],
                                                      "displayName":
                                                          element["screentrace"]
                                                              ["displayName"],
                                                      "image": [
                                                        attachmentModel.toJson()
                                                      ],
                                                    }
                                                  };
                                                  print('IMAGE');
                                                  print(attachmentModel
                                                      .toJson()
                                                      .toString());
                                                  bool isUpdated = await service
                                                      .updateMetadata(
                                                    tenantId:
                                                        config.applicationId,
                                                    id: element["screentrace"]
                                                        ["_id"],
                                                    data: data,
                                                  );
                                                  if (isUpdated) {
                                                    setState(() {
                                                      screenshotUploaded = true;
                                                    });
                                                    Future.delayed(
                                                        Duration(seconds: 2),
                                                        () {
                                                      Navigator.pop(context);
                                                      setState(() {
                                                        screenshotUploaded =
                                                            false;
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
                        }
                        setState(() {
                          loading = false;
                        });
                      } catch (e) {
                        print(e.toString());
                        setState(() {
                          loading = false;
                        });
                      }
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.purple,
                      ),
                      child: loading
                          ? Container(
                              padding: EdgeInsets.all(14),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Icon(
                              Icons.upload,
                              color: Colors.white,
                            ),
                    ),
                  ),
                );
              },
            ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      overlay.insert(_overlayEntry!);
    });
  }
}