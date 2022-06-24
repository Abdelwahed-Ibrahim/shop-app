import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_shop_app/layout/cubit/cubit.dart';
import 'package:my_shop_app/layout/cubit/states.dart';
import 'package:my_shop_app/models/shop_app/categories_model.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        return cubit.categoriesModel != null
            ? buildCategories(cubit.categoriesModel!.data!.data)
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Widget buildCategoryItem(DataModel category) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Image(
              image: NetworkImage(
                category.image!,
              ),
              width: 100.0,
              height: 100.0,
              fit: BoxFit.fill,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              category.name!,
              style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      );

  Widget buildCategories(List<DataModel> categories) => ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => buildCategoryItem(categories[index]),
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsetsDirectional.only(start: 20.0),
          child: Container(
            color: Colors.grey,
            width: double.infinity,
            height: 1.0,
          ),
        ),
        itemCount: categories.length,
      );
}

// get
