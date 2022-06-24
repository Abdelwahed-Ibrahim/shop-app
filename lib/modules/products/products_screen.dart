import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_shop_app/layout/cubit/cubit.dart';
import 'package:my_shop_app/layout/cubit/states.dart';
import 'package:my_shop_app/models/shop_app/categories_model.dart';
import 'package:my_shop_app/models/shop_app/home_model.dart';
import 'package:my_shop_app/shared/styles/colors.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        return cubit.homeModel != null && cubit.categoriesModel != null
            ? homeBuilder(cubit.homeModel!, cubit.categoriesModel!,
                cubit.favorites, cubit)
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget homeBuilder(HomeModel homeModel, CategoriesModel categoriesModel,
          Map<int, dynamic> favorites, ShopCubit cubit) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: homeModel.data!.banners
                  .map((e) => Image(
                        image: NetworkImage(e.image!),
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ))
                  .toList(),
              options: CarouselOptions(
                autoPlay: true,
                autoPlayAnimationDuration: const Duration(seconds: 1),
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayCurve: Curves.fastOutSlowIn,
                viewportFraction: 1.0,
                height: 200,
                initialPage: 0,
                reverse: false,
                scrollDirection: Axis.horizontal,
                enableInfiniteScroll: true,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 22.0,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  categoriesBuilder(categoriesModel.data!.data),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'New Products',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 22.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            productsBuilder(homeModel.data!.products, favorites, cubit),
          ],
        ),
      );

  Widget categoriesBuilder(List<DataModel> categories) => SizedBox(
        height: 100,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) =>
              categoryItemBuilder(categories[index]),
          separatorBuilder: (context, index) => const SizedBox(
            width: 10,
          ),
          itemCount: categories.length,
        ),
      );

  Widget categoryItemBuilder(DataModel category) => Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image(
            image: NetworkImage(category.image!),
            width: 150,
            height: 100,
            fit: BoxFit.fill,
          ),
          Container(
            width: 150,
            color: Colors.black.withOpacity(.6),
            child: Text(
              category.name!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          )
        ],
      );

  Widget productsBuilder(List<ProductModel> products,
          Map<int, dynamic> favorites, ShopCubit cubit) =>
      Container(
        color: Colors.grey[300],
        padding: const EdgeInsets.all(3.0),
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 3.0,
          crossAxisSpacing: 3.0,
          childAspectRatio: 1 / 1.5,
          children: List.generate(
            products.length,
            (index) => productItemBuilder(products[index], favorites, cubit),
          ),
        ),
      );

  Widget productItemBuilder(
          ProductModel product, Map<int, dynamic> favorites, ShopCubit cubit) =>
      Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Center(
                  child: Image(
                    image: NetworkImage(product.image!),
                    height: 200,
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
            productDescription(product, favorites, cubit),
          ],
        ),
      );

  Widget productDescription(
          ProductModel product, Map<int, dynamic> favorites, ShopCubit cubit) =>
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  height: 1.3,
                ),
              ),
              Row(
                children: [
                  Text(
                    '\$ ${product.price!.toString()}',
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
                  if (product.discount != 0)
                    Text(
                      '\$ ${product.oldPrice!.toString()}',
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
                      backgroundColor: favorites[product.id]
                          ? defaultColor
                          : Colors.grey[200],
                      child: const Icon(
                        Icons.favorite_border,
                        // color: favorites[product.id] ? Colors.white : Colors.black,
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
