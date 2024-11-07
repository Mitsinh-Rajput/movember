import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/instance_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/auth_controller.dart';
import 'services/init.dart';
import 'services/theme.dart';
import 'views/screens/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Init().initialize();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> snackBarKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    log('Current state = $state');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Timer.run(() async {
      if (await Get.find<AuthController>().connectivity()) {
        SharedPreferences sharedPreferences = Get.find();
        List<dynamic> savedData = jsonDecode(sharedPreferences.getString('saved_data') ?? '[]');
        List remaining = [];
        if (savedData.isNotEmpty) {
          log(savedData.toString(), name: "Data available");
          for (int i = savedData.length - 1; i >= 0; i--) {
            var element = savedData[i];
            log("$element", name: "Data element");

            // if (false)
            Get.find<AuthController>().submitDa(element).then((value) {
              if (value.isSuccess) {
                log("${value.isSuccess}");
                savedData.removeAt(savedData.indexOf(element));
              } else {
                remaining.add(element);
              }
            });
          }
          Get.find<AuthController>().animationController.forward(from: 0);
          Fluttertoast.showToast(msg: "Synced Successfully");
          sharedPreferences.setString('saved_data', jsonEncode(remaining));
        }
      }
    });

    // try {
    //   // _rotationChannel.invokeMethod('setLandscape');
    // } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        title: "Movember Let It Grow",
        navigatorKey: navigatorKey,
        themeMode: ThemeMode.light,
        theme: CustomTheme.light,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
