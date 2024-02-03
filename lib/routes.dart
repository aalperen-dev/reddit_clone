import 'package:flutter/material.dart';
import 'package:reddit_clone/features/community/screens/community_screen.dart';
import 'package:reddit_clone/features/community/screens/create_community_screen.dart';
import 'package:reddit_clone/features/home/screens/home_screen.dart';
import 'package:reddit_clone/features/screens/login_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (route) => const MaterialPage(
          child: LoginScreen(),
        ),
  },
);

final loggedInRoute = RouteMap(
  routes: {
    '/': (route) => const MaterialPage(
          child: HomeScreen(),
        ),
    '/create-community': (route) => const MaterialPage(
          child: CreateCommunityScreen(),
        ),
    '/r/:name': (route) => MaterialPage(
          child: CommunityScreen(name: route.pathParameters['name']!),
        ),
  },
);
