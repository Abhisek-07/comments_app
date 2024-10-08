import 'package:comments_app/firebase/remote_config/firebase_remote_config_keys.dart';
import 'package:comments_app/firebase/remote_config/firebase_remote_config_service.dart';
import 'package:comments_app/states/auth_state.dart';
import 'package:comments_app/states/dashboard_state.dart';
import 'package:comments_app/ui/widgets/dashboard_card.dart';
import 'package:comments_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';

class DashBoard extends HookConsumerWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remoteConfig = FirebaseRemoteConfigService();
    var maskEmail =
        useState(remoteConfig.getBool(FirebaseRemoteConfigKeys.maskEmail));
    final AuthState authState = ref.watch(authStateProvider.notifier);

    final DashboardStateModel dashboardStateModel =
        ref.watch(dashboardStateProvider);
    final DashboardState dashboardStateNotifier =
        ref.watch(dashboardStateProvider.notifier);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          dashboardStateNotifier.getComments();
          dashboardStateNotifier.getUserName();
        },
      );
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onSelected: (value) async {
              if (value == 'logout') {
                context.loaderOverlay.show();
                await authState.signOut();
                context.loaderOverlay.hide();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ];
            },
          )
        ],
        backgroundColor: AppColors.appBlue,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light),
        title: const Text(
          "Comments",
          style: TextStyle(color: AppColors.colorGreyScaleWhite),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
                onPressed: () async {
                  await remoteConfig.fetchAndActivate();
                  maskEmail.value =
                      remoteConfig.getBool(FirebaseRemoteConfigKeys.maskEmail);
                },
                child: Text("Mask email with Remote Config")),
            dashboardStateModel.comments.when(
              data: (data) {
                return Flexible(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(top: 32),
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 8,
                      );
                    },
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return DashboardCard(
                        comment: data[index],
                        maskEmail: maskEmail.value,
                      );
                    },
                  ),
                );
              },
              error: (error, stackTrace) {
                return Center(
                  child: TextButton(
                      onPressed: () {
                        dashboardStateNotifier.getComments();
                      },
                      child: const Text("Retry")),
                );
              },
              loading: () {
                return const Expanded(
                    child: Center(child: CircularProgressIndicator()));
              },
            ),
            const SizedBox(
              height: 24,
            )
          ],
        ),
      ),
    );
  }
}
