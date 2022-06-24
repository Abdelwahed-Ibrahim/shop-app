import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_shop_app/layout/cubit/states.dart';
import 'package:my_shop_app/models/shop_app/categories_model.dart';
import 'package:my_shop_app/models/shop_app/change_favorites_model.dart';
import 'package:my_shop_app/models/shop_app/home_model.dart';
import 'package:my_shop_app/models/shop_app/login_model.dart';
import 'package:my_shop_app/modules/categories/categories_screen.dart';
import 'package:my_shop_app/modules/favorites/favorites_screen.dart';
import 'package:my_shop_app/modules/products/products_screen.dart';
import 'package:my_shop_app/modules/settings/settings_screen.dart';
import 'package:my_shop_app/shared/components/components.dart';
import 'package:my_shop_app/shared/components/constants.dart';
import 'package:my_shop_app/shared/network/end_points.dart';
import 'package:my_shop_app/shared/network/remote/dio_helper.dart';

import '../../models/shop_app/favorites_model.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(BuildContext context) => BlocProvider.of(context);

  int currentIndex = 0;
  bool allowEditingName = false;
  bool allowEditingEmail = false;
  bool allowEditingPhone = false;

  List<Widget> screens = const [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void allowingEditName() {
    allowEditingName = true;
    emit(ShopChangeNameState());
  }

  void allowingEditEmail() {
    allowEditingEmail = true;
    emit(ShopChangePhoneState());
  }

  void allowingEditPhone() {
    allowEditingPhone = true;
    emit(ShopChangeEmailState());
  }

  void changeBottomIndex(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavBarState());
  }

  HomeModel? homeModel;
  Map<int, bool> favorites = {};

  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(url: HOME, token: token).then((value) {
      homeModel = HomeModel.fromJSON(value.data);
      for (var element in homeModel!.data!.products) {
        favorites.addAll({
          element.id!: element.inFavorites!,
        });
      }
      // if (kDebugMode) {
      //   print(homeModel!.data);
      // }
      emit(ShopSuccessLoadingHomeDataState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorLoadingHomeDataState(error.toString()));
    });
  }

  CategoriesModel? categoriesModel;

  void getCategories() {
    DioHelper.getData(
      url: GET_CATEGORIES,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJSON(value.data);

      emit(ShopSuccessLoadingCategoriesState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorLoadingCategoriesState(error.toString()));
    });
  }

  late ChangeFavoritesModel changeFavoritesModel;

  void changeFavorites(int id) {
    favorites[id] = !favorites[id]!;
    emit(ShopLoadingChangeFavoritesState());
    DioHelper.postData(
      url: FAVORITES,
      token: token,
      data: {
        'product_id': id,
      },
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJSON(value.data);
      if (!changeFavoritesModel.status) {
        favorites[id] = !favorites[id]!;
        emit(ShopErrorChangeFavoritesState(changeFavoritesModel.message));
      } else {
        emit(ShopSuccessChangeFavoritesState());
        getFavorites();
      }
    }).catchError((error) {
      favorites[id] = !favorites[id]!;
      emit(ShopErrorChangeFavoritesState(error.toString()));
    });
  }

  FavoritesModel? favoritesModel;

  void getFavorites() {
    emit(ShopLoadingFavoritesState());
    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJSON(value.data);
      if (!favoritesModel!.status!) {
        emit(ShopErrorLoadingFavoritesState(favoritesModel!.message!));
      } else {
        emit(ShopSuccessLoadingFavoritesState());
      }
    }).catchError((error) {
      emit(ShopErrorLoadingFavoritesState(error.toString()));
    });
  }

  ShopLoginModel? userModel;

  void getUserData() {
    emit(ShopLoadingSettingState());
    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userModel = ShopLoginModel.fromJSON(value.data);
      if (!userModel!.status!) {
        emit(ShopErrorLoadingSettingState(userModel!.message!));
      } else {
        emit(ShopSuccessLoadingSettingState(userModel!));
      }
    }).catchError((error) {
      emit(ShopErrorLoadingSettingState(error.toString()));
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopLoadingUpdateUserDataState());
    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      if (!value.data['status']) {
        print(value.data['message']);
        showToast(message: value.data['message'], state: ToastStates.ERROR);
        emit(ShopErrorUpdateUserDataState(userModel!.message!));
      } else {
        userModel = ShopLoginModel.fromJSON(value.data);
        allowEditingName = allowEditingEmail = allowEditingPhone = false;
        emit(ShopSuccessUpdateUserDataState());
      }
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateUserDataState(error.toString()));
    });
  }
}
