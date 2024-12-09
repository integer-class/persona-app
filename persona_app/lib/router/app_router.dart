import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/auth/login_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/home/upload_photo_screen.dart';
import '../screens/home/onboarding_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/recommendation/edit_screen.dart';
import '../screens/classify/genderselectionscreen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/history_screen.dart';
import '../screens/recommendation/accessories_screen.dart';
import '../screens/recommendation/glasses_screen.dart';
import '../screens/recommendation/hairstyle_screen.dart';
import '../screens/recommendation/feedback_screen.dart';
import '../data/datasource/remote/auth_remote_datasource.dart';
import '../data/datasource/local/auth_local_datasource.dart';
import '../data/repositories/auth_repository.dart';

part 'route_constants.dart';
part 'enums/root_tab.dart';

bool isLoggedIn = false; // Simulasi status login

Future<String?> authGuard(BuildContext context, GoRouterState state) async {
  final authRepository = AuthRepository(
    AuthRemoteDataSource(),
    AuthLocalDatasource(),
  );
  final isAuth = await authRepository.isAuth();

  if (!isAuth) {
    return RouteConstants.loginRoute;
  }
  return null;
}

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      name: RouteConstants.splashRoute,
      path: RouteConstants.splashRoute,
      builder: (context, state) => SplashScreen(),
      redirect: (context, state) async {
        final authRepository = AuthRepository(
          AuthRemoteDataSource(),
          AuthLocalDatasource(),
        );
        final isAuth = await authRepository.isAuth();

        if (isAuth) {
          isLoggedIn = true;
          return RouteConstants.uploadRoute;
        }
        return null;
      },
    ),
    GoRoute(
      name: RouteConstants.loginRoute,
      path: RouteConstants.loginRoute,
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      name: RouteConstants.uploadRoute,
      path: RouteConstants.uploadRoute,
      builder: (context, state) => UploadPhotoScreen(),
    ),
    GoRoute(
      name: RouteConstants.signupRoute,
      path: RouteConstants.signupRoute,
      builder: (context, state) => SignupScreen(),
    ),
    GoRoute(
      name: RouteConstants.onboardingRoute,
      path: RouteConstants.onboardingRoute,
      builder: (context, state) => OnboardingScreen(),
    ),
    GoRoute(
      name: RouteConstants.genderSelectionRoute,
      path: RouteConstants.genderSelectionRoute,
      builder: (context, state) => GenderSelectionScreen(),
    ),
    GoRoute(
      name: RouteConstants.editRoute,
      path: RouteConstants.editRoute,
      builder: (context, state) => EditScreen(),
    ),
    GoRoute(
      name: RouteConstants.profileRoute,
      path: RouteConstants.profileRoute,
      builder: (context, state) => ProfileScreen(),
      redirect: authGuard,
    ),
    GoRoute(
      name: RouteConstants.historyRoute,
      path: RouteConstants.historyRoute,
      builder: (context, state) => HistoryScreen(),
      redirect: authGuard,
    ),
    GoRoute(
      name: RouteConstants.accessoriesRoute,
      path: RouteConstants.accessoriesRoute,
      builder: (context, state) => AccessoriesScreen(),
    ),
    GoRoute(
      name: RouteConstants.glassesRoute,
      path: RouteConstants.glassesRoute,
      builder: (context, state) => GlassesScreen(),
    ),
    GoRoute(
      name: RouteConstants.hairstyleRoute,
      path: RouteConstants.hairstyleRoute,
      builder: (context, state) => HairstyleScreen(),
    ),
    GoRoute(
      name: RouteConstants.feedbackRoute,
      path: RouteConstants.feedbackRoute,
      builder: (context, state) => FeedbackScreen(),
      redirect: authGuard,
    ),
  ],
);
