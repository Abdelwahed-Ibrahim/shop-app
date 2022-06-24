import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_shop_app/models/shop_app/login_model.dart';
import 'package:my_shop_app/modules/shop_register_screen/cubit/states.dart';
import 'package:my_shop_app/shared/network/end_points.dart';
import 'package:my_shop_app/shared/network/remote/dio_helper.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterInitialState());

  static ShopRegisterCubit get(context) => BlocProvider.of(context);

  IconData icon = Icons.visibility;
  bool isPassword = true;
  late ShopLoginModel loginModel;

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(ShopRegisterLoadingState());
    DioHelper.postData(
      url: REGISTER,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      },
    ).then((value) {
      if (kDebugMode) {
        print(value.data);
      }
      loginModel = ShopLoginModel.fromJSON(value.data);
      emit(ShopRegisterSuccessState(loginModel));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopRegisterErrorState(error.toString()));
    });
  }

  void changePasswordIcon() {
    isPassword = !isPassword;
    icon = isPassword ? Icons.visibility : Icons.visibility_off;
    emit(ShopRegisterChangeSuffixIconState());
  }
}
