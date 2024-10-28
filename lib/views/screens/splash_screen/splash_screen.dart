import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

import '../../../controllers/auth_controller.dart';
import '../../../main.dart';
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

  Future<void> _pickImage(ImageSource source, String? assets) async {
    log(assets!);
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

        if (pickedFile != null) {
          Get.find<AuthController>().imageFile = pickedFile;
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
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage(
              Assets.imagesBackground,
            ),
          )),
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
                  if (index == 1) {
                    return const FormScreen();
                  }

                  return CustomImage(
                    path: authController.images[index],
                    width: size.width,
                    height: size.height,
                    fit: BoxFit.fitWidth,
                  );
                },
              ),

              if (authController.pageController.hasClients)
                if (authController.pageController.page?.round() == 7) ...[
                  Positioned(
                      top: 360,
                      left: 110,
                      child: GestureDetector(
                        onTap: () async {
                          if (!(await Permission.camera.status.isGranted)) {
                            await Permission.camera.request();
                          } else {
                            _pickImage(ImageSource.camera, Assets.images12);
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
                                  Get.find<AuthController>().imageFile!,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            CustomImage(
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
                          authController.submitForm();
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
                    right: 48,
                    bottom: 28,
                    child: GestureDetector(
                      onTap: () async {
                        authController.isSE = true;
                        authController.forwardButton();
                      },
                      child: const CustomImage(
                        path: Assets.imagesFIELD,
                        height: 55,
                        width: 55,
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
