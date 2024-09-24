import 'package:comments_app/states/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';

class DashBoard extends ConsumerWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: SizedBox(
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "dashboard",
                style: TextStyle(color: Colors.black),
              ),
              ElevatedButton(
                  onPressed: () async {
                    context.loaderOverlay.show();
                    await authState.signOut();
                    context.loaderOverlay.hide();
                  },
                  child: const Text("Logout"))
            ],
          ),
        ),
      ),
    );
  }
}
