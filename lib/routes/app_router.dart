import 'package:go_router/go_router.dart';

class AppRouter {
  // late final AppService appService;
  GoRouter get router => _goRouter;

  // AppRouter(this.appService);

  late final GoRouter _goRouter = GoRouter(
    debugLogDiagnostics: true,
    // initialLocation: DashboardHomeTab.route,
    routes: <RouteBase>[
      // START DASHBOARD
    ],
    redirect: (context, state) async {
      return null;
    },
  );
}
