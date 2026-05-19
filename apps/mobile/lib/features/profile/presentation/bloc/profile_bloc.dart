import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../data/repositories/profile_repository.dart';
import '../../domain/entities/profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required ProfileRepository repository})
      : _repository = repository,
        super(const ProfileState.initial()) {
    on<LoadProfile>(_onLoad);
    on<CreateProfileRequested>(_onCreate);
    on<UpdateProfileRequested>(_onUpdate);
    on<ProfileCleared>(_onClear);
  }

  final ProfileRepository _repository;

  Future<void> _onLoad(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(const ProfileState.loading());
    final result = await _repository.getProfile(event.userId);
    result.fold(
      (failure) => emit(const ProfileState.initial().withError(failure)),
      (profile) {
        if (profile == null) {
          emit(const ProfileState.notFound());
        } else {
          emit(ProfileState.loaded(profile));
        }
      },
    );
  }

  Future<void> _onCreate(
    CreateProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileState.saving());

    // 1) لو في صورة، نرفعها الأول
    String? avatarUrl;
    if (event.avatarFile != null) {
      final upload = await _repository.uploadAvatar(
        userId: event.userId,
        file: event.avatarFile!,
      );
      final failure = upload.fold<Failure?>((f) => f, (_) => null);
      if (failure != null) {
        emit(const ProfileState.initial().withError(failure));
        return;
      }
      avatarUrl = upload.getRight().toNullable();
    }

    // 2) إنشاء row البروفايل
    final result = await _repository.createProfile(
      userId: event.userId,
      fullName: event.fullName.trim(),
      phone: event.phone,
      governorate: event.governorate,
      cityOrVillage: event.cityOrVillage.trim(),
      avatarUrl: avatarUrl,
      birthDate: event.birthDate,
    );
    result.fold(
      (failure) => emit(const ProfileState.initial().withError(failure)),
      (profile) => emit(ProfileState.loaded(profile)),
    );
  }

  Future<void> _onUpdate(
    UpdateProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final current = state.profile;
    emit(ProfileState.saving(profile: current));

    String? avatarUrl;
    if (event.avatarFile != null) {
      final upload = await _repository.uploadAvatar(
        userId: event.userId,
        file: event.avatarFile!,
      );
      final failure = upload.fold<Failure?>((f) => f, (_) => null);
      if (failure != null) {
        emit(state.withError(failure));
        return;
      }
      avatarUrl = upload.getRight().toNullable();
    }

    final result = await _repository.updateProfile(
      userId: event.userId,
      fullName: event.fullName?.trim(),
      phone: event.phone,
      governorate: event.governorate,
      cityOrVillage: event.cityOrVillage?.trim(),
      avatarUrl: avatarUrl,
      birthDate: event.birthDate,
    );
    result.fold(
      (failure) => emit(state.withError(failure)),
      (profile) => emit(ProfileState.loaded(profile)),
    );
  }

  Future<void> _onClear(
    ProfileCleared event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileState.initial());
  }
}
