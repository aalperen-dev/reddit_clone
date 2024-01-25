import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/repository/auth_repository.dart';

import '../../core/utils/utilities.dart';

final authControllerProvider = Provider((ref) {
  return ref.read(authRepositoryProvider);
});

class AuthController {
  final AuthRepository _authRepository;

  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  void signInWithGoogle(BuildContext context) async {
    final user = await _authRepository.signInWithGoogle();

    user.fold((l) => showSnackBar(context, l.message.toString()),
        (r) => showSnackBar(context, r.name));
  }
}
