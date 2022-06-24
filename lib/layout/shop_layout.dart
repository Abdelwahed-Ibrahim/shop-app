import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_shop_app/layout/cubit/cubit.dart';
import 'package:my_shop_app/layout/cubit/states.dart';
import 'package:my_shop_app/modules/search/search_screen.dart';
import 'package:my_shop_app/shared/components/components.dart';

class ShopLayoutScreen extends StatelessWidget {
  const ShopLayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopErrorLoadingHomeDataState) {
          if (kDebugMode) {
            print(state.error);
          }
        } else if (state is ShopErrorLoadingCategoriesState) {
          if (kDebugMode) {
            print(state.error);
          }
        } else if (state is ShopErrorChangeFavoritesState) {
          if (kDebugMode) {
            print(state.error);
          }
        } else if (state is ShopErrorLoadingFavoritesState) {
          if (kDebugMode) {
            print(state.error);
          }
        } else if (state is ShopErrorLoadingSettingState) {
          if (kDebugMode) {
            print(state.error);
          }
        }
      },
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Shopping'),
            actions: [
              IconButton(
                onPressed: () {
                  navigateTo(
                    context,
                    const SearchScreen(),
                  );
                },
                icon: const Icon(
                  Icons.search,
                ),
              ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            // type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomIndex(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.apps,
                ),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite,
                ),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                ),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
