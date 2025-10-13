import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
                      final destinationId =
                          state.pathParameters['destinationId']!;
                      return DetailComponentPage(destinationId: destinationId);
                    },
                    routes: [
                      GoRoute(
                        path: 'virtual-tour',
                        name: 'virtual-tour',
                        builder: (context, state) {
                          final destinationId =
                              state.pathParameters['destinationId']!;
                          return VirtualTourPage(destinationId: destinationId);
                        },
                      ),
                      GoRoute(
                        path: 'booking',
                        name: 'booking',
                        builder: (context, state) {
                          final destinationId =
                              state.pathParameters['destinationId']!;
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
                        builder: (context, state) =>
                            const KategoriProvinsiPage(),
                      ),
                      GoRoute(
                        path: 'greater-city',
                        name: 'kategori-greater-city',
                        builder: (context, state) =>
                            const KategoriGreaterCityPage(),
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
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    // Responsive sizing
    final navBarHeight = isTablet ? 110.0 : (isLargeScreen ? 120.0 : 100.0);
    final iconPadding = isTablet ? 16.0 : (isLargeScreen ? 20.0 : 12.0);
    final iconSize = isTablet ? 32.0 : (isLargeScreen ? 36.0 : 28.0);
    final fontSize = isTablet ? 14.0 : (isLargeScreen ? 16.0 : 12.0);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        height: navBarHeight,
        decoration: const BoxDecoration(color: Color(0xFFF4F4F4)),
        child: SafeArea(
          child: BottomNavigationBar(
            backgroundColor: const Color(0xFFF4F4F4),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            currentIndex: navigationShell.currentIndex,
            onTap: (index) => navigationShell.goBranch(index),
            selectedItemColor: const Color(0xFF539DF3),
            unselectedItemColor: const Color(0xFF484C52),
            iconSize: iconSize,
            selectedLabelStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelStyle: TextStyle(fontSize: fontSize),
            items: [
              _buildNavBarItem(
                icon: LucideIcons.house,
                isActive: navigationShell.currentIndex == 0,
                padding: iconPadding,
                label: isLargeScreen ? 'Home' : '',
              ),
              _buildNavBarItem(
                icon: LucideIcons.search,
                isActive: navigationShell.currentIndex == 1,
                padding: iconPadding,
                label: isLargeScreen ? 'Search' : '',
              ),
              _buildNavBarItem(
                icon: LucideIcons.bookmark,
                isActive: navigationShell.currentIndex == 2,
                padding: iconPadding,
                label: isLargeScreen ? 'Saved' : '',
              ),
              _buildNavBarItem(
                icon: LucideIcons.user,
                isActive: navigationShell.currentIndex == 3,
                padding: iconPadding,
                label: isLargeScreen ? 'Profile' : '',
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavBarItem({
    required IconData icon,
    required bool isActive,
    required double padding,
    required String label,
  }) {
    final iconWidget = Container(
      padding: EdgeInsets.all(padding),
      decoration: isActive
          ? const BoxDecoration(
              color: Color(0xFFBED7F4),
              shape: BoxShape.circle,
            )
          : null,
      child: Icon(icon),
    );

    return BottomNavigationBarItem(
      icon: iconWidget,
      activeIcon: iconWidget,
      label: label,
    );
  }
}
