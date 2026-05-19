import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/core/errors/failures.dart';
import 'package:wasalni/features/profile/data/repositories/profile_repository.dart';
import 'package:wasalni/features/profile/domain/entities/profile.dart';
import 'package:wasalni/features/profile/presentation/bloc/profile_bloc.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository repository;

  Profile fakeProfile() => Profile(
        id: 'u-1',
        fullName: 'يوسف التهامي',
        phone: '+201012345678',
        governorate: 'الدقهلية',
        cityOrVillage: 'كفر المقدام',
        createdAt: DateTime.parse('2026-05-19'),
        updatedAt: DateTime.parse('2026-05-19'),
      );

  setUp(() {
    repository = MockProfileRepository();
  });

  group('ProfileBloc — LoadProfile', () {
    blocTest<ProfileBloc, ProfileState>(
      'emits [loading, loaded] when profile exists',
      build: () {
        when(() => repository.getProfile(any()))
            .thenAnswer((_) async => Right(fakeProfile()));
        return ProfileBloc(repository: repository);
      },
      act: (bloc) => bloc.add(const LoadProfile('u-1')),
      expect: () => [
        predicate<ProfileState>((s) => s.status == ProfileStatus.loading),
        predicate<ProfileState>(
          (s) => s.status == ProfileStatus.loaded && s.profile == fakeProfile(),
        ),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [loading, notFound] when profile missing',
      build: () {
        when(() => repository.getProfile(any()))
            .thenAnswer((_) async => const Right(null));
        return ProfileBloc(repository: repository);
      },
      act: (bloc) => bloc.add(const LoadProfile('u-1')),
      expect: () => [
        predicate<ProfileState>((s) => s.status == ProfileStatus.loading),
        predicate<ProfileState>((s) => s.status == ProfileStatus.notFound),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [loading, error] on repository failure',
      build: () {
        when(() => repository.getProfile(any())).thenAnswer(
          (_) async => const Left(ProfileFailure('فشل التحميل')),
        );
        return ProfileBloc(repository: repository);
      },
      act: (bloc) => bloc.add(const LoadProfile('u-1')),
      expect: () => [
        predicate<ProfileState>((s) => s.status == ProfileStatus.loading),
        predicate<ProfileState>(
          (s) =>
              s.status == ProfileStatus.error &&
              s.failure?.message == 'فشل التحميل',
        ),
      ],
    );
  });

  group('ProfileBloc — CreateProfileRequested', () {
    blocTest<ProfileBloc, ProfileState>(
      'emits [saving, loaded] on successful create without avatar',
      build: () {
        when(() => repository.createProfile(
              userId: any(named: 'userId'),
              fullName: any(named: 'fullName'),
              phone: any(named: 'phone'),
              governorate: any(named: 'governorate'),
              cityOrVillage: any(named: 'cityOrVillage'),
              avatarUrl: any(named: 'avatarUrl'),
              birthDate: any(named: 'birthDate'),
            )).thenAnswer((_) async => Right(fakeProfile()));
        return ProfileBloc(repository: repository);
      },
      act: (bloc) => bloc.add(const CreateProfileRequested(
        userId: 'u-1',
        fullName: 'يوسف التهامي',
        phone: '+201012345678',
        governorate: 'الدقهلية',
        cityOrVillage: 'كفر المقدام',
      )),
      expect: () => [
        predicate<ProfileState>((s) => s.status == ProfileStatus.saving),
        predicate<ProfileState>(
          (s) => s.status == ProfileStatus.loaded && s.profile == fakeProfile(),
        ),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [saving, error] on create failure',
      build: () {
        when(() => repository.createProfile(
              userId: any(named: 'userId'),
              fullName: any(named: 'fullName'),
              phone: any(named: 'phone'),
              governorate: any(named: 'governorate'),
              cityOrVillage: any(named: 'cityOrVillage'),
              avatarUrl: any(named: 'avatarUrl'),
              birthDate: any(named: 'birthDate'),
            )).thenAnswer(
          (_) async =>
              const Left(ProfileFailure('رقم الموبايل ده مستخدم بالفعل')),
        );
        return ProfileBloc(repository: repository);
      },
      act: (bloc) => bloc.add(const CreateProfileRequested(
        userId: 'u-1',
        fullName: 'يوسف التهامي',
        phone: '+201012345678',
        governorate: 'الدقهلية',
        cityOrVillage: 'كفر المقدام',
      )),
      expect: () => [
        predicate<ProfileState>((s) => s.status == ProfileStatus.saving),
        predicate<ProfileState>(
          (s) =>
              s.status == ProfileStatus.error &&
              s.failure?.message.contains('مستخدم') == true,
        ),
      ],
    );
  });
}
