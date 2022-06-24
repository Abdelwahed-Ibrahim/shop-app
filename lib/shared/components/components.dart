import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_shop_app/shared/components/constants.dart';

import '../../modules/login_screen/login_screen.dart';
import '../network/local/cache_helper.dart';
import '../styles/colors.dart';

ThemeData myTheme(bool isDark) => ThemeData(
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: isDark ? const Color(0xff333739) : Colors.white,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        titleSpacing: 20.0,
        color: isDark ? const Color(0xff333739) : Colors.white,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        elevation: 0.0,
      ),
      textTheme: TextTheme(
        bodyText1: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      primarySwatch: Colors.pink,
      scaffoldBackgroundColor: isDark ? const Color(0xff333739) : Colors.white,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 20.0,
        backgroundColor: isDark ? const Color(0xff333734) : Colors.white,
        selectedItemColor: defaultColor,
        unselectedItemColor: Colors.grey,
      ),
    );

void navigateTo(BuildContext context, Widget myNavigation) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => myNavigation,
      ),
    );

void navigateAndFinish(BuildContext context, Widget myNavigation) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => myNavigation,
      ),
      (route) => false,
    );

Widget defaultTextButton({
  required Function() onPressed,
  required String text,
}) =>
    TextButton(
      onPressed: onPressed,
      child: Text(text.toUpperCase()),
    );

Widget defaultTextField({
  required TextEditingController controller,
  required String hintText,
  required IconData prefixIcon,
  IconData? suffixIcon,
  TextInputType? keyboardType,
  String? Function(String?)? validator,
  void Function()? onSuffixPressed,
  void Function(String)? onSubmit,
  bool isPassword = false,
  bool autoFocus = false,
}) =>
    TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      obscureText: isPassword,
      autofocus: autoFocus,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: defaultColor),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(3.0)),
          borderSide: BorderSide(color: defaultColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: defaultColor),
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: defaultColor,
        ),
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: onSuffixPressed,
                icon: Icon(
                  suffixIcon,
                  color: defaultColor,
                ),
              )
            : null,
      ),
      textAlign: TextAlign.center,
      validator: validator,
      onFieldSubmitted: onSubmit,
    );

Widget defaultButton({
  required void Function() onPressed,
  required String defaultText,
}) =>
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      clipBehavior: Clip.antiAlias,
      width: double.infinity,
      child: MaterialButton(
        child: Text(
          defaultText.toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
        onPressed: onPressed,
        color: defaultColor,
        height: 40.0,
      ),
    );

void showToast({required String message, required ToastStates state}) =>
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );

// ignore: constant_identifier_names
enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

void signOut(BuildContext context) {
  CacheHelper.removeData(key: 'token').then((value) {
    if (value) {
      token = null;
      navigateAndFinish(context, const ShopLoginScreen());
    }
  });
}

Widget searchTextFormField({
  required TextEditingController controller,
  required IconData prefixIcon,
  required String hint,
  required BuildContext context,
  bool isAutoFocus = false,
  bool isReadOnly = false,
  String? Function(String?)? validation,
  Function()? onTouch,
  Function(String)? onChange,
}) =>
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: TextFormField(
        style: Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(fontWeight: FontWeight.normal),
        cursorColor: Colors.black,
        controller: controller,
        textAlign: TextAlign.center,
        readOnly: isReadOnly,
        autofocus: isAutoFocus,
        validator: validation,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.black,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
        ),
        onTap: onTouch,
        onChanged: onChange,
      ),
    );
