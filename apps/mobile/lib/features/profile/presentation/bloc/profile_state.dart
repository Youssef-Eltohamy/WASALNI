part of 'profile_bloc.dart';

enum ProfileStatus {
  initial,
  loading,
  loaded,
  notFound,
  saving,
  error,
}

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.failure,
  });

  final ProfileStatus status;
  final Profile? profile;
  final Failure? failure;

  const ProfileState.initial() : this();
  const ProfileState.loading({Profile? profile})
      : this(status: ProfileStatus.loading, profile: profile);
  const ProfileState.loaded(Profile profile)
      : this(status: ProfileStatus.loaded, profile: profile);
  const ProfileState.notFound() : this(status: ProfileStatus.notFound);
  const ProfileState.saving({Profile? profile})
      : this(status: ProfileStatus.saving, profile: profile);

  ProfileState withError(Failure failure) =>
      ProfileState(status: ProfileStatus.error, profile: profile, failure: failure);

  @override
  List<Object?> get props => [status, profile, failure];
}
