import 'models.dart';

// Mock data source for the Loka Virtual Tour App
class MockDataSource {
  static List<Destination> get destinations => _destinations;
  static List<TripPlan> get tripPlans => _tripPlans;
  static List<Province> get provinces => _provinces;
  static List<City> get cities => _cities;

  // Mock destinations data
  static final List<Destination> _destinations = [
    // Tourist Attractions
    const Destination(
      id: 'dest_1',
      name: 'Jatim Park 1',
      description:
          'Jatim Park 1 is a popular family-friendly theme park located in Batu, East Java. It offers a perfect blend of education and entertainment with various attractions including a learning gallery, science center, and numerous fun rides.\n\nThe park features interactive exhibits that make learning enjoyable for children and adults alike. With beautiful gardens, exciting water attractions, and cultural performances, it\'s an ideal destination for families looking to spend quality time together.',
      imageUrl:
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
      location: 'Batu',
      province: 'Jawa Timur',
      rating: 4.5,
      hasVirtualTour: true,
      category: 'Tourist Attraction',
      distance: 15.3,
      address: 'Jl. Kartika No.2, Sisir, Batu',
      openingHours: '8:30 AM - 4:30 PM',
      latitude: -7.8753,
      longitude: 112.5281,
      ticketPrices: [
        TicketPrice(type: 'Weekday', price: 80000, isAvailable: true),
        TicketPrice(type: 'Weekend', price: 120000, isAvailable: true),
      ],
      tourOptions: [
        TourOption(
          id: 'tour_jp1_1',
          name: 'Full Day Tour',
          description: 'Complete park experience',
          price: 100000,
          destinationCount: 8,
        ),
        TourOption(
          id: 'tour_jp1_2',
          name: 'Educational Tour',
          description: 'Focus on learning galleries',
          price: 75000,
          destinationCount: 5,
        ),
      ],
      activities: [
        'Visit the Learning Gallery with interactive exhibits',
        'Enjoy thrilling rides and attractions',
        'Watch educational shows and performances',
        'Explore the Science Center',
        'Take photos at Instagram-worthy spots',
      ],
    ),
    const Destination(
      id: 'dest_2',
      name: 'Museum Angkut',
      description:
          'Museum Angkut is Asia\'s largest transportation museum, showcasing an impressive collection of vehicles from various eras and countries. The museum features vintage cars, motorcycles, aircraft, and traditional transportation modes.\n\nWith its unique thematic zones representing different countries and time periods, Museum Angkut offers an immersive journey through transportation history. Each zone is carefully designed to transport visitors to different parts of the world.',
      imageUrl:
          'https://images.unsplash.com/photo-1568632234157-ce7aecd03d0d?w=400',
      location: 'Batu',
      province: 'Jawa Timur',
      rating: 4.7,
      hasVirtualTour: true,
      category: 'Tourist Attraction',
      distance: 16.5,
      address: 'Jl. Terusan Sultan Agung No.2, Ngaglik, Batu',
      openingHours: '12:00 PM - 8:00 PM',
      latitude: -7.8925,
      longitude: 112.5234,
      ticketPrices: [
        TicketPrice(type: 'Weekday', price: 100000, isAvailable: true),
        TicketPrice(type: 'Weekend', price: 130000, isAvailable: true),
      ],
      tourOptions: [
        TourOption(
          id: 'tour_ma_1',
          name: 'Heritage Tour',
          description: 'Classic vehicle collection',
          price: 50000,
          destinationCount: 6,
        ),
        TourOption(
          id: 'tour_ma_2',
          name: 'Complete Zone Tour',
          description: 'All thematic zones',
          price: 120000,
          destinationCount: 10,
        ),
      ],
      activities: [
        'Explore vintage car collections from around the world',
        'Take photos with classic motorcycles and aircraft',
        'Visit themed zones representing different countries',
        'Learn about transportation history',
        'Experience 3D trick art zones',
      ],
    ),
    const Destination(
      id: 'dest_3',
      name: 'Jatim Park 2',
      description:
          'Taman wisata dengan kebun binatang dan museum satwa yang edukatif.',
      imageUrl:
          'https://images.unsplash.com/photo-1580837119756-563d608dd119?w=400',
      location: 'Batu',
      province: 'Jawa Timur',
      rating: 4.6,
      hasVirtualTour: true,
      category: 'Tourist Attraction',
      distance: 16.1,
    ),
    const Destination(
      id: 'dest_4',
      name: 'Bromo Tengger Semeru',
      description:
          'Taman nasional dengan pemandangan gunung berapi yang spektakuler.',
      imageUrl:
          'https://images.unsplash.com/photo-1605640840605-14ac1855827b?w=400',
      location: 'Probolinggo',
      province: 'Jawa Timur',
      rating: 4.9,
      hasVirtualTour: false,
      category: 'Tourist Attraction',
      distance: 45.8,
    ),
    const Destination(
      id: 'dest_5',
      name: 'Pantai Balekambang',
      description:
          'Pantai indah dengan pura di atas pulau kecil, mirip Tanah Lot.',
      imageUrl:
          'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=400',
      location: 'Malang',
      province: 'Jawa Timur',
      rating: 4.4,
      hasVirtualTour: false,
      category: 'Tourist Attraction',
      distance: 52.3,
    ),
    const Destination(
      id: 'dest_6',
      name: 'Coban Rondo',
      description:
          'Air terjun yang indah dengan suasana sejuk dan pemandangan yang memukau.',
      imageUrl:
          'https://images.unsplash.com/photo-1432405972618-c60b0225b8f9?w=400',
      location: 'Batu',
      province: 'Jawa Timur',
      rating: 4.3,
      hasVirtualTour: false,
      category: 'Tourist Attraction',
      distance: 22.7,
    ),

    // Culinary
    const Destination(
      id: 'dest_7',
      name: 'Kampoeng Heritage Kajoetangan',
      description:
          'Kampoeng Heritage Kajoetangan is a historical neighborhood in Malang, renowned for its well-preserved colonial-era architecture. This area offers a glimpse into the past with its vintage houses, old-fashioned shops, and traditional markets, providing visitors with a unique showcase of Indonesia\'s colonial history and local culture.\n\nIn addition to its historical charm, Kampoeng Heritage Kajoetangan is a vibrant cultural hub. It hosts various cultural festivals, art exhibitions, and traditional performances, showcasing local artistry. The neighborhood\'s quaint cafes and eateries add to its nostalgic ambiance, making it a beloved destination for history enthusiasts and culture lovers alike.',
      imageUrl:
          'https://abkistimewa.id/sekolah/assets/gallery/berita/42-20231102095419-13961295776543B81BC6EA9.jpeg',
      location: 'Malang',
      province: 'Jawa Timur',
      rating: 5.0,
      hasVirtualTour: true,
      category: 'Heritage',
      distance: 2.5,
      address: 'Jl. Besar Ijen Ggg. 4, Malang',
      openingHours: '7:00 AM - 5:30 PM',
      latitude: -7.9797,
      longitude: 112.6304,
      ticketPrices: [
        TicketPrice(type: 'Weekday', price: 50000, isAvailable: true),
        TicketPrice(type: 'Weekend', price: 0, isAvailable: false),
      ],
      tourOptions: [
        TourOption(
          id: 'tour_heritage_1',
          name: 'Highlight Tour',
          description: '5 Destination',
          price: 50000,
          destinationCount: 5,
        ),
        TourOption(
          id: 'tour_heritage_2',
          name: 'Family Fun Tour',
          description: '5 Destination',
          price: 150000,
          destinationCount: 5,
        ),
      ],
      activities: [
        'Explore the rich history of Malang',
        'Antiques and artifacts exhibition',
        'Photography with ancient houses in the background',
        'Local cultural performances (specific schedules)',
        'Interactive historical tours',
      ],
    ),
    const Destination(
      id: 'dest_8',
      name: 'Bakso President',
      description:
          'Rumah makan bakso legendaris dengan cita rasa yang khas dan porsi melimpah.',
      imageUrl:
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400',
      location: 'Malang',
      province: 'Jawa Timur',
      rating: 4.6,
      hasVirtualTour: false,
      category: 'Culinary',
      distance: 4.1,
    ),
    const Destination(
      id: 'dest_9',
      name: 'Rawon Setan',
      description:
          'Kuliner rawon hitam legendaris yang buka 24 jam dengan rasa yang nikmat.',
      imageUrl:
          'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=400',
      location: 'Malang',
      province: 'Jawa Timur',
      rating: 4.7,
      hasVirtualTour: false,
      category: 'Culinary',
      distance: 5.8,
    ),
    const Destination(
      id: 'dest_10',
      name: 'Toko Oen',
      description:
          'Restoran bersejarah dengan interior klasik dan menu western yang legendaris.',
      imageUrl:
          'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=400',
      location: 'Malang',
      province: 'Jawa Timur',
      rating: 4.4,
      hasVirtualTour: false,
      category: 'Culinary',
      distance: 2.9,
    ),
    const Destination(
      id: 'dest_11',
      name: 'Depot Soto Madura',
      description:
          'Soto khas Madura dengan kuah yang gurih dan daging yang empuk.',
      imageUrl:
          'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400',
      location: 'Malang',
      province: 'Jawa Timur',
      rating: 4.5,
      hasVirtualTour: false,
      category: 'Culinary',
      distance: 6.2,
    ),

    // Souvenir
    const Destination(
      id: 'dest_12',
      name: 'Pasar Bunga Splendid',
      description:
          'Pusat oleh-oleh khas Malang dengan berbagai pilihan produk lokal.',
      imageUrl:
          'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400',
      location: 'Malang',
      province: 'Jawa Timur',
      rating: 4.3,
      hasVirtualTour: false,
      category: 'Souvenir',
      distance: 3.7,
    ),
    const Destination(
      id: 'dest_13',
      name: 'Toko Pia Cap Mangkok',
      description:
          'Toko kue pia legendaris dengan rasa yang autentik dan harga terjangkau.',
      imageUrl:
          'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400',
      location: 'Malang',
      province: 'Jawa Timur',
      rating: 4.6,
      hasVirtualTour: false,
      category: 'Souvenir',
      distance: 4.3,
    ),
    const Destination(
      id: 'dest_14',
      name: 'Kampung Wisata Keramik',
      description:
          'Sentra keramik dengan berbagai produk kerajinan tangan yang unik.',
      imageUrl:
          'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=400',
      location: 'Malang',
      province: 'Jawa Timur',
      rating: 4.2,
      hasVirtualTour: false,
      category: 'Souvenir',
      distance: 8.9,
    ),
    const Destination(
      id: 'dest_15',
      name: 'Toko Apel Malang',
      description:
          'Pusat oleh-oleh apel dan produk turunannya yang khas dari Malang.',
      imageUrl:
          'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400',
      location: 'Batu',
      province: 'Jawa Timur',
      rating: 4.4,
      hasVirtualTour: false,
      category: 'Souvenir',
      distance: 18.5,
    ),

    // Tour & Trip
    const Destination(
      id: 'dest_16',
      name: 'Omah Kayu Adventure',
      description:
          'Tempat wisata petualangan dengan berbagai aktivitas outdoor yang seru.',
      imageUrl:
          'https://images.unsplash.com/photo-1533587851505-d119e13fa0d7?w=400',
      location: 'Batu',
      province: 'Jawa Timur',
      rating: 4.5,
      hasVirtualTour: false,
      category: 'Tour & Trip',
      distance: 19.2,
    ),
    const Destination(
      id: 'dest_17',
      name: 'Coban Talun',
      description:
          'Wisata air terjun dengan trekking yang menantang dan pemandangan alam yang indah.',
      imageUrl:
          'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=400',
      location: 'Batu',
      province: 'Jawa Timur',
      rating: 4.6,
      hasVirtualTour: false,
      category: 'Tour & Trip',
      distance: 24.1,
    ),
    const Destination(
      id: 'dest_18',
      name: 'Wisata Petik Apel',
      description:
          'Kebun apel dengan aktivitas petik apel langsung dan edukasi pertanian.',
      imageUrl:
          'https://images.unsplash.com/photo-1568702846914-96b305d2aaeb?w=400',
      location: 'Batu',
      province: 'Jawa Timur',
      rating: 4.4,
      hasVirtualTour: false,
      category: 'Tour & Trip',
      distance: 17.8,
    ),
    const Destination(
      id: 'dest_19',
      name: 'Selecta',
      description:
          'Taman wisata dengan kolam renang air panas dan taman bunga yang indah.',
      imageUrl:
          'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400',
      location: 'Batu',
      province: 'Jawa Timur',
      rating: 4.3,
      hasVirtualTour: false,
      category: 'Tour & Trip',
      distance: 21.3,
    ),
    const Destination(
      id: 'dest_20',
      name: 'Paralayang Batu',
      description:
          'Spot paralayang dengan pemandangan kota Batu dan Malang yang spektakuler.',
      imageUrl:
          'https://images.unsplash.com/photo-1473496169904-658ba7c44d8a?w=400',
      location: 'Batu',
      province: 'Jawa Timur',
      rating: 4.7,
      hasVirtualTour: false,
      category: 'Tour & Trip',
      distance: 23.5,
    ),
  ];

  // Mock trip plans data
  static final List<TripPlan> _tripPlans = List.generate(50, (index) {
    final provinces = [
      'DKI Jakarta',
      'Bali',
      'Jawa Barat',
      'Jawa Tengah',
      'D.I. Yogyakarta',
    ];
    final duration = (index % 7) + 1;
    final province = provinces[index % provinces.length];
    final destCount = (index % 5) + 2;

    return TripPlan(
      id: 'plan_$index',
      title: 'Trip Plan ${index + 1}',
      description: 'Amazing $duration-day trip to $province',
      destinations: List.generate(
        destCount,
        (i) => 'dest_${(index * 10 + i) % 20}',
      ),
      createdAt: DateTime.now().subtract(Duration(days: index * 2)),
      duration: duration,
      province: province,
    );
  });

  // Mock provinces data
  static final List<Province> _provinces = [
    const Province(
      id: 'jakarta',
      name: 'DKI Jakarta',
      imageUrl: 'https://picsum.photos/300/200?random=101',
      destinationCount: 25,
    ),
    const Province(
      id: 'bali',
      name: 'Bali',
      imageUrl: 'https://picsum.photos/300/200?random=102',
      destinationCount: 35,
    ),
    const Province(
      id: 'jawa_barat',
      name: 'Jawa Barat',
      imageUrl: 'https://picsum.photos/300/200?random=103',
      destinationCount: 40,
    ),
    const Province(
      id: 'jawa_tengah',
      name: 'Jawa Tengah',
      imageUrl: 'https://picsum.photos/300/200?random=104',
      destinationCount: 30,
    ),
    const Province(
      id: 'yogyakarta',
      name: 'D.I. Yogyakarta',
      imageUrl: 'https://picsum.photos/300/200?random=105',
      destinationCount: 20,
    ),
  ];

  // Mock cities data
  static final List<City> _cities = [
    const City(
      id: 'jakarta_pusat',
      name: 'Jakarta Pusat',
      province: 'DKI Jakarta',
      imageUrl: 'https://picsum.photos/300/200?random=201',
      destinationCount: 15,
      isGreaterCity: true,
    ),
    const City(
      id: 'denpasar',
      name: 'Denpasar',
      province: 'Bali',
      imageUrl: 'https://picsum.photos/300/200?random=202',
      destinationCount: 20,
      isGreaterCity: true,
    ),
    const City(
      id: 'bandung',
      name: 'Bandung',
      province: 'Jawa Barat',
      imageUrl: 'https://picsum.photos/300/200?random=203',
      destinationCount: 25,
      isGreaterCity: true,
    ),
    const City(
      id: 'yogyakarta_city',
      name: 'Yogyakarta',
      province: 'D.I. Yogyakarta',
      imageUrl: 'https://picsum.photos/300/200?random=204',
      destinationCount: 18,
      isGreaterCity: false,
    ),
  ];

  // Pagination methods
  static Future<List<Destination>> getDestinations({
    required int page,
    int pageSize = 10,
    String? searchQuery,
    String? category,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    var filteredDestinations = destinations;

    // Filter by category
    if (category != null && category.isNotEmpty) {
      filteredDestinations = filteredDestinations
          .where((dest) => dest.category == category)
          .toList();
    }

    // Filter by search query
    if (searchQuery != null && searchQuery.isNotEmpty) {
      filteredDestinations = filteredDestinations
          .where(
            (dest) =>
                dest.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                dest.location.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    final startIndex = page * pageSize;
    final endIndex = (startIndex + pageSize).clamp(
      0,
      filteredDestinations.length,
    );

    if (startIndex >= filteredDestinations.length) {
      return [];
    }

    return filteredDestinations.sublist(startIndex, endIndex);
  }

  // Get destinations by category for recommended section
  static List<Destination> getDestinationsByCategory(String category) {
    return destinations.where((dest) => dest.category == category).toList();
  }

  // Get nearest destinations (sorted by distance)
  static List<Destination> getNearestDestinations({int limit = 10}) {
    final sorted = List<Destination>.from(destinations);
    sorted.sort((a, b) => a.distance.compareTo(b.distance));
    return sorted.take(limit).toList();
  }

  static Future<List<TripPlan>> getTripPlans({
    required int page,
    int pageSize = 10,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final startIndex = page * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, tripPlans.length);

    if (startIndex >= tripPlans.length) {
      return [];
    }

    return tripPlans.sublist(startIndex, endIndex);
  }
}
