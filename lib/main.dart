import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/user_repository.dart';
import 'presentation/bloc/profile_bloc.dart';
import 'presentation/bloc/profile_event.dart';

/// Global Talker instance for logging (optional)
final talker = TalkerFlutter.init();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final userRepository = UserRepository(prefs);
  
  // Configure Talker for optional logging
  FlutterError.onError = (details) => talker.handle(
        details.exception,
        details.stack,
        details.summary.toString(),
      );

  runApp(MyApp(userRepository: userRepository));
}

/// Root application widget
class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  
  const MyApp({super.key, required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<UserRepository>.value(
      value: userRepository,
      child: BlocProvider(
        create: (context) =>
            ProfileBloc(context.read<UserRepository>())..add(const LoadProfile()),
        child: MaterialApp.router(
          title: 'AllDay Play',
          theme: appTheme,
          routerConfig: appRouter,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
