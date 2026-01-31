import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loka/features/user-pengelolaUsaha/auth/auth_choosen_page.dart';
import 'package:loka/features/user-pengelolaUsaha/auth/splash-screen/splash_screen_manager.dart';
import 'package:loka/features/user-wisata/home/pages/loading_screen.dart';
import 'package:loka/features/splash-screen-utama/splash_page.dart';
import 'package:loka/features/splash-screen-utama/choose_role_page.dart';
import 'package:loka/features/user-wisata/home/pages/timeline_trip_Page.dart';
import 'package:loka/features/user-wisata/home/models/trip_response_model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// Traveler Feature imports
import '../features/user-wisata/home/pages/home_page.dart';
import '../features/user-wisata/home/pages/detail_component_page.dart';
import '../features/user-wisata/home/pages/virtual_tour_page.dart';
import '../features/user-wisata/home/pages/booking_tiket_page.dart';
import '../features/user-wisata/home/pages/trip_ai_planner_page.dart';
import '../features/user-wisata/home/pages/kategori_provinsi_page.dart';
import '../features/user-wisata/home/pages/kategori_greater_city_page.dart';
import '../features/user-wisata/home/pages/kategori_city_page.dart';
import '../features/user-wisata/home/pages/explore_page.dart';
import '../features/user-wisata/search/pages/search_page.dart';
import '../features/user-wisata/saved/pages/saved_plan_page.dart';
import '../features/user-wisata/profile/pages/profile_page.dart';
import '../features/user-wisata/profile/pages/transaction_history_page.dart';
import '../features/user-wisata/profile/pages/previous_trips_page.dart';
import '../features/user-wisata/profile/pages/favorite_trips_page.dart';

// Manager Feature imports
import '../features/user-pengelolaUsaha/dashboard/pages/manager_dashboard_page.dart';
import '../features/user-pengelolaUsaha/daftar-wisata/pages/manager_destinations_page.dart';
import '../features/user-pengelolaUsaha/analisis/pages/manager_analytics_page.dart';
import '../features/user-pengelolaUsaha/tiket/pages/manager_tickets_page.dart';
import '../features/user-pengelolaUsaha/account/pages/manager_account_page.dart';
import '../features/user-pengelolaUsaha/auth/splash-screen/splash_screen_manager.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/choose-role',
        name: 'choose-role',
        builder: (context, state) => const ChooseRolePage(),
      ),

      // Manager Onboarding/Splash Screen
      GoRoute(
        path: '/manager-onboarding',
        name: 'manager-onboarding',
        builder: (context, state) => const SplashScreenManager(),
      ),

      // ========== TRAVELER ROUTES ==========
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
      // Routes without navbar - outside StatefulShellRoute
      GoRoute(
        path: '/transaction-history',
        name: 'transaction-history',
        builder: (context, state) => const TransactionHistoryPage(),
      ),
      GoRoute(
        path: '/previous-trips',
        name: 'previous-trips',
        builder: (context, state) => const PreviousTripsPage(),
      ),
      GoRoute(
        path: '/favorite-trips',
        name: 'favorite-trips',
        builder: (context, state) => const FavoriteTripsPage(),
      ),
      GoRoute(
        path: '/explore/:category',
        name: 'explore',
        builder: (context, state) {
          final category = state.pathParameters['category']!;
          return ExplorePage(category: category);
        },
      ),
      GoRoute(
        path: '/detail/:destinationId',
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
        path: '/trip-ai-planner',
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
          GoRoute(
            path: 'loading',
            name: 'kategori-loading',
            builder: (context, state) => const LoadingScreen(),
          ),
          GoRoute(
            path: 'timeline',
            name: 'timeline-trip',
            builder: (context, state) {
              final tripResponse = state.extra as TripResponse?;
              return TimelineTripPage(tripResponse: tripResponse);
            },
          ),
        ],
      ),

      // ========== MANAGER ROUTES ==========
      // Bottom Navigation Shell for Manager
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ManagerScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Dashboard Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/manager',
                name: 'manager-dashboard',
                builder: (context, state) => const ManagerDashboardPage(),
              ),
            ],
          ),
          // Destinations Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/manager/destinations',
                name: 'manager-destinations',
                builder: (context, state) => const ManagerDestinationsPage(),
              ),
            ],
          ),
          // Analytics Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/manager/analytics',
                name: 'manager-analytics',
                builder: (context, state) => const ManagerAnalyticsPage(),
              ),
            ],
          ),
          // Tickets Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/manager/tickets',
                name: 'manager-tickets',
                builder: (context, state) => const ManagerTicketsPage(),
              ),
            ],
          ),
          // Account Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/manager/account',
                name: 'manager-account',
                builder: (context, state) => const ManagerAccountPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/splashscreen/pertama',
        name: 'splashscreen-pertama',
        builder: (context, state) => SplashScreenManager(),
      ),
      GoRoute(
        path: '/auth-manager',
        name: 'auth-manager',
        builder: (context, state) => AuthChoosenPageManager(),
        routes: [
          
        ]
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
    final isSmallScreen = screenWidth < 600;
    final scale = isSmallScreen ? 0.85 : (screenWidth / 375).clamp(0.85, 1.1);

    // Responsive sizing
    final navBarHeight = isSmallScreen ? 80.0 : 90.0;
    final iconPadding = isSmallScreen ? 10.0 : 14.0;
    final iconSize = (24 * scale).clamp(22.0, 30.0);
    final fontSize = (12 * scale).clamp(11.0, 14.0);

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
                label: '',
              ),
              _buildNavBarItem(
                icon: LucideIcons.search,
                isActive: navigationShell.currentIndex == 1,
                padding: iconPadding,
                label: '',
              ),
              _buildNavBarItem(
                icon: LucideIcons.bookmark,
                isActive: navigationShell.currentIndex == 2,
                padding: iconPadding,
                label: '',
              ),
              _buildNavBarItem(
                icon: LucideIcons.user,
                isActive: navigationShell.currentIndex == 3,
                padding: iconPadding,
                label: '',
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

// ========== MANAGER BOTTOM NAVIGATION BAR ==========
class ManagerScaffoldWithNavBar extends StatelessWidget {
  const ManagerScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final scale = isSmallScreen ? 0.85 : (screenWidth / 375).clamp(0.85, 1.1);

    final navBarHeight = isSmallScreen ? 80.0 : 90.0;
    final iconPadding = isSmallScreen ? 10.0 : 14.0;
    final iconSize = (24 * scale).clamp(22.0, 30.0);
    final fontSize = (12 * scale).clamp(11.0, 14.0);

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
                icon: LucideIcons.layoutDashboard,
                isActive: navigationShell.currentIndex == 0,
                padding: iconPadding,
                label: '',
              ),
              _buildNavBarItem(
                icon: LucideIcons.mapPin,
                isActive: navigationShell.currentIndex == 1,
                padding: iconPadding,
                label: '',
              ),
              _buildNavBarItem(
                icon: LucideIcons.chartArea,
                isActive: navigationShell.currentIndex == 2,
                padding: iconPadding,
                label: '',
              ),
              _buildNavBarItem(
                icon: LucideIcons.ticket,
                isActive: navigationShell.currentIndex == 3,
                padding: iconPadding,
                label: '',
              ),
              _buildNavBarItem(
                icon: LucideIcons.user,
                isActive: navigationShell.currentIndex == 4,
                padding: iconPadding,
                label: '',
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
