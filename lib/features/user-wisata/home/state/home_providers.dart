import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Selected category provider for HomePage so the selection persists across
/// navigation (Explore -> Detail -> back to Home will keep the selected value).
final selectedCategoryProvider = StateProvider<String>((ref) => 'Partner');
