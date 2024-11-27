import 'package:fab_analytics/fab_analytics.dart';
import 'package:fab_analytics/models/config_model.dart';
import 'package:fab_analytics/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnalyticsMaterialApp extends StatelessWidget {
  final bool isDebugMode;
  final GlobalKey appKey;
  final Widget materialApp;
  final Config config;
  final plugin = FabAnalytics();
  final navigatorKey;

  AnalyticsMaterialApp({
    super.key,
    required this.isDebugMode,
    required this.appKey,
    required this.materialApp,
    required this.config,
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController passowrd = TextEditingController();
    return isDebugMode
        ? RepaintBoundary(
            key: appKey,
            child: GestureDetector(
              onLongPress: () {
                String? token = Config.token;
                if (token == null) {
                  showDialog(
                    context: navigatorKey.currentState!.overlay!.context,
                    builder: (context) => Scaffold(
                      body: Container(
                        height: 300,
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              "Login to upload your screenshot",
                              style: TextStyle(fontSize: 22),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: email,
                              decoration: InputDecoration(hintText: "Email"),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: passowrd,
                              decoration: InputDecoration(hintText: "password"),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                if (email.text.isNotEmpty &&
                                    passowrd.text.isNotEmpty) {
                                  // Config.token = response;
                                  AuthService service = new AuthService();
                                  await service.loginWithEmail(
                                      email: email.text,
                                      password: passowrd.text);
                                  Navigator.pop(
                                    navigatorKey.currentState!.overlay!.context,
                                  );
                                  plugin.takeScreenshot(
                                    context: navigatorKey
                                        .currentState!.overlay!.context,
                                    config: config,
                                  );
                                } else {
                                  ScaffoldMessenger.of(
                                    navigatorKey.currentState!.overlay!.context,
                                  ).showSnackBar(
                                    SnackBar(
                                      content: Text("Fill your credentials!"),
                                    ),
                                  );
                                }
                              },
                              child: Text("login"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  plugin.takeScreenshot(
                    context: navigatorKey.currentState!.overlay!.context,
                    config: config,
                  );
                }
              },
              child: materialApp,
            ),
          )
        : materialApp;
  }
}
