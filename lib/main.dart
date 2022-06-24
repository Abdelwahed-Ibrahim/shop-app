import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_shop_app/layout/cubit/cubit.dart';
import 'package:my_shop_app/layout/shop_layout.dart';
import 'package:my_shop_app/modules/login_screen/login_screen.dart';
import 'package:my_shop_app/shared/components/constants.dart';

import 'modules/on_boarding/on_boarding_screen.dart';
import 'shared/bloc_observer.dart';
import 'shared/components/components.dart';
import 'shared/network/local/cache_helper.dart';
import 'shared/network/remote/dio_helper.dart';

void main() async {
  BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      DioHelper.init();
      await CacheHelper.init();
      bool? isDark = CacheHelper.getBoolean(key: 'isDark');
      isDark ??= false;
      bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
      onBoarding ??= false;
      token = CacheHelper.getData(key: 'token');
      // TODO: remove this statement latter
      if (kDebugMode) {
        print('Token = $token');
      }
      // token = 'pPYheSMnk4CQuQ5ug6fhlQ5ZXi6QKagyh6bkjmkwxCbSbfInrmvF5wrMApv7VFGTs1sRX8';
      Widget screen = const OnBoardingScreen();
      if (onBoarding) {
        if (token != null) {
          screen = const ShopLayoutScreen();
        } else {
          screen = const ShopLoginScreen();
        }
      }
      runApp(MyApp(isDark, screen));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Widget screen;

  const MyApp(this.isDark, this.screen, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider(
      create: (context) => ShopCubit()
        ..getHomeData()
        ..getCategories()
        ..getFavorites()
        ..getUserData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: screen,
        theme: myTheme(false),
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        darkTheme: myTheme(true),
      ),
    );
  }
}
