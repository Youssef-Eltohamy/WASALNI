import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/profile.dart';
import '../bloc/session_cubit.dart';

/// On OTP success: set the session and return to where the user came from.
void signInAndReturn(BuildContext context, Profile profile, String? from) {
  context.read<SessionCubit>().signIn(profile);
  context.go(from ?? '/account');
}
