# Performance Optimization - Firestore Integration

## Masalah yang Diperbaiki

### Issue:
Aplikasi menjadi **not responding** (ANR) saat membuka HomePage karena:
1. Fetching data dari Firestore 2 kali secara bersamaan
2. Setiap kali ganti category, fetch data baru dari Firestore
3. Terlalu banyak print statements di main thread
4. UI blocking karena operasi async yang tidak dioptimalkan

### Error Log:
```
Skipped 149 frames! The application may be doing too much work on its main thread.
```

## Solusi yang Diimplementasikan

### 1. **Caching Strategy** di HomePage
```dart
List<Destination> _allDestinations = []; // Cache all destinations
```

- Fetch semua data **HANYA SEKALI** saat pertama kali load
- Simpan di memory sebagai cache
- Gunakan cache untuk filtering selanjutnya

### 2. **In-Memory Filtering**
Sebelum:
```dart
// Fetch dari Firestore setiap kali ganti category ❌
final destinations = await _repository.getDestinationsByCategory(selectedCategory);
```

Sesudah:
```dart
// Filter dari cache di memory ✅
recommendedDestinations = _allDestinations
    .where((dest) => dest.category == selectedCategory)
    .toList();
```

### 3. **Single Fetch, Multiple Use**
```dart
Future<void> _loadDestinations() async {
  // Fetch once
  if (_allDestinations.isEmpty) {
    _allDestinations = await _repository.getAllDestinations();
  }
  
  // Filter for recommended
  final recommended = _allDestinations
      .where((dest) => dest.category == selectedCategory)
      .toList();
  
  // Sort for nearest
  final nearest = List<Destination>.from(_allDestinations);
  nearest.sort((a, b) => a.distance.compareTo(b.distance));
  final nearestLimited = nearest.take(10).toList();
  
  setState(() {
    recommendedDestinations = recommended;
    nearestDestinations = nearestLimited;
    isLoading = false;
  });
}
```

### 4. **Reduced Logging**
Mengurangi print statements dari:
- ❌ Print untuk setiap dokumen (27 dokumen = 27 logs)

Menjadi:
- ✅ Print summary saja (1 log untuk semua)

```dart
print('✅ Loaded $successCount destinations successfully');
if (errorCount > 0) {
  print('⚠️  Failed to parse $errorCount documents');
}
```

### 5. **Instant Category Switch**
Sekarang switching category tidak perlu loading karena menggunakan data yang sudah ada di memory:

```dart
_buildCategoryChip(
  'Culinary',
  LucideIcons.utensilsCrossed,
  selectedCategory == 'Culinary',
  () {
    setState(() {
      selectedCategory = 'Culinary';
      // Instant filtering - no async needed!
      recommendedDestinations = _allDestinations
          .where((dest) => dest.category == selectedCategory)
          .toList();
    });
  },
)
```

## Performance Improvements

### Before:
- ❌ 2 Firestore fetches on load (slow)
- ❌ 1 Firestore fetch per category switch
- ❌ 149 frames skipped
- ❌ Application not responding
- ❌ 27+ print statements per load

### After:
- ✅ 1 Firestore fetch on load (faster)
- ✅ 0 Firestore fetches on category switch (instant!)
- ✅ Smooth UI
- ✅ No ANR
- ✅ 2-3 print statements per load

## Benefits

1. **Faster Initial Load**: Single fetch instead of double
2. **Instant Category Switch**: No network calls, pure memory operation
3. **Better UX**: Smooth transitions, no loading spinner for category changes
4. **Reduced Firestore Reads**: Saves quota and costs
5. **Lower Latency**: All operations after initial load are instant

## Trade-offs

### Pros:
- Much faster user experience
- Lower Firestore costs
- Smoother UI
- No more ANR issues

### Cons:
- Uses more memory (storing all destinations)
- Data might be stale until app restart or manual refresh
- Not real-time (but can be fixed with refresh button if needed)

## Memory Usage

With 27 destinations:
- Estimated memory: ~50-100 KB
- Acceptable for modern devices
- Can be cleared on dispose if needed

## Future Enhancements (Optional)

1. **Pull-to-Refresh**: Allow users to refresh data manually
```dart
RefreshIndicator(
  onRefresh: () async {
    _allDestinations.clear();
    await _loadDestinations();
  },
  child: ...
)
```

2. **Periodic Auto-Refresh**: Refresh data every X minutes
```dart
Timer.periodic(Duration(minutes: 5), (_) {
  _allDestinations.clear();
  _loadDestinations();
});
```

3. **Smart Cache Invalidation**: Clear cache after certain time
```dart
DateTime? _lastFetch;

Future<void> _loadDestinations() async {
  final needsRefresh = _lastFetch == null || 
      DateTime.now().difference(_lastFetch!) > Duration(minutes: 10);
      
  if (needsRefresh) {
    _allDestinations = await _repository.getAllDestinations();
    _lastFetch = DateTime.now();
  }
  // ... rest of code
}
```

4. **Persistent Cache**: Save to local storage
```dart
// Using shared_preferences or hive
await prefs.setString('cached_destinations', jsonEncode(_allDestinations));
```

## Testing

Setelah perubahan ini, test:
1. ✅ App tidak lagi freeze saat load
2. ✅ Category switch instant
3. ✅ No ANR errors
4. ✅ Smooth scrolling
5. ✅ Data tetap accurate

## Notes

- Cache akan di-clear saat:
  - App restart
  - Hot restart (development)
  - Widget rebuild dengan new state
  
- Cache tidak akan di-clear saat:
  - Hot reload (development)
  - Navigation ke page lain
  - Screen rotation (kecuali state hilang)
