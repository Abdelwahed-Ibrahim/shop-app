import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_shop_app/layout/cubit/cubit.dart';
import 'package:my_shop_app/layout/cubit/states.dart';

import '../../models/shop_app/favorites_model.dart';
import '../../shared/styles/colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        return state is! ShopLoadingFavoritesState &&
                cubit.favoritesModel != null
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  color: Colors.grey[300],
                  padding: const EdgeInsets.all(5.0),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => productItemBuilder(
                        cubit.favoritesModel!.data!.data[index].product, cubit),
                    itemCount: cubit.favoritesModel!.data!.data.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Padding(
                      padding: const EdgeInsetsDirectional.only(start: 20.0),
                      child: Container(
                        color: Colors.grey,
                        width: double.infinity,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget productItemBuilder(Product? product, ShopCubit cubit) => Container(
        padding: const EdgeInsets.all(15.0),
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Center(
                  child: Image(
                    image: NetworkImage(product!.image!),
                    height: 150,
                    width: 150,
                  ),
                ),
                if (product.discount != 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    color: Colors.red,
                    child: const Text(
                      'DISCOUNT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
              ],
            ),
            productDescription(product, cubit),
          ],
        ),
      );

  Widget productDescription(Product? product, ShopCubit cubit) => Expanded(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product!.name != null ? product.name! : 'Product Name',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  height: 1.3,
                ),
              ),
              Row(
                children: [
                  Text(
                    product.price != null
                        ? '\$ ${product.price!.toString()}'
                        : 'Product Price',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  if (product.oldPrice != null && product.discount != 0)
                    Text(
                      product.oldPrice != null
                          ? '\$ ${product.oldPrice!.toString()}'
                          : 'Product Old Price',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                          decoration: TextDecoration.lineThrough),
                    ),
                  const Spacer(),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      // ToDo: handel Favorites Pressed Button.
                      if (kDebugMode) {
                        print('Favourite Pressed');
                      }
                      cubit.changeFavorites(product.id!);
                    },
                    constraints: const BoxConstraints(
                      maxHeight: 25,
                      maxWidth: 25,
                    ),
                    icon: CircleAvatar(
                      backgroundColor: cubit.favorites[product.id!]!
                          ? defaultColor
                          : Colors.grey[200],
                      child: const Icon(
                        Icons.favorite_border,
                        size: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
