import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/common/sign_in_button.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';

import '../../../core/constants/assets.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void _signInAsguest(
    WidgetRef ref,
    BuildContext context,
  ) {
    ref.read(authControllerProvider.notifier).signInAsguest(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          Assets.imagesLogo,
          height: 40,
        ),
        actions: [
          TextButton(
            onPressed: () => _signInAsguest(ref, context),
            child: const Text(
              'Skip',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    'Dive into anything',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      Assets.imagesLoginEmote,
                      height: 270,
                    ),
                  ),
                  //
                  const SizedBox(height: 30),
                  //
                  const SignInButton(),
                ],
              ),
            ),
    );
  }
}
