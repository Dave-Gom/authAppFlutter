import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/router/app_router_notifier.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/products/products.dart';

final goRouterProvider = Provider(
  (ref) {
    final goRouterNotifier = ref.read(goRouterNotifierProvider);

    return GoRouter(
      initialLocation: '/checkOut',
      refreshListenable: goRouterNotifier,
      routes: [
        GoRoute(
          path: '/checkOut',
          builder: (context, state) => const CheckAuthStatusScreen(),
        ),

        ///* Auth Routes
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),

        ///* Product Routes
        GoRoute(
          path: '/',
          builder: (context, state) => const ProductsScreen(),
        ),
      ],
      redirect: (context, state) {
        final isGoingTo = state.subloc;
        final authStatus = goRouterNotifier.authStatus;
        if (isGoingTo == '/checkOut' && authStatus == AuthStatus.checking) {
          return null;
        }

        if (authStatus == AuthStatus.authenticated) {
          if (isGoingTo == '/login' || isGoingTo == '/register') {
            return null;
          } else {
            return '/login';
          }
        }

        if (authStatus == AuthStatus.authenticated) {
          if (isGoingTo == '/login' ||
              isGoingTo == '/register' ||
              isGoingTo == '/checkOut') {
            return '/';
          }
        }

        return null;
      },

      ///! TODO: Bloquear si no se está autenticado de alguna manera
    );
  },
);
