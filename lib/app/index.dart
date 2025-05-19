import 'package:chatapp/app/controllers/main_controller.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:chatapp/app/services/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = MainController.to;

    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        children: controller.navigationPages,
        onPageChanged: (value) {
          controller.tabIndex.value = value;
        },
      ),
      bottomNavigationBar: Obx(
        () => BottomAppBar(
          height: 70,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 50,
                  width: Get.width * 0.15,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      navHome,
                      colorFilter: ColorFilter.mode(
                        controller.tabIndex.value == 0
                            ? controller.isDarkMode.value
                                ? Colors.black
                                : Colors.white
                            : Colors.grey,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () {
                      controller.tabIndex.value = 0;
                      controller.pageController.jumpToPage(0);
                    },
                  ),
                ),
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white),
                      onPressed: () {
                        Get.toNamed(Routes.search);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          Text("New Chat"),
                        ],
                      )),
                ),
                SizedBox(
                  height: 50,
                  width: Get.width * 0.15,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      navProfile,
                      colorFilter: ColorFilter.mode(
                        controller.tabIndex.value == 0
                            ? Colors.grey
                            : controller.isDarkMode.value
                                ? Colors.black
                                : Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () {
                      controller.tabIndex.value = 1;
                      controller.pageController.jumpToPage(1);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
