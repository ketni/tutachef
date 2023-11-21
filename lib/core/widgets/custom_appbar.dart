import 'package:flutter/material.dart';
import 'package:tutachef_project/core/app_core.dart';
import 'package:tutachef_project/views/login/login_view.dart';

import '../../controllers/home_controller.dart';

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  CustomAppBarWidget({super.key, this.height = 90, required this.controller});
  double height;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: height,
        decoration:
            const BoxDecoration(gradient: AppCore.defaultOrangeGradient),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                  height: height * 0.6,
                  child: Image.asset('assets/icons/icon-tutachef.png')),
            ),
            Row(
              children: [
                TextButton(
                  child: const Text(
                    'Entre na sua\n cozinha!',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LoginView(
                            controller: controller,
                          ))),
                ),
                DrawerButton(
                  style: ButtonStyle(
                      iconColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}
