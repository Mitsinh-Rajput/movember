import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

import '../../../controllers/auth_controller.dart';
import '../../../services/input_decoration.dart';
import '../../base/custom_image.dart';

class LastPage extends StatefulWidget {
  const LastPage({super.key});

  @override
  State<LastPage> createState() => _LastPageState();
}

class _LastPageState extends State<LastPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<AuthController>().rating = -1;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<AuthController>(builder: (authController) {
      return SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                Assets.assetsImagesPage2,
              ),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 110,
                right: 0,
                child: SizedBox(
                  width: size.width * .5,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: List.generate(5, (index) {
                      return CustomImage(
                        onTap: () {
                          authController.rating = index;
                        },
                        path: index > authController.rating ? Assets.imagesStarEmpty : Assets.imagesStarFilled,
                        width: 160,
                      );
                    }),
                  ),
                ),
              ),
              Positioned(
                bottom: 105,
                left: 96,
                right: 96,
                child: TextFormField(
                  controller: authController.feedback,
                  maxLines: 6,
                  decoration: CustomDecoration.inputDecoration(
                    borderRadius: 33,
                    borderColor: Colors.black38,
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
