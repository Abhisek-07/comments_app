import 'package:comments_app/states/auth_state.dart';
import 'package:comments_app/ui/auth_screen.dart';
import 'package:comments_app/ui/dash_board_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authenticatedUserStream = ref.watch(authStateProvider);
    return authenticatedUserStream.when(
      data: (data) {
        if (context.loaderOverlay.visible) {
          context.loaderOverlay.hide();
        }
        FlutterNativeSplash.remove();
        if (data != null) {
          return const DashBoard();
        } else {
          return const AuthScreen();
        }
      },
      error: (error, stackTrace) {
        if (context.loaderOverlay.visible) {
          context.loaderOverlay.hide();
        }
        FlutterNativeSplash.remove();
        return const AuthScreen();
      },
      loading: () {
        if (context.loaderOverlay.visible) {
          context.loaderOverlay.hide();
        }
        FlutterNativeSplash.remove();
        return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Text("Splash"),
          ),
        );
      },
    );
  }
}
