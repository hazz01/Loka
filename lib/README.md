# Loka - Virtual Tour App

A Flutter application for virtual tours with AI-powered trip planning.

## Project Structure

```
lib/
├── main.dart                    # App entry point with Riverpod setup
├── routing/
│   └── app_router.dart         # Centralized GoRouter configuration
├── features/                   # Feature-first architecture
│   ├── home/
│   │   └── pages/
│   │       ├── home_page.dart              # Main destinations list with pagination
│   │       ├── detail_component_page.dart  # Destination details
│   │       ├── virtual_tour_page.dart      # VR tour viewer
│   │       ├── booking_tiket_page.dart     # Ticket booking
│   │       ├── trip_ai_planner_page.dart   # AI trip planner
│   │       ├── kategori_provinsi_page.dart # Province categories
│   │       ├── kategori_greater_city_page.dart # Greater city categories
│   │       └── kategori_city_page.dart     # City categories
│   ├── search/
│   │   └── pages/
│   │       └── search_page.dart            # Search with pagination  
│   ├── saved/
│   │   └── pages/
│   │       ├── saved_plan_page.dart        # Saved plans with pagination
│   │       └── trip_plan_page.dart         # Individual trip plan details
│   └── profile/
│       └── pages/
│           └── profile_page.dart           # User profile
└── shared/
    ├── data/
    │   ├── models.dart                     # Data models
    │   └── mock_data_source.dart          # Mock data with pagination
    └── widgets/
        └── common_widgets.dart             # Reusable widgets
```

## Features Implemented

### ✅ Routing with GoRouter
- Nested routes according to the specified hierarchy
- Bottom navigation with 4 tabs (Home, Search, Saved, Profile)
- Deep linking support for all pages
- Proper navigation handling with context.go()

### ✅ Pagination with infinite_scroll_pagination
- **Home Page**: Infinite scroll for destinations list
- **Search Page**: Paginated search results
- **Saved Plans**: Paginated trip plans list
- Mock data source with simulated network delays

### ✅ State Management with Riverpod
- Provider scope setup in main.dart
- ConsumerStatefulWidget usage for pagination

### ✅ Feature-First Architecture
- Clean separation of concerns
- Organized by features rather than layers
- Shared components for reusability

## Routing Hierarchy

```
/ (Home)
├── /detail/:destinationId (DetailComponent)
│   ├── /detail/:destinationId/virtual-tour (VirtualTour)
│   └── /detail/:destinationId/booking (BookingTiket)
└── /trip-ai-planner (TripAIPlanner)
    ├── /trip-ai-planner/provinsi (KategoriProvinsi)
    ├── /trip-ai-planner/greater-city (KategoriGreaterCity)
    └── /trip-ai-planner/city (KategoriCity)

/search (SearchPage)

/saved (SavedPlan)
└── /saved/trip/:tripId (TripPlan)

/profile (Profile)
```

## Mock Data

The app includes comprehensive mock data:
- 100 destinations with ratings, locations, and VR availability
- 50 trip plans with different durations and destinations  
- 5 provinces with destination counts
- 4 cities (including greater cities)

## Pagination Implementation

All paginated lists use `infinite_scroll_pagination` with:
- Page size of 10 items
- Automatic loading indicators
- Error handling with retry functionality
- Empty state handling
- Simulated network delays (500ms)

## Getting Started

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run the application:
   ```bash
   flutter run
   ```

## Technologies Used

- **Flutter 3.x**: Cross-platform framework
- **go_router 14.x**: Declarative routing
- **infinite_scroll_pagination 4.x**: Pagination handling
- **flutter_riverpod 2.x**: State management
- **Material 3**: Design system

## Next Steps

1. Replace mock data with real API integration
2. Implement authentication and user management
3. Add WebView for actual virtual tours
4. Integrate payment system for booking
5. Implement AI-powered trip planning features
6. Add offline support and caching
7. Implement push notifications
8. Add social features (sharing, reviews)
