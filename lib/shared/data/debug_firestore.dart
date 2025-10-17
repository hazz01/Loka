import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import '../../firebase_options.dart';

/// Debug script untuk melihat data di Firestore
/// Jalankan dengan: flutter run lib/shared/data/debug_firestore.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;

  print('========================================');
  print('🔍 DEBUGGING FIRESTORE DATA');
  print('========================================\n');

  try {
    print('Fetching collection: destination');
    final querySnapshot = await firestore.collection('destination').get();
    
    print('Total documents found: ${querySnapshot.docs.length}\n');
    
    if (querySnapshot.docs.isEmpty) {
      print('⚠️  No documents found in collection "destination"');
      print('   Please upload data first using upload_sample_data.dart');
      return;
    }

    for (var doc in querySnapshot.docs) {
      print('─────────────────────────────────────');
      print('📄 Document ID: ${doc.id}');
      print('─────────────────────────────────────');
      
      final data = doc.data();
      
      // Check each field
      print('Fields:');
      data.forEach((key, value) {
        final valueType = value.runtimeType;
        print('  • $key: $value (Type: $valueType)');
      });
      
      // Check for potential issues
      print('\n🔍 Potential Issues:');
      
      // Check ticketPrice type
      if (data.containsKey('ticketPrice')) {
        final ticketPrice = data['ticketPrice'];
        if (ticketPrice is! int && ticketPrice is! double) {
          print('  ⚠️  ticketPrice is ${ticketPrice.runtimeType}, should be int or double');
          print('     Value: "$ticketPrice"');
        } else {
          print('  ✓ ticketPrice is correct type (${ticketPrice.runtimeType})');
        }
      } else {
        print('  ⚠️  ticketPrice field is missing');
      }
      
      // Check tags type
      if (data.containsKey('tags')) {
        final tags = data['tags'];
        if (tags is! List) {
          print('  ⚠️  tags is ${tags.runtimeType}, should be List');
        } else {
          print('  ✓ tags is List with ${tags.length} items');
        }
      } else {
        print('  ⚠️  tags field is missing');
      }
      
      // Check required fields
      final requiredFields = [
        'title',
        'description',
        'address',
        'availability',
        'openingHours',
      ];
      
      for (var field in requiredFields) {
        if (!data.containsKey(field)) {
          print('  ⚠️  Required field "$field" is missing');
        }
      }
      
      print('');
    }
    
    print('========================================');
    print('✅ Debug complete!');
    print('========================================');
    
  } catch (e, stackTrace) {
    print('❌ Error during debug: $e');
    print('Stack trace: $stackTrace');
  }
}
