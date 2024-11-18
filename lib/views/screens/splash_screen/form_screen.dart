import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../services/constants.dart';
import '../../../services/input_decoration.dart';

class FormScreen extends StatelessWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<AuthController>(
      builder: (authController) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: size.height * 0.2,
              ),
              SizedBox(
                width: size.width * .7,
                child: Row(
                  children: [
                    SizedBox(
                      width: size.width * .18,
                      child: const Text(
                        "SE Name",
                        style: TextStyle(fontFamily: AppConstants.fontName2, fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: authController.oneController,
                        decoration: CustomDecoration.inputDecoration(borderColor: Colors.black45),
                      ),
                    ),
                  ],
                ),
              ),
              // const Spacer(),

              // const Spacer(),
              SizedBox(
                height: size.height * 0.09,
              ),
              SizedBox(
                width: size.width * .7,
                child: Row(
                  children: [
                    SizedBox(
                      width: size.width * .18,
                      child: const Text(
                        "HQ",
                        style: TextStyle(fontFamily: AppConstants.fontName2, fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: authController.twoController,
                        decoration: CustomDecoration.inputDecoration(borderColor: Colors.black45),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.09,
              ),
              SizedBox(
                width: size.width * .7,
                child: Row(
                  children: [
                    SizedBox(
                      width: size.width * .18,
                      child: const Text(
                        "REGION",
                        style: TextStyle(fontFamily: AppConstants.fontName2, fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: authController.fourController,
                        decoration: CustomDecoration.inputDecoration(borderColor: Colors.black45),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.09,
              ),
              if (!Get.find<AuthController>().isSE)
                SizedBox(
                  width: size.width * .7,
                  child: Row(
                    children: [
                      SizedBox(
                        width: size.width * .18,
                        child: const Text(
                          "DR. NAME",
                          style: TextStyle(fontFamily: AppConstants.fontName2, fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: authController.threeController,
                          decoration: CustomDecoration.inputDecoration(borderColor: Colors.black45),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
