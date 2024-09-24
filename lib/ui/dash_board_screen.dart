import 'package:comments_app/states/auth_state.dart';
import 'package:comments_app/states/dashboard_state.dart';
import 'package:comments_app/ui/widgets/dashboard_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';

class DashBoard extends HookConsumerWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            icon: Icon(Icons.settings),
            onSelected: (value) async {
              if (value == 'logout') {
                context.loaderOverlay.show();
                await authState.signOut();
                context.loaderOverlay.hide();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ];
            },
          )
        ],
        backgroundColor: Colors.blue,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light),
        title: const Text("Comments"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          dashboardStateModel.currentUser.when(
            data: (data) {
              return Text(
                  (data?.userName ?? "null") + " " + (data?.email ?? "NULL"));
            },
            error: (error, stackTrace) {
              return const SizedBox.shrink();
            },
            loading: () {
              return const Expanded(
                  child: Center(child: CircularProgressIndicator()));
            },
          ),
          const SizedBox(
            height: 16,
          ),
          dashboardStateModel.comments.when(
            data: (data) {
              return Flexible(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return DashboardCard(comment: data[index].name);
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
                    child: Text("Retry")),
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
    );
  }
}
