import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:tutachef_project/controllers/home_controller.dart';
import 'package:tutachef_project/core/widgets/custom_appbar.dart';
import 'package:tutachef_project/core/widgets/custom_bottomnavigationbar.dart';
import 'package:tutachef_project/core/widgets/custom_drawer.dart';
import 'package:tutachef_project/views/favorites/favorites_view.dart';
import 'package:tutachef_project/views/home/home_view.dart';
import 'package:tutachef_project/views/profile/user.dart';
import 'package:tutachef_project/views/search/search_view.dart';

import 'recipe/add_recipe_view.dart';

class PagesView extends StatelessWidget {
  PagesView({super.key, required this.controller});
  HomeController controller;

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<HomeController>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);

    final List<Widget> pages = [
      HomeView(
        controller: controller,
        user: user,
      ),
      const SearchView(),
      const AddRecipeView(),
      FavoritesView(
        controller: controller,
        user: user,
      ),
    ];
    return Scaffold(
      appBar: CustomAppBarWidget(
        controller: controller,
      ),
      endDrawer: CustomDrawer(
        controller: controller,
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomNavigationBar(
        controller: controller,
      ),
      body: Observer(
        builder: (_) {
          return pages[controller.indexHome];
        },
      ),
    );
  }
}
