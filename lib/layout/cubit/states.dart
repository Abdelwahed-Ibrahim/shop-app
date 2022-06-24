import '../../models/shop_app/login_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ShopChangeBottomNavBarState extends ShopStates {}

class ShopChangeNameState extends ShopStates {}

class ShopChangeEmailState extends ShopStates {}

class ShopChangePhoneState extends ShopStates {}

class ShopLoadingUpdateUserDataState extends ShopStates {}

class ShopSuccessUpdateUserDataState extends ShopStates {}

class ShopErrorUpdateUserDataState extends ShopStates {
  final String error;

  ShopErrorUpdateUserDataState(this.error);
}

class ShopLoadingHomeDataState extends ShopStates {}

class ShopSuccessLoadingHomeDataState extends ShopStates {}

class ShopErrorLoadingHomeDataState extends ShopStates {
  final String error;

  ShopErrorLoadingHomeDataState(this.error);
}

class ShopSuccessLoadingCategoriesState extends ShopStates {}

class ShopErrorLoadingCategoriesState extends ShopStates {
  final String error;

  ShopErrorLoadingCategoriesState(this.error);
}

class ShopLoadingChangeFavoritesState extends ShopStates {}

class ShopSuccessChangeFavoritesState extends ShopStates {}

class ShopErrorChangeFavoritesState extends ShopStates {
  final String error;

  ShopErrorChangeFavoritesState(this.error);
}

class ShopLoadingFavoritesState extends ShopStates {}

class ShopSuccessLoadingFavoritesState extends ShopStates {}

class ShopErrorLoadingFavoritesState extends ShopStates {
  final String error;

  ShopErrorLoadingFavoritesState(this.error);
}

class ShopLoadingSettingState extends ShopStates {}

class ShopSuccessLoadingSettingState extends ShopStates {
  final ShopLoginModel userData;

  ShopSuccessLoadingSettingState(this.userData);
}

class ShopErrorLoadingSettingState extends ShopStates {
  final String error;

  ShopErrorLoadingSettingState(this.error);
}
