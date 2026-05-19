import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/entities/auth_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository repository})
      : _repository = repository,
        super(const AuthState.unknown()) {
    on<AuthStarted>(_onStarted);
    on<SignupRequested>(_onSignup);
    on<SigninRequested>(_onSignin);
    on<SignoutRequested>(_onSignout);
    on<ResendConfirmationRequested>(_onResend);
    on<_AuthUserChanged>(_onUserChanged);
    on<ProfileFound>(_onProfileFound);
    on<ProfileMissing>(_onProfileMissing);

    // اشتراك في Supabase auth state stream
    _userSub = _repository.authStateChanges.listen((user) {
      add(_AuthUserChanged(user));
    });
  }

  final AuthRepository _repository;
  late final StreamSubscription<AuthUser?> _userSub;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final user = _repository.currentUser;
    if (user == null) {
      emit(const AuthState.unauthenticated());
    } else if (!user.isEmailConfirmed) {
      emit(AuthState.awaitingConfirmation(user));
    } else {
      // محتاج ProfileBloc يلوّد ويبعت ProfileFound أو ProfileMissing
      emit(AuthState.authenticatedNoProfile(user));
    }
  }

  Future<void> _onSignup(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.processing());
    final result = await _repository.signUp(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(const AuthState.unauthenticated().withFailure(failure)),
      (user) => emit(AuthState.awaitingConfirmation(user)),
    );
  }

  Future<void> _onSignin(
    SigninRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.processing());
    final result = await _repository.signIn(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(const AuthState.unauthenticated().withFailure(failure)),
      (user) {
        if (!user.isEmailConfirmed) {
          emit(AuthState.awaitingConfirmation(user));
        } else {
          // ProfileBloc هياخدها من هنا
          emit(AuthState.authenticatedNoProfile(user));
        }
      },
    );
  }

  Future<void> _onSignout(
    SignoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.processing(user: state.user));
    final result = await _repository.signOut();
    result.fold(
      (failure) => emit(state.withFailure(failure)),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }

  Future<void> _onResend(
    ResendConfirmationRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _repository.resendConfirmation(event.email);
    result.fold(
      (failure) => emit(state.withFailure(failure)),
      (_) => emit(state.clearFailure()),
    );
  }

  Future<void> _onUserChanged(
    _AuthUserChanged event,
    Emitter<AuthState> emit,
  ) async {
    final user = event.user;
    if (user == null) {
      emit(const AuthState.unauthenticated());
    } else if (!user.isEmailConfirmed) {
      emit(AuthState.awaitingConfirmation(user));
    } else if (state.status != AuthStatus.authenticated) {
      // مر بـ NoProfile الأول، ProfileBloc يقرر بعدين
      emit(AuthState.authenticatedNoProfile(user));
    }
  }

  Future<void> _onProfileFound(
    ProfileFound event,
    Emitter<AuthState> emit,
  ) async {
    if (state.user != null) {
      emit(AuthState.authenticated(state.user!));
    }
  }

  Future<void> _onProfileMissing(
    ProfileMissing event,
    Emitter<AuthState> emit,
  ) async {
    if (state.user != null) {
      emit(AuthState.authenticatedNoProfile(state.user!));
    }
  }

  @override
  Future<void> close() {
    _userSub.cancel();
    return super.close();
  }
}
