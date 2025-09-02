import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'di.dart';
import 'router.dart';
import 'theme.dart';

/// Main app configuration
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ...AppDI.allServiceProviders,
        ...AppDI.allProviders,
      ],
      child: MaterialApp.router(
        title: 'ATV Flutter',
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
