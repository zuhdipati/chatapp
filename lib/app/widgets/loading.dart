import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomLoadingWidget extends StatelessWidget {
  const BottomLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.white : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: const SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('Loading...'),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showLoading() async {
  Get.bottomSheet(
    const BottomLoadingWidget(),
    isDismissible: false,
    enableDrag: false,
    useRootNavigator: true,
  );
}

void hideLoading() {
  Get.back();
}
