import 'package:booking_clinics_doctor/core/common/custom_image.dart';
import 'package:booking_clinics_doctor/core/common/loading_indicator.dart';
import 'package:booking_clinics_doctor/features/profile/manager/image_manager/pick_image_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import '../../../core/helper/logout_btn_sheet.dart';
import 'edit_your_profile.dart';
import '../manager/profile_manager/profile_cubit.dart';
import '../widget/custom_expansion.dart';
import 'package:booking_clinics_doctor/core/constant/extension.dart';
import 'package:booking_clinics_doctor/core/constant/const_color.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: const Alignment(0, 0.25),
        child: SingleChildScrollView(
          child: BlocConsumer<ProfileCubit, ProfileState>(
            listener: (_, state) {
              if (state is UpdateProfileLoading) {}
            },
            builder: (_, state) {
              if (state is ProfileSuccess) {
                return Column(
                  children: [
                    Text("Profile", style: context.semi20),
                    SizedBox(height: 2.h),
                    Stack(
                      children: [
                        CustomImage(image: state.model.imageUrl),
                        Positioned(
                          right: 0,
                          bottom: 1.w,
                          child: Container(
                            height: 4.h,
                            width: 4.h,
                            decoration: BoxDecoration(
                              color: ConstColor.main.color,
                              borderRadius: BorderRadius.circular(3.w),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                await navToEditPage(context, state.model.email);
                              },
                              color: Colors.white,
                              iconSize: 5.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(state.model.name, style: context.bold16),
                    SizedBox(height: 0.5.h),
                    Text(
                      state.model.email,
                      style: context.medium14?.copyWith(
                        fontSize: 14.5.sp,
                        color: ConstColor.icon.color,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // List of settings
                    const CustomExpansionList(),
                    // Log Out
                    ListTile(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return const LogoutBottomSheet();
                          },
                        );
                      },
                      title: Text(
                        "Log Out",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      leading: const Icon(Icons.logout_outlined),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 0.5.h,
                        horizontal: 6.w,
                      ),
                    ),
                  ],
                );
              } else if (state is ProfileFailure) {
                return Center(
                  child: Text(state.error, style: context.semi16),
                );
              } else if (state is ProfileLoading) {
                return const LoadingIndicator();
              } else {
                return const Center();
              }
            },
          ),
        ),
      ),
    );
  }

  Future<dynamic> navToEditPage(BuildContext context, String email) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<ProfileCubit>.value(
                value: context.read<ProfileCubit>(),
              ),
              BlocProvider<PickImageCubit>(
                create: (_) => PickImageCubit(),
              ),
            ],
            child: EditYourProfile(email: email),
          );
        },
      ),
    );
  }
}
