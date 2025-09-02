import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/pages/home_page.dart';
import '../presentation/pages/grid_page.dart';
import '../presentation/pages/list_page.dart';
import '../presentation/pages/detail_page.dart';
import '../presentation/pages/player_page.dart';

/// App router configuration
class AppRouter {
  static GoRouter get router => GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/grid',
            name: 'grid',
            builder: (context, state) => const GridPage(),
          ),
          GoRoute(
            path: '/list',
            name: 'list',
            builder: (context, state) => const ListPage(),
          ),
          GoRoute(
            path: '/detail/:id',
            name: 'detail',
            builder: (context, state) {
              final movieId = state.pathParameters['id']!;
              return DetailPage(movieId: movieId);
            },
          ),
          GoRoute(
            path: '/player/:id',
            name: 'player',
            builder: (context, state) {
              final movieId = state.pathParameters['id']!;
              return PlayerPage(movieId: movieId);
            },
          ),
        ],
        errorBuilder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const Text('Page Not Found'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '404 - Page Not Found',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Go Home'),
                ),
              ],
            ),
          ),
        ),
      );
}
