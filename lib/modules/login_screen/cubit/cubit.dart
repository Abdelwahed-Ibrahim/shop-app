import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_shop_app/models/shop_app/login_model.dart';
import 'package:my_shop_app/modules/login_screen/cubit/states.dart';
import 'package:my_shop_app/shared/network/end_points.dart';
import 'package:my_shop_app/shared/network/remote/dio_helper.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  IconData icon = Icons.visibility;
  bool isPassword = true;
  late ShopLoginModel loginModel;

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(ShopLoginLoadingState());
    DioHelper.postData(
      url: LOGIN,
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {
      if (kDebugMode) {
        print(value.data);
      }
      loginModel = ShopLoginModel.fromJSON(value.data);
      emit(ShopLoginSuccessState(loginModel));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopLoginErrorState(error.toString()));
    });
  }

  void changePasswordIcon() {
    isPassword = !isPassword;
    icon = isPassword ? Icons.visibility : Icons.visibility_off;
    emit(ShopLoginChangeSuffixIconState());
  }
}
