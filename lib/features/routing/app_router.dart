import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loka/features/auth/loginpage.dart';
import 'package:loka/features/auth/openingscreen.dart';
import 'package:loka/features/auth/preregister_page.dart';
import 'package:loka/features/auth/registerpage.dart';
import 'package:loka/features/auth/rolechoose_page.dart';
import 'package:loka/features/home/pages/loading_screen.dart';
import 'package:loka/features/home/pages/timeline_trip_Page.dart';
import 'package:loka/features/home/models/trip_response_model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:loka/features/auth/splash.dart';

// Feature imports
import '../home/pages/home_page.dart';
import '../home/pages/detail_component_page.dart';
import '../home/pages/virtual_tour_page.dart';
import '../home/pages/booking_tiket_page.dart';
import '../home/pages/trip_ai_planner_page.dart';
import '../home/pages/kategori_provinsi_page.dart';
import '../home/pages/kategori_greater_city_page.dart';
import '../home/pages/kategori_city_page.dart';
import '../home/pages/explore_page.dart';
import '../search/pages/search_page.dart';
import '../saved/pages/saved_plan_page.dart';
import '../profile/pages/profile_page.dart';
import '../profile/pages/transaction_history_page.dart';
import '../profile/pages/previous_trips_page.dart';
import '../profile/pages/favorite_trips_page.dart';

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
      GoRoute(
        path: '/opening',
        name: 'opening',
        builder: (context, state) => const OpeningPage(),
      ),
      GoRoute(
        path: '/preregister',
        name: 'preregister',
        builder: (context, state) => const PreRegisterPage(),
      ),

      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
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
