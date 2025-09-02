import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/sources/movie_remote_source.dart';
import '../data/repositories/movie_repository.dart';
import '../domain/usecases/get_home_rails.dart';
import '../presentation/viewmodels/home_vm.dart';
import '../presentation/viewmodels/grid_vm.dart';
import '../presentation/viewmodels/list_vm.dart';
import '../presentation/viewmodels/detail_vm.dart';
import '../presentation/viewmodels/player_vm.dart';

/// Dependency injection configuration
class AppDI {
  static List<ChangeNotifierProvider> get viewModelProviders => [
        // ViewModels
        ChangeNotifierProvider<HomeViewModel>(
          create: (context) => HomeViewModel(
            context.read<GetHomeRails>(),
          ),
        ),

        ChangeNotifierProvider<GridViewModel>(
          create: (context) => GridViewModel(
            context.read<MovieRepository>(),
          ),
        ),

        ChangeNotifierProvider<ListViewModel>(
          create: (context) => ListViewModel(
            context.read<MovieRepository>(),
          ),
        ),

        ChangeNotifierProvider<DetailViewModel>(
          create: (context) => DetailViewModel(
            context.read<MovieRepository>(),
          ),
        ),

        ChangeNotifierProvider<PlayerViewModel>(
          create: (context) => PlayerViewModel(
            context.read<MovieRepository>(),
          ),
        ),
      ];

  static List<Provider> get serviceProviders => [
        // Data sources
        Provider<MovieRemoteSource>(
          create: (_) => MovieRemoteSource(),
        ),

        // Repositories
        Provider<MovieRepository>(
          create: (context) => MovieRepository(
            remoteSource: context.read<MovieRemoteSource>(),
          ),
        ),

        // Use cases
        Provider<GetHomeRails>(
          create: (context) => GetHomeRails(
            context.read<MovieRepository>(),
          ),
        ),
      ];

  static List<ChangeNotifierProvider> get allProviders => [
        ...viewModelProviders,
      ];

  static List<Provider> get allServiceProviders => [
        ...serviceProviders,
      ];
}
