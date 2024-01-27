// loggedOut
// loggedIn

import 'package:flutter/material.dart';
import 'package:reddit_clone/features/screens/login_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (route) => const MaterialPage(
          child: LoginScreen(),
        ),
  },
);
