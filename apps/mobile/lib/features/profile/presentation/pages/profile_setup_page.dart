import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/routing/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/validators/phone_validator.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../data/repositories/profile_repository.dart';
import '../bloc/profile_bloc.dart';
import '../cubit/profile_form/profile_form_cubit.dart';
import '../widgets/governorate_dropdown.dart';

class ProfileSetupPage extends StatelessWidget {
  const ProfileSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProfileBloc(repository: ProfileRepository()),
        ),
        BlocProvider(create: (_) => ProfileFormCubit()),
      ],
      child: const _SetupView(),
    );
  }
}

class _SetupView extends StatelessWidget {
  const _SetupView();

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final userId = authState.user?.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('بياناتك الشخصية'),
        automaticallyImplyLeading: false,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProfileBloc, ProfileState>(
            listenWhen: (p, c) => p.status != c.status,
            listener: (context, state) {
              final formCubit = context.read<ProfileFormCubit>();
              if (state.status == ProfileStatus.saving) {
                formCubit.setSubmitting(true);
              } else if (state.status == ProfileStatus.loaded) {
                formCubit.setSuccess();
                context.read<AuthBloc>().add(const ProfileFound());
                context.go(RoutePaths.feed);
              } else if (state.status == ProfileStatus.error &&
                  state.failure != null) {
                formCubit.setError(state.failure!.message);
              }
            },
          ),
        ],
        child: BlocBuilder<ProfileFormCubit, ProfileFormState>(
          builder: (context, formState) {
            final cubit = context.read<ProfileFormCubit>();
            return SafeArea(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'كمل بياناتك',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'البيانات دي بتساعدنا نوصلك للمحلات والخدمات القريبة منك',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    const SizedBox(height: 24),
                    _AvatarPickerCircle(
                      file: formState.avatarFile,
                      onChanged: cubit.avatarChanged,
                    ),
                    const SizedBox(height: 24),
                    AppTextField(
                      label: 'الاسم الكامل',
                      onChanged: cubit.fullNameChanged,
                      errorText: formState.fullName.errorMessage(
                        formState.fullName.displayError,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'رقم الموبايل',
                      keyboardType: TextInputType.phone,
                      hint: '01XXXXXXXXX',
                      onChanged: cubit.phoneChanged,
                      errorText:
                          PhoneInput.errorMessage(formState.phone.displayError),
                    ),
                    const SizedBox(height: 16),
                    GovernorateDropdown(
                      value: formState.governorate,
                      onChanged: cubit.governorateChanged,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'المدينة أو القرية',
                      onChanged: cubit.cityOrVillageChanged,
                      errorText: formState.cityOrVillage.errorMessage(
                        formState.cityOrVillage.displayError,
                      ),
                    ),
                    if (formState.errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          formState.errorMessage!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: 'احفظ وابدأ',
                      isLoading: formState.isSubmitting,
                      onPressed: formState.isValid && userId != null
                          ? () => context.read<ProfileBloc>().add(
                                CreateProfileRequested(
                                  userId: userId,
                                  fullName: formState.fullName.value,
                                  phone: cubit.normalizedPhone!,
                                  governorate: formState.governorate!.nameAr,
                                  cityOrVillage: formState.cityOrVillage.value,
                                  avatarFile: formState.avatarFile,
                                  birthDate: formState.birthDate,
                                ),
                              )
                          : null,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AvatarPickerCircle extends StatelessWidget {
  const _AvatarPickerCircle({required this.file, required this.onChanged});

  final File? file;
  final ValueChanged<File?> onChanged;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (image != null) onChanged(File(image.path));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 56,
              backgroundColor: AppColors.surfaceVariant,
              backgroundImage: file != null ? FileImage(file!) : null,
              child: file == null
                  ? const Icon(
                      Icons.person,
                      size: 56,
                      color: AppColors.textHint,
                    )
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
