import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';

/// Helper script untuk upload sample data ke Firestore
/// Jalankan dengan: flutter run lib/shared/data/upload_sample_data.dart
/// 
/// PERINGATAN: Script ini akan menambahkan data ke Firestore.
/// Pastikan Anda memiliki akses ke Firestore dan ingin menambahkan data.

void main() async {
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;

  // Sample data berdasarkan schema yang diberikan
  final List<Map<String, dynamic>> sampleDestinations = [
    {
      "id": "dest024",
      "activitiesDescription": "Foto-foto, camping, menikmati pemandangan pantai.",
      "address": "Sitiarjo, Malang",
      "availability": "available",
      "description": "Pantai dengan ombak besar dan batu karang unik.",
      "openingHours": "06:00 - 18:00",
      "tags": ["adventure", "beach", "nature"],
      "ticketPrice": 15000,
      "title": "Pantai Goa Cina"
    },
    {
      "id": "dest001",
      "activitiesDescription": "Tur museum, berfoto dengan koleksi kendaraan antik.",
      "address": "Jl. Terusan Sultan Agung No.2, Batu, Malang",
      "availability": "available",
      "description": "Museum transportasi terlengkap di Asia dengan koleksi kendaraan dari berbagai era.",
      "openingHours": "12:00 - 20:00",
      "tags": ["education", "museum", "family"],
      "ticketPrice": 100000,
      "title": "Museum Angkut"
    },
    {
      "id": "dest002",
      "activitiesDescription": "Bermain wahana, melihat hewan di kebun binatang.",
      "address": "Jl. Oro-Oro Ombo No.9, Batu, Malang",
      "availability": "available",
      "description": "Taman wisata dengan kebun binatang dan museum satwa yang edukatif.",
      "openingHours": "08:30 - 17:00",
      "tags": ["family", "education", "zoo"],
      "ticketPrice": 120000,
      "title": "Jatim Park 2"
    },
    {
      "id": "dest003",
      "activitiesDescription": "Trekking, menikmati air terjun, berfoto dengan latar alam.",
      "address": "Jl. Coban Rondo, Pandesari, Pujon, Malang",
      "availability": "available",
      "description": "Air terjun yang indah dengan suasana sejuk dan pemandangan yang memukau.",
      "openingHours": "07:00 - 17:00",
      "tags": ["nature", "adventure", "tour"],
      "ticketPrice": 25000,
      "title": "Coban Rondo"
    },
    {
      "id": "dest004",
      "activitiesDescription": "Sunrise tour, trekking ke kawah, fotografi landscape.",
      "address": "Taman Nasional Bromo Tengger Semeru, Probolinggo",
      "availability": "available",
      "description": "Taman nasional dengan pemandangan gunung berapi yang spektakuler.",
      "openingHours": "00:00 - 23:59",
      "tags": ["adventure", "nature", "tour"],
      "ticketPrice": 34000,
      "title": "Gunung Bromo"
    },
    {
      "id": "dest005",
      "activitiesDescription": "Makan soto ayam, nasi goreng, dan menu Indonesia lainnya.",
      "address": "Jl. Kawi No.31, Malang",
      "availability": "available",
      "description": "Restoran dengan masakan Indonesia yang lezat dan suasana yang nyaman.",
      "openingHours": "08:00 - 22:00",
      "tags": ["culinary", "food", "restaurant"],
      "ticketPrice": 50000,
      "title": "Warung Makan Barokah"
    },
    {
      "id": "dest006",
      "activitiesDescription": "Trekking, menikmati kebun bunga, berfoto di air terjun.",
      "address": "Jl. Coban Talun, Tulungrejo, Bumiaji, Batu",
      "availability": "available",
      "description": "Air terjun dengan trekking yang menantang dan kebun bunga yang indah.",
      "openingHours": "07:00 - 17:00",
      "tags": ["nature", "adventure", "tour"],
      "ticketPrice": 25000,
      "title": "Coban Talun"
    },
    {
      "id": "dest007",
      "activitiesDescription": "Wisata kuliner, belanja oleh-oleh, berfoto di kampung heritage.",
      "address": "Jl. Majapahit, Malang",
      "availability": "available",
      "description": "Kampung heritage dengan berbagai kuliner khas Malang dan spot foto Instagramable.",
      "openingHours": "09:00 - 21:00",
      "tags": ["culinary", "shopping", "heritage"],
      "ticketPrice": 0,
      "title": "Heritage Kajoetangan"
    },
    {
      "id": "dest008",
      "activitiesDescription": "Berenang, bersantai di taman, menikmati pemandangan pegunungan.",
      "address": "Jl. Raya Selecta No.1, Tulungrejo, Batu",
      "availability": "available",
      "description": "Taman wisata dengan kolam renang air panas dan taman bunga yang indah.",
      "openingHours": "07:00 - 17:00",
      "tags": ["nature", "family", "tour"],
      "ticketPrice": 35000,
      "title": "Selecta"
    },
    {
      "id": "dest009",
      "activitiesDescription": "Makan bakso, mie ayam, dan menu lainnya dengan suasana santai.",
      "address": "Jl. Gajayana No.38, Malang",
      "availability": "available",
      "description": "Rumah makan bakso legendaris dengan cita rasa yang khas dan porsi melimpah.",
      "openingHours": "10:00 - 22:00",
      "tags": ["culinary", "food"],
      "ticketPrice": 35000,
      "title": "Bakso President"
    },
  ];

  print('Starting upload to Firestore...');
  print('Collection: destination');
  print('Total documents: ${sampleDestinations.length}');
  print('---');

  int successCount = 0;
  int failCount = 0;

  for (var destination in sampleDestinations) {
    try {
      final docId = destination['id'] as String;
      final data = Map<String, dynamic>.from(destination);
      data.remove('id'); // Remove id from data as it will be the document ID

      await firestore.collection('destination').doc(docId).set(data);
      print('✓ Uploaded: ${destination['title']} (ID: $docId)');
      successCount++;
    } catch (e) {
      print('✗ Failed: ${destination['title']} - Error: $e');
      failCount++;
    }
  }

  print('---');
  print('Upload complete!');
  print('Success: $successCount');
  print('Failed: $failCount');
  print('');
  print('You can now view your data in Firebase Console:');
  print('https://console.firebase.google.com/project/_/firestore/data');
}
