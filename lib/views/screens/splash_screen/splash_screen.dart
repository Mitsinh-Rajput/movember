import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

import '../../../controllers/auth_controller.dart';
import '../../../main.dart';
import '../../base/common_button.dart';
import '../../base/custom_image.dart';
import '../../base/dialogs/camera.dart';
import 'form_screen.dart';
import 'last_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    Timer.run(() async {
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {});
      });
      Get.find<AuthController>().animationController = AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
      );
      if (!(await Permission.camera.status.isGranted)) {
        await Permission.camera.request();
      }
    });
  }

  @override
  void dispose() {
    Get.find<AuthController>().animationController.dispose();
    super.dispose();
  }

  void showpopup() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            title: Text(
              "Camera Premission Required!",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            content: Text(
              "To capture a photo with a mustache effect, the app requires camera permission.",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 12, color: Colors.black),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    color: Colors.white,
                    elevation: 0,
                    type: ButtonType.secondary,
                    radius: 10,
                    onTap: () {
                      Navigator.of(context).pop(); // Closes the popup
                    },
                    child: const Text("Cancel"),
                  ),
                  CustomButton(
                    elevation: 0,
                    color: Colors.green,
                    type: ButtonType.primary,
                    radius: 10,
                    onTap: () async {
                      await openAppSettings();
                    },
                    child: const Text("Open Settings"),
                  ),
                ],
              ),
            ],
          );
        });
  }

  Future<void> _pickImage(ImageSource source, String? assets) async {
    var navigator = Navigator.of(navigatorKey.currentContext!);
    bool permission = false;
    if (source == ImageSource.camera) {
      permission = await Get.find<AuthController>().getPermission(Permission.camera, context);
    }
    if (permission) {
      SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
        ],
      ).then((value) async {
        File? pickedFile = await navigator.push(MaterialPageRoute(
          builder: (context) => CameraScreen(
            assets: assets,
          ),
        ));
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);

        log("dfsdgsdfsd");

        if (pickedFile != null) {
          log("dfsdgsdfsd");
          Get.find<AuthController>().imageFile = pickedFile;
          Get.find<AuthController>().screenShotImageFile = pickedFile;
          await Get.find<AuthController>().pageController.animateToPage(8, duration: const Duration(milliseconds: 50), curve: Curves.ease);
          Get.find<AuthController>().update();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<AuthController>(builder: (authController) {
      return Scaffold(
        body: Container(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              PageView.builder(
                controller: authController.pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: authController.images.length,
                onPageChanged: (va) {
                  log("${authController.pageController.page}");
                  log("$va", name: "Index");
                  setState(() {});
                },
                itemBuilder: (BuildContext context, int index) {
                  // if (index == 1) {
                  //   return const FormScreen();
                  // }

                  return CustomImage(
                    path: authController.images[index],
                    width: size.width,
                    height: size.height,
                    fit: BoxFit.fitWidth,
                  );
                },
              ),

              if (authController.pageController.hasClients)
                if (authController.pageController.page?.round() == 1)
                  Positioned.fill(
                    child: FormScreen(),
                  ),
              if (authController.pageController.hasClients)
                if (authController.pageController.page?.round() == 7) ...[
                  Positioned(
                      top: 360,
                      left: 110,
                      child: GestureDetector(
                        onTap: () async {
                          try {
                            if (!(await Permission.camera.status.isGranted)) {
                              await Permission.camera.request();
                              showpopup();
                            } else {
                              _pickImage(ImageSource.camera, Assets.images12);
                            }
                          } catch (e) {
                            Fluttertoast.showToast(msg: e.toString());
                          }
                        },
                        child: Container(
                          color: Colors.transparent,
                          height: 100,
                          width: 185,
                        ),
                      )),
                  Positioned(
                      top: 360,
                      left: 335,
                      child: GestureDetector(
                        onTap: () async {
                          if (!(await Permission.camera.status.isGranted)) {
                            await Permission.camera.request();
                            showpopup();
                          } else {
                            _pickImage(ImageSource.camera, Assets.images13);
                          }
                        },
                        child: Container(
                          color: Colors.transparent,
                          height: 100,
                          width: 185,
                        ),
                      )),
                  Positioned(
                      top: 360,
                      right: 120,
                      child: GestureDetector(
                        onTap: () async {
                          if (!(await Permission.camera.status.isGranted)) {
                            await Permission.camera.request();
                            showpopup();
                          } else {
                            _pickImage(ImageSource.camera, Assets.images15);
                          }
                        },
                        child: Container(
                          color: Colors.transparent,
                          height: 100,
                          width: 185,
                        ),
                      )),
                  Positioned(
                      top: 360,
                      right: 333,
                      child: GestureDetector(
                        onTap: () async {
                          if (!(await Permission.camera.status.isGranted)) {
                            await Permission.camera.request();
                            showpopup();
                          } else {
                            _pickImage(ImageSource.camera, Assets.images14);
                          }
                        },
                        child: Container(
                          color: Colors.transparent,
                          height: 100,
                          width: 185,
                        ),
                      )),
                  Positioned(
                      bottom: 200,
                      left: 110,
                      child: GestureDetector(
                        onTap: () async {
                          if (!(await Permission.camera.status.isGranted)) {
                            await Permission.camera.request();
                            showpopup();
                          } else if ((await Permission.camera.isPermanentlyDenied)) {
                            await Permission.camera.request();
                            showpopup();
                          } else {
                            _pickImage(ImageSource.camera, Assets.images16);
                          }
                        },
                        child: Container(
                          color: Colors.transparent,
                          height: 100,
                          width: 185,
                        ),
                      )),
                  Positioned(
                      bottom: 200,
                      left: 335,
                      child: GestureDetector(
                        onTap: () async {
                          if (!(await Permission.camera.status.isGranted)) {
                            await Permission.camera.request();
                            showpopup();
                          } else {
                            _pickImage(ImageSource.camera, Assets.images17);
                          }
                        },
                        child: Container(
                          color: Colors.transparent,
                          height: 100,
                          width: 185,
                        ),
                      )),
                  Positioned(
                      bottom: 200,
                      right: 123,
                      child: GestureDetector(
                        onTap: () async {
                          if (!(await Permission.camera.status.isGranted)) {
                            await Permission.camera.request();
                            showpopup();
                          } else {
                            _pickImage(ImageSource.camera, Assets.images19);
                          }
                        },
                        child: Container(
                          color: Colors.transparent,
                          height: 100,
                          width: 185,
                        ),
                      )),
                  Positioned(
                      bottom: 200,
                      right: 333,
                      child: GestureDetector(
                        onTap: () async {
                          if (!(await Permission.camera.status.isGranted)) {
                            await Permission.camera.request();
                            showpopup();
                          } else {
                            _pickImage(ImageSource.camera, Assets.images18);
                          }
                        },
                        child: Container(
                          color: Colors.transparent,
                          height: 100,
                          width: 185,
                        ),
                      )),
                ],

              if (authController.pageController.hasClients)
                if (authController.pageController.page?.round() == 8)
                  Positioned(
                      top: 253,
                      left: 340,
                      child: Screenshot(
                        controller: authController.screenshotController,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 38,
                              bottom: 38,
                              left: 38,
                              right: 38,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(300),
                                child: Image.file(
                                  Get.find<AuthController>().screenShotImageFile!,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const CustomImage(
                              path: Assets.images32,
                              height: 409,
                            ),
                          ],
                        ),
                      )),

              // ----------------- Last Page ------------------------
              if (authController.pageController.hasClients)
                if (authController.pageController.page?.round() == authController.images.length - 1) const LastPage(),

              // ----------------- Forward Button ------------------------
              if (authController.pageController.hasClients)
                if (authController.pageController.page!.round() > 0)
                  Positioned(
                    right: 48,
                    bottom: 28,
                    child: GestureDetector(
                      onTap: () async {
                        if (authController.pageController.page == 8) {
                          Get.find<AuthController>().imageFile =
                              await Get.find<AuthController>().convertUint8ListToImageFile(await Get.find<AuthController>().screenshotController.capture());
                          Get.find<AuthController>().update();
                        }
                        authController.forwardButton();
                      },
                      child: const CustomImage(
                        path: Assets.imagesNextButton,
                        height: 55,
                        width: 55,
                      ),
                    ),
                  ),

              // ----------------- Download Button ------------------------
              if (authController.pageController.hasClients)
                if (authController.pageController.page!.round() == 8)
                  if (authController.isSE)
                    Positioned(
                      right: 48,
                      bottom: 28,
                      child: GestureDetector(
                        onTap: () async {
                          authController.saveInGallery();
                        },
                        child: const CustomImage(
                          path: Assets.images36,
                          height: 55,
                          width: 55,
                        ),
                      ),
                    ),

              // ----------------- Download Button ------------------------
              if (authController.pageController.hasClients)
                if (authController.pageController.page!.round() == 8)
                  if (!authController.isSE)
                    Positioned(
                      right: 128,
                      bottom: 28,
                      child: GestureDetector(
                        onTap: () async {
                          authController.saveInGallery();
                          authController.forwardButton();
                        },
                        child: const CustomImage(
                          path: Assets.images36,
                          height: 55,
                          width: 55,
                        ),
                      ),
                    ),

              // ----------------- SE Button ------------------------
              if (authController.pageController.hasClients)
                if (authController.pageController.page?.round() == 0)
                  Positioned(
                    right: 40,
                    bottom: 20,
                    child: GestureDetector(
                      onTap: () async {
                        authController.isSE = true;
                        authController.forwardButton();
                      },
                      child: const CustomImage(
                        path: Assets.imagesFIELD,
                        height: 73,
                        width: 73,
                      ),
                    ),
                  ),

              // ----------------- DR Button ------------------------
              if (authController.pageController.hasClients)
                if (authController.pageController.page?.round() == 0)
                  Positioned(
                    right: 128,
                    bottom: 28,
                    child: GestureDetector(
                      onTap: () async {
                        authController.isSE = false;
                        authController.forwardButton();
                      },
                      child: const CustomImage(
                        path: Assets.images34,
                        height: 55,
                        width: 55,
                      ),
                    ),
                  ),

              if (authController.pageController.hasClients)
                if (authController.pageController.page?.round() == authController.images.length - 1)
                  Positioned(
                    right: 48,
                    bottom: 28,
                    child: GestureDetector(
                      onTap: () async {
                        authController.homeButton();
                      },
                      child: const CustomImage(
                        path: Assets.imagesHomeButton,
                        height: 55,
                        width: 55,
                      ),
                    ),
                  ),

              // ----------------- Back Button ------------------------
              if (authController.pageController.hasClients)
                if (authController.pageController.page!.round() > 1)
                  Positioned(
                    left: 38,
                    bottom: 28,
                    child: GestureDetector(
                      onTap: () async {
                        authController.backButton();
                      },
                      child: const CustomImage(
                        path: Assets.imagesBackButton,
                        height: 55,
                        width: 55,
                      ),
                    ),
                  ),

              // ----------------- Home Button ------------------------
              if (authController.pageController.hasClients)
                if (authController.pageController.page!.round() > 0 && authController.pageController.page?.round() != authController.images.length - 1)
                  Positioned(
                    right: 38,
                    top: 28,
                    child: GestureDetector(
                      onTap: () async {
                        if (authController.isLoading) return;
                        if (authController.pageController.page == 8 && authController.isSE) {
                          if (authController.pageController.page == 8) {
                            Get.find<AuthController>().imageFile =
                                await Get.find<AuthController>().convertUint8ListToImageFile(await Get.find<AuthController>().screenshotController.capture());
                            Get.find<AuthController>().update();
                          }
                          authController.submitForm();
                        }
                        authController.homeButton();
                      },
                      child: const CustomImage(
                        path: Assets.imagesHomeButton,
                        height: 55,
                        width: 55,
                      ),
                    ),
                  ),

              // ----------------- Sync Button ------------------------
              if (authController.pageController.hasClients)
                if (authController.pageController.page!.round() < 2)
                  Positioned(
                    left: 48,
                    bottom: 28,
                    child: GestureDetector(
                      onTap: () async {
                        // await authController.submitForm();
                        authController.animationController.forward(from: 0).then((value) async {
                          await authController.syncData();
                        });
                      },
                      child: AnimatedBuilder(
                        animation: authController.animationController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: authController.animationController.value * 2 * 3.14159265359,
                            child: const CustomImage(
                              path: Assets.imagesSyncButton,
                              height: 55,
                              width: 55,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
            ],
          ),
        ),
      );
    });
  }
}
