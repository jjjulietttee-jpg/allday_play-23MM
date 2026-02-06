import 'package:go_router/go_router.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/menu/menu_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/progress/progress_screen.dart';
import '../../presentation/screens/game/rhythm_game_screen.dart';
import '../../presentation/screens/game/game_tutorial_screen.dart';

/// Router: splash → onboarding or menu (by SharedPreferences).
final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/menu',
      builder: (context, state) => const MenuScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/progress',
      builder: (context, state) => const ProgressScreen(),
    ),
    GoRoute(
      path: '/game',
      builder: (context, state) => const RhythmGameScreen(),
    ),
    GoRoute(
      path: '/game-tutorial',
      builder: (context, state) => const GameTutorialScreen(),
    ),
  ],
  errorBuilder: (context, state) => const MenuScreen(),
);
