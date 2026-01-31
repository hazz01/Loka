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
      imageUrl: 'assets/image/homepage_travel/jatimpark_picture.png',
      location: 'Batu',
      province: 'Jawa Timur',
      rating: 4.5,
      hasVirtualTour: true,
      category: 'Tourist Attraction',
      distance: 15.3,
      address:
          'Jl. Kartika No. 2, Sisir, Batu, Jawa Timur 65315, Indonesia', // added postal
      openingHours: '08:30 AM – 04:30 PM', // standardised format
      latitude: -7.8753,
      longitude: 112.5281,
      virtualTourUrl: 'https://jatimpark1.netlify.app/',
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
      imageUrl: 'assets/image/homepage_travel/museum_angkut_picture.png',
      location: 'Batu',
      province: 'Jawa Timur',
      rating: 4.7,
      hasVirtualTour: true,
      category: 'Tourist Attraction',
      distance: 16.5,
      address:
          'Jl. Terusan Sultan Agung No.2, Ngaglik, Batu, Jawa Timur 65316, Indonesia', // added postal
      openingHours: '12:00 PM – 08:00 PM',
      latitude: -7.8925,
      longitude: 112.5234,
      virtualTourUrl:
          'https://vragio-vtour.benspace.xyz/vragio%20web%20museum%20angkut/',
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
      imageUrl: 'assets/image/homepage_travel/jatimpark2_picture.png',
      location: 'Batu',
      province: 'Jawa Timur',
      rating: 4.6,
      hasVirtualTour: true,
      category: 'Tourist Attraction',
      distance: 16.1,
      address:
          'Jl. Oro-Oro Ombo No.9, Temas, Batu, Kota Batu, Jawa Timur 65315, Indonesia', // fixed address per web :contentReference[oaicite:0]{index=0}
      openingHours:
          '08:30 AM – 04:30 PM', // per web :contentReference[oaicite:1]{index=1}
      latitude:
          -7.8880, // approx from web :contentReference[oaicite:2]{index=2}
      longitude: 112.5296,
      virtualTourUrl:
          'https://vragio-vtour.benspace.xyz/vragio%20web%20jatim%20park%202/',
      ticketPrices: [
        TicketPrice(type: 'Weekday', price: 125000, isAvailable: true),
        TicketPrice(type: 'Weekend', price: 160000, isAvailable: true),
      ],
      tourOptions: [
        TourOption(
          id: 'tour_jp2_1',
          name: 'Zoo & Museum Tour',
          description: 'Batu Secret Zoo + Museum Satwa',
          price: 150000,
          destinationCount: 8,
        ),
        TourOption(
          id: 'tour_jp2_2',
          name: 'Drive-Thru Safari Experience',
          description: 'Explore via vehicle within zoo area',
          price: 200000,
          destinationCount: 1,
        ),
      ],
      activities: [
        'Visit Batu Secret Zoo with wide variety of species',
        'Explore Museum Satwa - dinosaur fossils & preserved animals',
        'Ride educational exhibits about nature and conservation',
        'Enjoy family rides and interactive zones',
      ],
    ),
    const Destination(
      id: 'dest_4',
      name: 'Bromo Tengger Semeru National Park',
      description:
          'Taman nasional dengan pemandangan gunung berapi yang spektakuler.',
      imageUrl: 'assets/image/homepage_travel/gunung_bromo_picture.png',
      location: 'Probolinggo',
      province: 'Jawa Timur',
      rating: 4.9,
      hasVirtualTour: false,
      category: 'Tourist Attraction',
      distance: 45.8,
      address:
          'Kawasan Taman Nasional Bromo Tengger Semeru, Jawa Timur, Indonesia',
      openingHours: '24 hours (sunrise to viewpoint)',
      latitude: -7.9425, // approximate
      longitude: 112.9539,
      ticketPrices: [
        TicketPrice(
          type: 'General Admission',
          price: 100000,
          isAvailable: true,
        ),
      ],
      tourOptions: [
        TourOption(
          id: 'tour_bts_1',
          name: 'Sunrise Jeep Package',
          description: 'Jeep tour to Penanjakan & view Mt Bromo',
          price: 900000,
          destinationCount: 3,
        ),
      ],
      activities: [
        'Jeep sunrise tour to Penanjakan viewpoint',
        'Trek across Sea of Sand and up Mt Bromo crater rim',
        'Horse ride at Mt Bromo area',
        'Photography at iconic landscape & sea of clouds',
      ],
    ),
    const Destination(
      id: 'dest_5',
      name: 'Pantai Balekambang',
      description:
          'Pantai indah dengan pura di atas pulau kecil, mirip Tanah Lot.',
      imageUrl: 'assets/image/homepage_travel/pantai_balekambang_picture.png',
      location: 'Bantur, Malang',
      province: 'Jawa Timur',
      rating: 4.4,
      hasVirtualTour: false,
      category: 'Tourist Attraction',
      distance: 52.3,
      address:
          'Dusun Sumber Jambe, Desa Srigonco, Kecamatan Bantur, Kabupaten Malang, Jawa Timur 65179, Indonesia', // per web :contentReference[oaicite:3]{index=3}
      openingHours:
          'Open 24 hours', // per web :contentReference[oaicite:4]{index=4}
      latitude: -8.1450, // approx
      longitude: 112.6350,
      ticketPrices: [
        TicketPrice(
          type: 'Standard',
          price: 10000,
          isAvailable: true,
        ), // weekday price
        TicketPrice(type: 'Weekend/Holiday', price: 15000, isAvailable: true),
      ],
      tourOptions: [
        TourOption(
          id: 'tour_bal_1',
          name: 'Sunset & Photography Tour',
          description: 'Guided photo tour at the temple island & beach',
          price: 50000,
          destinationCount: 1,
        ),
      ],
      activities: [
        'Walk to the small island with Pura Luhur Amertha Jati',
        'Beach photography at sunset',
        'Relax on white sand & swim (with caution – waves can be strong)',
        'Support local food & warung near beach',
      ],
    ),
    const Destination(
      id: 'dest_6',
      name: 'Coban Rondo Waterfall',
      description:
          'Air terjun yang indah dengan suasana sejuk dan pemandangan yang memukau.',
      imageUrl:
          'assets/image/homepage_travel/air_terjun_coban_rondo_picture.png',
      location: 'Batu',
      province: 'Jawa Timur',
      rating: 4.3,
      hasVirtualTour: false,
      category: 'Tourist Attraction',
      distance: 22.7,
      address:
          'Jl. Coban Rondo No. / Kawasan Wisata Air Terjun Coban Rondo, Dusun Krajan II, Pujon, Batu, Jawa Timur, Indonesia',
      openingHours: '08:00 AM – 05:00 PM',
      latitude: -7.8320, // approximate
      longitude: 112.5250,
      ticketPrices: [
        TicketPrice(type: 'Adult', price: 25000, isAvailable: true),
        TicketPrice(type: 'Child', price: 15000, isAvailable: true),
      ],
      tourOptions: [
        TourOption(
          id: 'tour_cr_1',
          name: 'Waterfall Hiking Tour',
          description: 'Trek and explore forest area and waterfall',
          price: 40000,
          destinationCount: 1,
        ),
      ],
      activities: [
        'Hike through forest trail to waterfall viewpoint',
        'Photography with waterfall backdrop',
        'Enjoy picnic area near the waterfall',
      ],
    ),

    // Culinary
    const Destination(
      id: 'dest_7',
      name: 'Kampoeng Heritage Kajoetangan',
      description:
          'Kampoeng Heritage Kajoetangan is a historical neighborhood in Malang, renowned for its well-preserved colonial-era architecture. This area offers a glimpse into the past with its vintage houses, old-fashioned shops, and traditional markets, providing visitors with a unique showcase of Indonesia’s colonial history and local culture.\n\nIn addition to its historical charm, Kampoeng Heritage Kajoetangan is a vibrant cultural hub. It hosts various cultural festivals, art exhibitions, and traditional performances, showcasing local artistry. The neighbourhood’s quaint cafes and eateries add to its nostalgic ambiance, making it a beloved destination for history enthusiasts and culture lovers alike.',
      imageUrl: 'assets/image/homepage_travel/kampung_heritagee_picture.png',
      location: 'Malang',
      province: 'Jawa Timur',
      rating: 5.0,
      hasVirtualTour: true,
      category: 'Heritage',
      distance: 2.5,
      address: 'Jl. Besar Ijen Gg. 4, Malang, Jawa Timur 65111, Indonesia',
      openingHours: '07:00 AM – 05:30 PM',
      latitude: -7.9797,
      longitude: 112.6304,
      virtualTourUrl:
          'https://vragio-vtour.benspace.xyz/vragio%20web%20kajoetangan/',
      ticketPrices: [
        TicketPrice(type: 'Standard', price: 50000, isAvailable: true),
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
      id: 'dest_21',
      name: 'Kampung Jodipan',
      description:
          'Kampung Jodipan, also known as the Rainbow Village, is a vibrant and colorful neighbourhood that has become one of Malang’s most Instagram-worthy destinations. Once a slum area, it has been transformed into a stunning tourist attraction with over 232 houses painted in bright, cheerful colours.\n\nThe village showcases beautiful street art, colourful murals, and rainbow-painted stairs and bridges. Visitors can explore narrow alleys adorned with creative artwork, take photos with the iconic rainbow river view, and experience the local community’s warmth. It’s a perfect example of community-driven urban renewal that combines art, culture, and tourism.',
      imageUrl: 'assets/image/homepage_travel/kampung_jodipan_picture.png',
      location: 'Malang',
      province: 'Jawa Timur',
      rating: 4.7,
      hasVirtualTour: true,
      category: 'Heritage',
      distance: 3.2,
      address:
          'Jl. Jodipan, Kesatrian, Blimbing, Malang, Jawa Timur 65125, Indonesia',
      openingHours: '08:00 AM – 05:00 PM',
      latitude: -7.9781,
      longitude: 112.6435,
      virtualTourUrl:
          'https://vragio-vtour.benspace.xyz/vragio%20web%20jodipan/',
      ticketPrices: [
        TicketPrice(type: 'Standard', price: 10000, isAvailable: true),
        TicketPrice(type: 'Weekend/Holiday', price: 15000, isAvailable: true),
      ],
      tourOptions: [
        TourOption(
          id: 'tour_jodipan_1',
          name: 'Rainbow Walking Tour',
          description: 'Guided tour through colourful alleys',
          price: 30000,
          destinationCount: 1,
        ),
        TourOption(
          id: 'tour_jodipan_2',
          name: 'Photography Package',
          description: 'Best spots for Instagram photos',
          price: 50000,
          destinationCount: 1,
        ),
      ],
      activities: [
        'Walk through the colourful rainbow village',
        'Take photos at the rainbow bridge and stairs',
        'Explore creative street art and murals',
        'Visit local community workshops',
        'Enjoy the view of the colourful riverside',
        'Support local artisans and handicrafts',
      ],
    ),

    const Destination(
      id: 'dest_22',
      name: 'Kampung Umbulan Tanaka',
      description:
          'Kampung Umbulan Tanaka is a unique cultural village in Malang that combines traditional Javanese architecture with modern tourism concepts. The village showcases the authentic rural lifestyle while offering various cultural activities and experiences for visitors.\n\nNamed after the natural spring (umbulan) that flows through the village, this destination offers a peaceful retreat from urban life. Visitors can enjoy traditional farming activities, learn about local crafts, taste authentic Javanese cuisine, and immerse themselves in the warm hospitality of the village community. The village also features beautiful natural scenery with rice fields, bamboo groves, and traditional wooden houses.',
      imageUrl:
          'assets/image/homepage_travel/kampung_umbulan_tanaka_picture.png',
      location: 'Malang',
      province: 'Jawa Timur',
      rating: 4.6,
      hasVirtualTour: true,
      category: 'Heritage',
      distance: 8.5,
      address: 'Jl. Sumber Brantas, Bumiaji, Batu, Jawa Timur 65321, Indonesia',
      openingHours: '08:00 AM – 06:00 PM',
      latitude: -7.8645,
      longitude: 112.5189,
      virtualTourUrl:
          'https://vragio-vtour.benspace.xyz/vragio%20web%20tanaka/',
      ticketPrices: [
        TicketPrice(type: 'Weekday', price: 15000, isAvailable: true),
        TicketPrice(type: 'Weekend', price: 20000, isAvailable: true),
      ],
      tourOptions: [
        TourOption(
          id: 'tour_tanaka_1',
          name: 'Village Cultural Tour',
          description: 'Traditional village experience',
          price: 40000,
          destinationCount: 1,
        ),
        TourOption(
          id: 'tour_tanaka_2',
          name: 'Farming Experience',
          description: 'Hands-on farming activities',
          price: 60000,
          destinationCount: 1,
        ),
      ],
      activities: [
        'Experience traditional Javanese village life',
        'Visit the natural spring and water sources',
        'Learn traditional farming and rice planting',
        'Participate in local craft workshops',
        'Taste authentic village cuisine',
        'Explore traditional wooden house architecture',
        'Enjoy peaceful walks through rice fields',
      ],
    ),

    const Destination(
      id: 'dest_23',
      name: 'Desa Wisata Bulukerto',
      description:
          'Desa Wisata Bulukerto is an agro-tourism village located at the foot of Mount Arjuna, offering visitors a unique blend of natural beauty, agricultural experiences, and rural tourism. The village is renowned for its organic farming, cool mountain air, and stunning views of the surrounding mountains.\n\nVisitors can experience authentic rural life while enjoying modern tourism facilities. The village offers various activities including vegetable picking, coffee plantation tours, traditional food making workshops, and trekking through scenic landscapes. With its commitment to sustainable tourism and community empowerment, Bulukerto has become a model for successful rural tourism development in East Java.',
      imageUrl: 'assets/image/homepage_travel/desa_bulukerto_picture.png',
      location: 'Bumiaji, Batu',
      province: 'Jawa Timur',
      rating: 4.8,
      hasVirtualTour: true,
      category: 'Heritage',
      distance: 12.8,
      address: 'Bulukerto, Bumiaji, Batu, Jawa Timur, Indonesia',
      openingHours: '07:00 AM – 06:00 PM',
      latitude: -7.8523,
      longitude: 112.5234,
      virtualTourUrl: 'https://bulukerto-virtual-tour.web.app',
      ticketPrices: [
        TicketPrice(type: 'Weekday', price: 20000, isAvailable: true),
        TicketPrice(type: 'Weekend', price: 25000, isAvailable: true),
      ],
      tourOptions: [
        TourOption(
          id: 'tour_bulukerto_1',
          name: 'Agro Tourism Package',
          description: 'Farm and plantation tour',
          price: 75000,
          destinationCount: 1,
        ),
        TourOption(
          id: 'tour_bulukerto_2',
          name: 'Full Day Experience',
          description: 'Complete village experience',
          price: 120000,
          destinationCount: 1,
        ),
      ],
      activities: [
        'Pick fresh vegetables from organic farms',
        'Tour coffee and tea plantations',
        'Learn traditional food processing',
        'Experience rural homestay living',
        'Trek through scenic mountain trails',
        'Visit local dairy farms',
        'Enjoy panoramic mountain views',
        'Participate in sustainable farming practices',
      ],
    ),

    const Destination(
      id: 'dest_8',
      name: 'Bakso President',
      description:
          'Rumah makan bakso legendaris dengan cita rasa yang khas dan porsi melimpah.',
      imageUrl: 'assets/image/homepage_travel/bakso_president_picture.png',
      location: 'Malang',
      province: 'Jawa Timur',
      rating: 4.6,
      hasVirtualTour: false,
      category: 'Culinary',
      distance: 4.1,
      address:
          'Jl. Panglima Sudirman No. 89, Malang, Jawa Timur, Indonesia', // added placeholder (please verify)
      openingHours: '10:00 AM – 10:00 PM',
      latitude: -7.9830,
      longitude: 112.6210,
      ticketPrices: [],
      tourOptions: [],
      activities: [
        'Enjoy the legendary bakso with big portions',
        'Try local favourite sides & sambal',
      ],
    ),
    const Destination(
      id: 'dest_9',
      name: 'Rawon Setan',
      description:
          'Kuliner rawon hitam legendaris yang buka 24 jam dengan rasa yang nikmat.',
      imageUrl: 'assets/image/homepage_travel/rawon_setan_picture.png',
      location: 'Malang',
      province: 'Jawa Timur',
      rating: 4.7,
      hasVirtualTour: false,
      category: 'Culinary',
      distance: 5.8,
      address:
          'Jl. Gatot Subroto No. 12, Malang, Jawa Timur, Indonesia', // added placeholder
      openingHours: '24 hours',
      latitude: -7.9785,
      longitude: 112.6420,
      ticketPrices: [],
      tourOptions: [],
      activities: [
        'Try the midnight rawon black soup',
        'Experience the full flavour & spicy Sambal rawon',
      ],
    ),
    const Destination(
      id: 'dest_10',
      name: 'Toko Oen Malang',
      description:
          'Restoran bersejarah dengan interior klasik dan menu western yang legendaris.',
      imageUrl: 'assets/image/homepage_travel/toko_oen_picture.png',
      location: 'Malang',
      province: 'Jawa Timur',
      rating: 4.4,
      hasVirtualTour: false,
      category: 'Culinary',
      distance: 2.9,
      address:
          'Jl. Jenderal Basuki Rahmat No.4, Malang, Jawa Timur, Indonesia', // added placeholder
      openingHours:
          '09:00 AM – 11:00 PM & 05:00 PM – 10:00 PM', // typical split hours
      latitude: -7.9835,
      longitude: 112.6215,
      ticketPrices: [],
      tourOptions: [],
      activities: [
        'Enjoy colonial-era atmosphere and vintage interior',
        'Try their legendary ice cream & western dishes',
      ],
    ),
    const Destination(
      id: 'dest_11',
      name: 'Depot Soto Madura Malang',
      description:
          'Soto khas Madura dengan kuah yang gurih dan daging yang empuk.',
      imageUrl: 'assets/image/homepage_travel/depot_soto_madura_picture.png',
      location: 'Malang',
      province: 'Jawa Timur',
      rating: 4.5,
      hasVirtualTour: false,
      category: 'Culinary',
      distance: 6.2,
      address:
          'Jl. Soekarno-Hatta No. 45, Malang, Jawa Timur, Indonesia', // added placeholder
      openingHours: '07:00 AM – 09:00 PM',
      latitude: -7.9750,
      longitude: 112.6600,
      ticketPrices: [],
      tourOptions: [],
      activities: [
        'Savour authentic Madurese soto with rich flavour',
        'Relax in humble local dining atmosphere',
      ],
    ),

    // Souvenir
    const Destination(
      id: 'dest_12',
      name: 'Pasar Bunga Splendid',
      description:
          'Pusat oleh-oleh khas Malang dengan berbagai pilihan produk lokal.',
      imageUrl: 'assets/image/homepage_travel/pasar_bunga_splendid_picture.png',
      location: 'Malang',
      province: 'Jawa Timur',
      rating: 4.3,
      hasVirtualTour: false,
      category: 'Souvenir',
      distance: 3.7,
      address:
          'Jl. Raya Tlogomas No. 1, Malang, Jawa Timur, Indonesia', // placeholder
      openingHours: '08:00 AM – 07:00 PM',
      latitude: -7.9530,
      longitude: 112.6200,
      ticketPrices: [],
      tourOptions: [],
      activities: ['Browse local souvenir items – snacks, crafts, handicrafts'],
    ),
    const Destination(
      id: 'dest_13',
      name: 'Toko Pia Cap Mangkok',
      description:
          'Toko kue pia legendaris dengan rasa yang autentik dan harga terjangkau.',
      imageUrl: 'assets/image/homepage_travel/toko_pia_cap_picture.png',
      location: 'Malang',
      province: 'Jawa Timur',
      rating: 4.6,
      hasVirtualTour: false,
      category: 'Souvenir',
      distance: 4.3,
      address:
          'Jl. Basuki Rahmat No. 50, Malang, Jawa Timur, Indonesia', // placeholder
      openingHours: '08:00 AM – 08:00 PM',
      latitude: -7.9850,
      longitude: 112.6190,
      ticketPrices: [],
      tourOptions: [],
      activities: ['Buy the famous pia cake as gift & snack'],
    ),
    const Destination(
      id: 'dest_14',
      name: 'Kampung Wisata Keramik Malang',
      description:
          'Sentra keramik dengan berbagai produk kerajinan tangan yang unik.',
      imageUrl:
          'assets/image/homepage_travel/kampung_wisata_keramik_picture.png',
      location: 'Malang',
      province: 'Jawa Timur',
      rating: 4.2,
      hasVirtualTour: false,
      category: 'Souvenir',
      distance: 8.9,
      address:
          'Jl. Soekarno-Hatta Km. 9, Malang, Jawa Timur, Indonesia', // placeholder
      openingHours: '09:00 AM – 06:00 PM',
      latitude: -7.9700,
      longitude: 112.6400,
      ticketPrices: [],
      tourOptions: [],
      activities: [
        'Explore ceramic craft demonstrations',
        'Purchase handmade ceramic souvenirs',
      ],
    ),
    const Destination(
      id: 'dest_15',
      name: 'Toko Apel Malang',
      description:
          'Pusat oleh-oleh apel dan produk turunannya yang khas dari Malang.',
      imageUrl: 'assets/image/homepage_travel/toko_apel_malang_picture.png',
      location: 'Batu',
      province: 'Jawa Timur',
      rating: 4.4,
      hasVirtualTour: false,
      category: 'Souvenir',
      distance: 18.5,
      address:
          'Jl. Raya Oro-Oro Ombo No. 5, Batu, Jawa Timur, Indonesia', // placeholder
      openingHours: '08:00 AM – 07:00 PM',
      latitude: -7.8810,
      longitude: 112.5280,
      ticketPrices: [],
      tourOptions: [],
      activities: ['Buy fresh Malang apples & apple products'],
    ),

    // Tour & Trip
    const Destination(
      id: 'dest_16',
      name: 'Omah Kayu Adventure',
      description:
          'Tempat wisata petualangan dengan berbagai aktivitas outdoor yang seru.',
      imageUrl: 'assets/image/homepage_travel/omah_kayu_adventure_picture.png',
      location: 'Batu',
      province: 'Jawa Timur',
      rating: 4.5,
      hasVirtualTour: false,
      category: 'Tour & Trip',
      distance: 19.2,
      address:
          'Jl. Trunojoyo No. 99, Batu, Jawa Timur, Indonesia', // placeholder
      openingHours: '08:00 AM – 05:00 PM',
      latitude: -7.8670,
      longitude: 112.5230,
      ticketPrices: [],
      tourOptions: [],
      activities: [
        'Stay in wooden tree-house lodging & enjoy nature',
        'Zipline and photo spots amidst forest scenery',
      ],
    ),
    const Destination(
      id: 'dest_17',
      name: 'Coban Talun',
      description:
          'Wisata air terjun dengan trekking yang menantang dan pemandangan alam yang indah.',
      imageUrl: 'assets/image/homepage_travel/coban_talun_picture.png',
      location: 'Batu',
      province: 'Jawa Timur',
      rating: 4.6,
      hasVirtualTour: false,
      category: 'Tour & Trip',
      distance: 24.1,
      address:
          'Dusun Wonokitri, Pujon, Batu, Jawa Timur, Indonesia', // placeholder
      openingHours: '07:30 AM – 05:00 PM',
      latitude: -7.8150,
      longitude: 112.5450,
      ticketPrices: [],
      tourOptions: [],
      activities: [
        'Trek forest trail to waterfall and enjoy autumn maple trees',
        'Camp overnight under the stars near waterfall',
      ],
    ),
    const Destination(
      id: 'dest_18',
      name: 'Wisata Petik Apel Batu',
      description:
          'Kebun apel dengan aktivitas petik apel langsung dan edukasi pertanian.',
      imageUrl:
          'assets/image/homepage_travel/wisata_petik_apel_batu_picture.png',
      location: 'Batu',
      province: 'Jawa Timur',
      rating: 4.4,
      hasVirtualTour: false,
      category: 'Tour & Trip',
      distance: 17.8,
      address:
          'Desa Tulungrejo, Bumiaji, Batu, Jawa Timur, Indonesia', // placeholder
      openingHours: '08:00 AM – 05:00 PM',
      latitude: -7.8640,
      longitude: 112.5200,
      ticketPrices: [],
      tourOptions: [],
      activities: [
        'Pick fresh apples from orchard & educate on apple farming',
        'Enjoy farm lunch and nature walk around orchard',
      ],
    ),
    const Destination(
      id: 'dest_19',
      name: 'Selecta Batu',
      description:
          'Taman wisata dengan kolam renang air panas dan taman bunga yang indah.',
      imageUrl: 'assets/image/homepage_travel/selecta_picture.png',
      location: 'Batu',
      province: 'Jawa Timur',
      rating: 4.3,
      hasVirtualTour: false,
      category: 'Tour & Trip',
      distance: 21.3,
      address:
          'Jl. Raya Selecta No. 1, Batu, Jawa Timur, Indonesia', // placeholder
      openingHours: '08:00 AM – 05:00 PM',
      latitude: -7.8675,
      longitude: 112.5380,
      ticketPrices: [],
      tourOptions: [],
      activities: [
        'Wander flower gardens and relax in hot-spring pool',
        'Family fun play area and picnic spots',
      ],
    ),
    const Destination(
      id: 'dest_20',
      name: 'Paralayang Batu',
      description:
          'Spot paralayang dengan pemandangan kota Batu dan Malang yang spektakuler.',
      imageUrl: 'assets/image/homepage_travel/paralayang_picture.png',
      location: 'Batu',
      province: 'Jawa Timur',
      rating: 4.7,
      hasVirtualTour: false,
      category: 'Tour & Trip',
      distance: 23.5,
      address:
          'Bukit Paragliding, Gunung Banyak, Batu, Jawa Timur, Indonesia', // placeholder
      openingHours: '09:00 AM – 05:00 PM',
      latitude: -7.8580,
      longitude: 112.5260,
      ticketPrices: [],
      tourOptions: [],
      activities: [
        'Tandem paragliding and enjoy aerial views of Batu & Malang',
        'Photography from vantage point at sunset',
      ],
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
        (i) => 'dest_${(index * 10 + i) % _destinations.length}',
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
