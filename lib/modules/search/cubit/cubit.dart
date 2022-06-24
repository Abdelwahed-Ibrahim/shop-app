import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_shop_app/models/shop_app/search_model.dart';
import 'package:my_shop_app/modules/search/cubit/states.dart';
import 'package:my_shop_app/shared/network/end_points.dart';
import 'package:my_shop_app/shared/network/remote/dio_helper.dart';

class ShopSearchCubit extends Cubit<ShopSearchStates> {
  ShopSearchCubit() : super(ShopSearchInitialState());

  static ShopSearchCubit get(context) => BlocProvider.of(context);

  SearchModel? model;

  void searchText(String text) {
    emit(ShopSearchLoadingState());
    DioHelper.postData(
      url: SEARCH,
      data: {
        'text': text,
      },
    ).then((value) {
      model = SearchModel.fromJSON(value.data);
      if (!value.data['status']) {
        emit(ShopSearchErrorState(value.data['message']));
      } else {
        model = SearchModel.fromJSON(value.data);
        emit(ShopSearchSuccessState());
      }
    }).catchError((error) {
      emit(ShopSearchErrorState(error.toString()));
    });
  }
}
