import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_shop_app/layout/shop_layout.dart';
import 'package:my_shop_app/modules/login_screen/cubit/cubit.dart';
import 'package:my_shop_app/modules/login_screen/cubit/states.dart';
import 'package:my_shop_app/modules/shop_register_screen/shop_register_screen.dart';
import 'package:my_shop_app/shared/components/components.dart';
import 'package:my_shop_app/shared/components/constants.dart';
import 'package:my_shop_app/shared/network/local/cache_helper.dart';

import '../../shared/styles/colors.dart';

var emailController = TextEditingController();
var passwordController = TextEditingController();
var formKey = GlobalKey<FormState>();

class ShopLoginScreen extends StatelessWidget {
  const ShopLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {
          if (state is ShopLoginSuccessState) {
            if (state.loginModel.status!) {
              showToast(
                message: state.loginModel.message!,
                state: ToastStates.SUCCESS,
              );
              if (kDebugMode) {
                print(state.loginModel.message);
                print(state.loginModel.data!.token);
              }
              CacheHelper.setData(
                key: 'token',
                value: state.loginModel.data!.token,
              ).then((value) {
                token = state.loginModel.data!.token;
                navigateAndFinish(
                  context,
                  const ShopLayoutScreen(),
                );
              });
            } else {
              showToast(
                message: state.loginModel.message!,
                state: ToastStates.ERROR,
              );
              if (kDebugMode) {
                print(state.loginModel.message);
              }
            }
          }
          if (state is ShopLoginErrorState) {
            showToast(
              message: state.error,
              state: ToastStates.ERROR,
            );
          }
        },
        builder: (context, state) {
          ShopLoginCubit cubit = ShopLoginCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    color: defaultColor,
                                    fontSize: 34.0,
                                  ),
                        ),
                        Text(
                          'Login now to browse our hot offers',
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    fontSize: 20.0,
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultTextField(
                          controller: emailController,
                          hintText: 'Email Address',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email must not be empty';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultTextField(
                          controller: passwordController,
                          hintText: 'Password',
                          isPassword: cubit.isPassword,
                          prefixIcon: Icons.lock_outline,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password is too short';
                            }
                            return null;
                          },
                          suffixIcon: cubit.icon,
                          onSuffixPressed: cubit.changePasswordIcon,
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {
                              cubit.userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        (state is! ShopLoginLoadingState)
                            ? defaultButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.userLogin(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                  }
                                },
                                defaultText: 'login',
                              )
                            : const Center(child: CircularProgressIndicator()),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'don\'t have an account yet?',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    fontSize: 20.0,
                                  ),
                            ),
                            defaultTextButton(
                              onPressed: () {
                                navigateAndFinish(
                                  context,
                                  const ShopRegisterScreen(),
                                );
                              },
                              text: 'register',
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
