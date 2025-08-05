import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/app_providers.dart';
import 'routing/app_router.dart';
import 'ui/core/auth/cubit/auth_cubit.dart';
import 'ui/core/theme/cubit/theme_cubit.dart';

void main() {
  runApp(const TaskcyApp());
}

class TaskcyApp extends StatelessWidget {
  const TaskcyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppProviders.providers,
      child: Builder(
        builder: (context) {
          final authCubit = context.read<AuthCubit>();
          
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp.router(
                title: 'Taskcy',
                theme: themeState.currentTheme,
                routerConfig: createAppRouter(authCubit),
                debugShowCheckedModeBanner: false,
              );
            },
          );
        },
      ),
    );
  }
}