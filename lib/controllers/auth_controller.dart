import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_connect.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:movember/services/extensions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/response/response_model.dart';
import '../data/models/response/user_model.dart';
import '../data/repositories/auth_repo.dart';
import '../generated/assets.dart';
import '../main.dart';
import '../views/base/dialogs/confirmation_dialog.dart';
import '../views/base/dialogs/request_permission_dialog.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({required this.authRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  int _rating = -1;
  int get rating => _rating;
  set rating(int rate) {
    _rating = rate;
    update();
  }

  PageController pageController = PageController();

  Map<String, dynamic> data = {
    "se_name": null,
    "hq": null,
    "dr_name": null,
    "city": null,
    "description": null,
    "stars": null,
  };

  TextEditingController oneController = TextEditingController();
  TextEditingController twoController = TextEditingController();
  TextEditingController specialtyController = TextEditingController();
  TextEditingController threeController = TextEditingController();
  TextEditingController fourController = TextEditingController();
  TextEditingController feedback = TextEditingController();

  late AnimationController animationController;

  List<String> images = [
    Assets.images1,
    Assets.images2,
    Assets.images3,
    Assets.images4,
    Assets.images5,
    Assets.images6,
    Assets.images7,
    Assets.images8,
    Assets.images9,
    Assets.images10,
    Assets.images11,
    Assets.images12,
  ];

  Future<bool> connectivity() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        log('connected');

        return true;
      }
    } on SocketException catch (_) {
      log('not connected');
      return false;
    }
    return false;
  }

  File? imageFile;

  Future<bool> getPermission(Permission permission, BuildContext context, {String? message, final double? dialogHeight}) async {
    PermissionStatus? status;
    log((await permission.status).toString());
    if (!(await permission.isGranted)) {
      bool result = (await showDialog(
            context: context,
            builder: (context) {
              return RequestPermissionDialog(
                permission: permission.toString().split('.').last.toString(),
                extraMessage: message,
              );
            },
          )) ??
          false;
      if (result) {
        status = await permission.request();
      }
      log("-----$status-----", name: permission.toString());

      if (status == PermissionStatus.permanentlyDenied) {
        Fluttertoast.cancel();
        // Fluttertoast.showToast(
        //     msg: 'Open settings to give ${permission.toString().split('.').last.toString()} access', toastLength: Toast.LENGTH_LONG);
        // Fluttertoast.showToast(
        //     msg: 'Give ${permission.toString().split('.').last.toString()} access from app setting', toastLength: Toast.LENGTH_LONG);

        await showDialog(
            context: context,
            builder: (context) {
              return ConfirmationDialog(
                dialogHeight: dialogHeight,
                heading: 'Access Required',
                bodyText: 'Open app setting to give ${permission.toString().split('.').last.toString()} access',
                button1Text: 'Later',
                button2Text: 'Settings',
              );
            });
      }
    } else {
      log("-----Granted-----", name: permission.toString());
    }
    return permission.isGranted;
  }

  forwardButton() async {
    FocusScope.of(navigatorKey.currentContext!).unfocus();
    if (pageController.page! == 1 && !validatePages()) {
      return;
    } else {
      await pageController.animateToPage((pageController.page! + 1).round(), duration: const Duration(milliseconds: 50), curve: Curves.ease);
      update();
    }
  }

  Future<void> homeButton() async {
    FocusScope.of(navigatorKey.currentContext!).unfocus();
    if (pageController.page?.round() == (images.length - 1)) {
      if (validatePages()) {
        await pageController.animateToPage(0, duration: const Duration(milliseconds: 50), curve: Curves.ease);
        await submitForm();
      }
    } else {
      resetForm();
    }
  }

  bool validatePages() {
    if (pageController.page! == 0) {
      return true;
    } else if (pageController.page! == 1) {
      if (oneController.text.isValid && twoController.text.isValid && threeController.text.isValid && fourController.text.isValid) {
        return true;
      }
      Fluttertoast.showToast(msg: "Please enter all data");
      return false;
    } else if (pageController.page == (images.length - 1)) {
      if (feedback.text.isValid && _rating != -1) return true;
      Fluttertoast.showToast(msg: "Please enter experience & rating");
      return false;
    }
    return true;
  }

  resetForm() async {
    await pageController.animateToPage(0, duration: const Duration(milliseconds: 50), curve: Curves.ease);
    oneController.clear();
    twoController.clear();
    specialtyController.clear();
    threeController.clear();
    fourController.clear();
    feedback.clear();
    rating = -1;

    await pageController.animateToPage(0, duration: const Duration(milliseconds: 50), curve: Curves.ease);
    update();
  }

  submitForm() async {
    _isLoading = true;
    update();

    data['se_name'] = oneController.text;
    data['dr_name'] = twoController.text;
    data['hq'] = threeController.text;
    data['city'] = fourController.text;
    data['description'] = feedback.text;
    data['stars'] = (rating + 1).toString();
    submitDa(data).then((value) {
      if (value.isSuccess) {
        resetForm();
        animationController.forward(from: 0);
        Fluttertoast.showToast(msg: "Data saved to server");
      } else {
        SharedPreferences sharedPreferences = Get.find();
        sharedPreferences.clear();
        log('${sharedPreferences.getString('saved_data')}');
        List<dynamic> savedData = jsonDecode(sharedPreferences.getString('saved_data') ?? '[]');
        savedData.add(data);
        sharedPreferences.setString('saved_data', jsonEncode(savedData));
        resetForm();
        animationController.forward(from: 0).then((value) {
          syncData();
        });
        Fluttertoast.showToast(msg: "Data saved locally");
      }
    });
    _isLoading = false;
    update();
  }

  Future<ResponseModel> submitDa(data) async {
    ResponseModel responseModel;
    _isLoading = true;
    update();
    try {
      Response response = await authRepo.submitDa(FormData(data));
      log(response.bodyString.toString(), name: 'submitDa()');
      if (response.statusCode == 200) {
        responseModel = ResponseModel(true, '${response.body}', response.body);
        _isLoading = false;
        update();
      } else {
        _isLoading = false;
        responseModel = ResponseModel(false, response.statusText!, response.body['errors']);
        update();
      }
    } catch (e) {
      _isLoading = false;
      update();
      responseModel = ResponseModel(false, "CATCH");
      log('++++++++ ${e.toString()} ++++++++', name: "ERROR AT submitDa()");
    }

    return responseModel;
  }

  syncData() async {
    if (await connectivity()) {
      SharedPreferences sharedPreferences = Get.find();
      List<dynamic> savedData = jsonDecode(sharedPreferences.getString('saved_data') ?? '[]');
      List remaining = [];
      if (savedData.isNotEmpty) {
        log(savedData.toString(), name: "Data available");
        for (int i = savedData.length - 1; i >= 0; i--) {
          var element = savedData[i];
          log("$element", name: "Data element");

          // if (false)
          submitDa(element).then((value) {
            if (value.isSuccess) {
              log("${value.isSuccess}");
              savedData.removeAt(savedData.indexOf(element));
            } else {
              remaining.add(element);
            }
          });
        }

        Fluttertoast.showToast(msg: "Synced Successfully");
        sharedPreferences.setString('saved_data', jsonEncode(remaining));
      } else {
        Fluttertoast.showToast(msg: "Synced Successfully");
      }
    } else {
      Fluttertoast.showToast(msg: "Please connect to internet");
    }
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  bool clearSharedData() {
    return authRepo.clearSharedData();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  void setUserToken(String id) {
    authRepo.saveUserToken(id);
  }
}
