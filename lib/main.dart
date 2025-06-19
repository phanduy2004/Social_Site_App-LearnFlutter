import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_site_app/core/get_it/get_it.dart';
import 'package:social_site_app/features/auth/presentation/bloc/user_event.dart';
import 'package:social_site_app/features/auth/presentation/bloc/user_state.dart';
import 'package:social_site_app/features/auth/presentation/page/auth_page.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/user_bloc.dart';
import 'features/main/presentation/bloc/main_bloc.dart';
import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setup();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) =>
        getIt<UserBloc>()
          ..add(GetUserEvent()),
      ),
      BlocProvider(
        create: (context) => getIt<MainBloc>(),
      ),
    ],
    child: MaterialApp.router(
      theme: AppTheme.getTheme(),
      builder: (context, widget) {
        return BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state.status == UserStatus.error ||
                state.status == UserStatus.logout) {
              AppRouter.router.go(AuthPage.route);
            }
          },
          child: Center(child: widget),
        );
      },
      routerConfig: AppRouter.router,
    ),
  ));
}
