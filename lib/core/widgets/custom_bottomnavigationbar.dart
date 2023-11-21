import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tutachef_project/controllers/home_controller.dart';

import '../app_core.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key, required this.controller});
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          width: double.infinity,
          height: 65,
          decoration: const BoxDecoration(
              gradient: AppCore.defaultOrangeGradient,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: Observer(
            builder: (_) {
              return BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                currentIndex: controller.indexHome,
                onTap: (int index) {
                  controller.selectIndex(index);
                  print('printou ${controller.indexHome}');
                },
                backgroundColor: Colors.transparent,
                type: BottomNavigationBarType.fixed,
                unselectedIconTheme: const IconThemeData(color: Colors.white),
                selectedIconTheme:
                    const IconThemeData(color: Color(0xFFFFD180)),
                iconSize: 30,
                elevation: 0,
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: '',
                  ),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.search), label: ''),
                  BottomNavigationBarItem(
                      icon: SizedBox(
                          height: 30,
                          width: 30,
                          child: controller.indexHome == 2
                              ? Image.asset(
                                  'assets/icons/selected_add_recipe.png')
                              : Image.asset('assets/icons/add_recipe.png')),
                      label: ''),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.star_border), label: ''),
                ],
              );
            },
          )),
    );
  }
}
