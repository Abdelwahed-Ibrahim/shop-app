import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_shop_app/layout/cubit/cubit.dart';
import 'package:my_shop_app/layout/cubit/states.dart';
import 'package:my_shop_app/shared/components/components.dart';

var nameController = TextEditingController();
var emailController = TextEditingController();
var phoneController = TextEditingController();
var imageUrl = 'https://student.valuxapps.com/storage/assets/defaults/user.jpg';
var formKey = GlobalKey<FormState>();

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        // ShopCubit cubit = ShopCubit.get(context);
        // if (cubit.userModel != null) {
        //   nameController.text = cubit.userModel!.data!.name!;
        //   emailController.text = cubit.userModel!.data!.email!;
        //   phoneController.text = cubit.userModel!.data!.phone!;
        // }
      },
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        if (cubit.userModel != null) {
          nameController.text = cubit.userModel!.data!.name!;
          emailController.text = cubit.userModel!.data!.email!;
          phoneController.text = cubit.userModel!.data!.phone!;
          imageUrl = cubit.userModel!.data!.image!;
        }
        return cubit.userModel != null
            ? Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (state is ShopLoadingUpdateUserDataState)
                    const LinearProgressIndicator(),
                  const SizedBox(
                    height: 15.0,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50.0,
                    child: Image(
                      image: NetworkImage(imageUrl),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  cubit.allowEditingName
                      ? defaultTextField(
                    controller: nameController,
                    hintText: 'Name',
                    prefixIcon: Icons.person,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name Must not be Empty';
                      }
                      return null;
                    },
                    autoFocus: true,
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Name: ',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.pinkAccent,
                        ),
                      ),
                      Text(nameController.text),
                      const Spacer(),
                      IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            cubit.allowingEditName();
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.pinkAccent,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  cubit.allowEditingEmail
                      ? defaultTextField(
                    controller: emailController,
                    hintText: 'Email Address',
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'E-mail Must not be Empty';
                      }
                      return null;
                    },
                    autoFocus: true,
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'E-Mail: ',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.pinkAccent,
                        ),
                      ),
                      Text(emailController.text),
                      const Spacer(),
                      IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            cubit.allowingEditEmail();
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.pinkAccent,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  cubit.allowEditingPhone
                      ? defaultTextField(
                    controller: phoneController,
                    hintText: 'Phone',
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Phone Must not be Empty';
                      }
                      return null;
                    },
                    autoFocus: true,
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Phone: ',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.pinkAccent,
                        ),
                      ),
                      Text(phoneController.text),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            cubit.allowingEditPhone();
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.pinkAccent,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  if (cubit.allowEditingName ||
                      cubit.allowEditingEmail ||
                      cubit.allowEditingPhone)
                    defaultButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          cubit.updateUserData(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                          );
                        }
                      },
                      defaultText: 'Submit',
                    ),
                  logOutButton(context),
                ],
              ),
            ),
          ),
        )
            : const Center(
          child: CircularProgressIndicator(),
        );

        // return SingleChildScrollView(
        //   child: Padding(
        //     padding: const EdgeInsets.all(20.0),
        //     child: Column(
        //       children: [
        //         if (state is ShopLoadingUpdateUserDataState)
        //           const LinearProgressIndicator(),
        //         CircleAvatar(
        //           backgroundColor: Colors.white,
        //           radius: 50.0,
        //           child: Image(
        //             image: NetworkImage(imageUrl),
        //           ),
        //         ),
        //         const SizedBox(
        //           height: 20.0,
        //         ),
        //         cubit.allowEditingName
        //             ? defaultTextField(
        //                 controller: nameController,
        //                 hintText: 'Name',
        //                 prefixIcon: Icons.person,
        //                 validator: (value) {
        //                   if (value!.isEmpty) {
        //                     return 'Name Must not be Empty';
        //                   }
        //                   return null;
        //                 },
        //                 autoFocus: true,
        //               )
        //             : Row(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   const Text(
        //                     'Name: ',
        //                     style: TextStyle(
        //                       fontSize: 18.0,
        //                       fontWeight: FontWeight.w800,
        //                       color: Colors.pinkAccent,
        //                     ),
        //                   ),
        //                   Text(nameController.text),
        //                   const Spacer(),
        //                   IconButton(
        //                       padding: EdgeInsets.zero,
        //                       onPressed: () {
        //                         cubit.allowingEditName();
        //                       },
        //                       icon: const Icon(
        //                         Icons.edit,
        //                         color: Colors.pinkAccent,
        //                       ))
        //                 ],
        //               ),
        //         const SizedBox(
        //           height: 20.0,
        //         ),
        //         cubit.allowEditingEmail
        //             ? defaultTextField(
        //                 controller: emailController,
        //                 hintText: 'Email Address',
        //                 prefixIcon: Icons.email,
        //                 validator: (value) {
        //                   if (value!.isEmpty) {
        //                     return 'E-mail Must not be Empty';
        //                   }
        //                   return null;
        //                 },
        //                 autoFocus: true,
        //               )
        //             : Row(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   const Text(
        //                     'E-Mail: ',
        //                     style: TextStyle(
        //                       fontSize: 18.0,
        //                       fontWeight: FontWeight.w800,
        //                       color: Colors.pinkAccent,
        //                     ),
        //                   ),
        //                   Text(emailController.text),
        //                   const Spacer(),
        //                   IconButton(
        //                       padding: EdgeInsets.zero,
        //                       onPressed: () {
        //                         cubit.allowingEditEmail();
        //                       },
        //                       icon: const Icon(
        //                         Icons.edit,
        //                         color: Colors.pinkAccent,
        //                       ))
        //                 ],
        //               ),
        //         const SizedBox(
        //           height: 20.0,
        //         ),
        //         cubit.allowEditingPhone
        //             ? defaultTextField(
        //                 controller: phoneController,
        //                 hintText: 'Phone',
        //                 prefixIcon: Icons.phone,
        //                 validator: (value) {
        //                   if (value!.isEmpty) {
        //                     return 'Phone Must not be Empty';
        //                   }
        //                   return null;
        //                 },
        //                 autoFocus: true,
        //               )
        //             : Row(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   const Text(
        //                     'Phone: ',
        //                     style: TextStyle(
        //                       fontSize: 18.0,
        //                       fontWeight: FontWeight.w800,
        //                       color: Colors.pinkAccent,
        //                     ),
        //                   ),
        //                   Text(phoneController.text),
        //                   const Spacer(),
        //                   IconButton(
        //                       onPressed: () {
        //                         cubit.allowingEditPhone();
        //                       },
        //                       icon: const Icon(
        //                         Icons.edit,
        //                         color: Colors.pinkAccent,
        //                       ))
        //                 ],
        //               ),
        //         const SizedBox(
        //           height: 20.0,
        //         ),
        //         if (cubit.allowEditingName ||
        //             cubit.allowEditingEmail ||
        //             cubit.allowEditingPhone)
        //           defaultButton(
        //             onPressed: () {
        //               cubit.updateUserData(
        //                 name: nameController.text,
        //                 email: emailController.text,
        //                 phone: phoneController.text,
        //               );
        //             },
        //             defaultText: 'Submit',
        //           ),
        //         logOutButton(context),
        //       ],
        //     ),
        //   ),
        // );
      },
    );
  }
}

Widget logOutButton(context) =>
    defaultTextButton(onPressed: () => signOut(context), text: 'LogOut');
