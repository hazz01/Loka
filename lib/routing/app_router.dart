import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Feature imports
import '../features/home/pages/home_page.dart';
import '../features/home/pages/detail_component_page.dart';
import '../features/home/pages/virtual_tour_page.dart';
import '../features/home/pages/booking_tiket_page.dart';
import '../features/home/pages/trip_ai_planner_page.dart';
import '../features/home/pages/kategori_provinsi_page.dart';
import '../features/home/pages/kategori_greater_city_page.dart';
import '../features/home/pages/kategori_city_page.dart';
import '../features/search/pages/search_page.dart';
import '../features/saved/pages/saved_plan_page.dart';
import '../features/saved/pages/trip_plan_page.dart';
import '../features/profile/pages/profile_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Bottom Navigation Shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Home Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) => const HomePage(),
                routes: [
                  GoRoute(
                    path: 'detail/:destinationId',
                    name: 'detail',
                    builder: (context, state) {
                      final destinationId = state.pathParameters['destinationId']!;
                      return DetailComponentPage(destinationId: destinationId);
                    },
                    routes: [
                      GoRoute(
                        path: 'virtual-tour',
                        name: 'virtual-tour',
                        builder: (context, state) {
                          final destinationId = state.pathParameters['destinationId']!;
                          return VirtualTourPage(destinationId: destinationId);
                        },
                      ),
                      GoRoute(
                        path: 'booking',
                        name: 'booking',
                        builder: (context, state) {
                          final destinationId = state.pathParameters['destinationId']!;
                          return BookingTiketPage(destinationId: destinationId);
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'trip-ai-planner',
                    name: 'trip-ai-planner',
                    builder: (context, state) => const TripAIPlannerPage(),
                    routes: [
                      GoRoute(
                        path: 'provinsi',
                        name: 'kategori-provinsi',
                        builder: (context, state) => const KategoriProvinsiPage(),
                      ),
                      GoRoute(
                        path: 'greater-city',
                        name: 'kategori-greater-city',
                        builder: (context, state) => const KategoriGreaterCityPage(),
                      ),
                      GoRoute(
                        path: 'city',
                        name: 'kategori-city',
                        builder: (context, state) => const KategoriCityPage(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // Search Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                name: 'search',
                builder: (context, state) => const SearchPage(),
              ),
            ],
          ),
          // Saved Plans Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/saved',
                name: 'saved',
                builder: (context, state) => const SavedPlanPage(),
                routes: [
                  GoRoute(
                    path: 'trip/:tripId',
                    name: 'trip-plan',
                    builder: (context, state) {
                      final tripId = state.pathParameters['tripId']!;
                      return TripPlanPage(tripId: tripId);
                    },
                  ),
                ],
              ),
            ],
          ),
          // Profile Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// Bottom Navigation Bar Widget
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
