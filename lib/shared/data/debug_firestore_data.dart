import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';

/// Debug script untuk melihat struktur data di Firestore
/// Jalankan dengan: flutter run lib/shared/data/debug_firestore_data.dart

void main() async {
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;

  print('===========================================');
  print('🔍 FIRESTORE DATA INSPECTOR');
  print('===========================================\n');

  try {
    print('📍 Fetching documents from collection: destination\n');
    
    final snapshot = await firestore.collection('destination').get();
    
    print('📊 Total documents: ${snapshot.docs.length}\n');
    print('===========================================\n');

    if (snapshot.docs.isEmpty) {
      print('⚠️  No documents found in collection!');
      print('');
      print('Please upload data first:');
      print('1. Run: flutter run lib/shared/data/upload_sample_data.dart');
      print('2. Or upload manually via Firebase Console');
      print('');
      return;
    }

    for (var doc in snapshot.docs) {
      print('📄 Document ID: ${doc.id}');
      print('─────────────────────────────────────────');
      
      final data = doc.data();
      
      // Print each field with type information
      data.forEach((key, value) {
        final valueType = value.runtimeType;
        final displayValue = value is List 
            ? '[${value.join(", ")}]' 
            : value.toString();
        
        print('   $key: $displayValue');
        print('   └─ Type: $valueType');
      });
      
      print('');
      
      // Check for type issues
      if (data['ticketPrice'] != null && data['ticketPrice'] is! int) {
        print('   ⚠️  WARNING: ticketPrice is ${data['ticketPrice'].runtimeType}, expected int');
        print('   Current value: ${data['ticketPrice']}');
        print('');
      }
    }

    print('===========================================');
    print('✅ Inspection complete!');
    print('===========================================');

  } catch (e, stackTrace) {
    print('❌ Error: $e');
    print('Stack trace: $stackTrace');
  }
}
