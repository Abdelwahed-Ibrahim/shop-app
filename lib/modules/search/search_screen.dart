import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_shop_app/layout/cubit/cubit.dart';
import 'package:my_shop_app/layout/cubit/states.dart';
import 'package:my_shop_app/modules/search/cubit/cubit.dart';
import 'package:my_shop_app/modules/search/cubit/states.dart';
import 'package:my_shop_app/shared/components/components.dart';

import '../../models/shop_app/search_model.dart';
import '../../shared/styles/colors.dart';

var searchController = TextEditingController();

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopSearchCubit(),
      child: Scaffold(
        body: BlocConsumer<ShopSearchCubit, ShopSearchStates>(
          listener: (context, state) {},
          builder: (context, state) {
            ShopSearchCubit cubit = ShopSearchCubit.get(context);
            return SafeArea(
              child: BlocConsumer<ShopCubit, ShopStates>(
                listener: (context, shopState) {},
                builder: (context, shopState) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: searchTextFormField(
                            controller: searchController,
                            prefixIcon: Icons.search,
                            hint: 'Search',
                            context: context,
                            isAutoFocus: true,
                            onChange: (value) {
                              cubit.searchText(value);
                            }),
                      ),
                      if (state is ShopSearchLoadingState)
                        const Center(child: LinearProgressIndicator()),
                      buildSearchBody(context, cubit, state),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget buildSearchBody(
        BuildContext context, ShopSearchCubit cubit, ShopSearchStates state) =>
    cubit.model != null
        ? Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                color: Colors.grey[300],
                padding: const EdgeInsets.all(5.0),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => productItemBuilder(
                      cubit.model!.data!.data[index], context),
                  itemCount: cubit.model!.data!.data.length,
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
            ),
          )
        : Container();

Widget productItemBuilder(Product? product, BuildContext context) => Container(
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
              if (product.discount != 0 && product.discount != null)
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
          productDescription(product, ShopCubit.get(context)),
        ],
      ),
    );

Widget productDescription(Product? product, ShopCubit shopCubit) => Expanded(
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
                    shopCubit.changeFavorites(product.id!);
                  },
                  constraints: const BoxConstraints(
                    maxHeight: 25,
                    maxWidth: 25,
                  ),
                  icon: CircleAvatar(
                    backgroundColor: shopCubit.favorites[product.id!]!
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
