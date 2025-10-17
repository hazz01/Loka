# ANR (Application Not Responding) - Final Fix

## Problem Summary
Aplikasi terus mengalami ANR (Application Not Responding) dengan:
- Skipped 175 frames
- UI freeze saat load HomePage
- Data berhasil di-fetch tapi UI tidak responsive

## Root Causes Identified

### 1. **Blocking InitState**
```dart
// BEFORE ❌
@override
void initState() {
  super.initState();
  _loadDestinations(); // Blocks first frame render!
}
```

### 2. **Synchronous Heavy Operations**
- Parsing 27 Firestore documents di main thread
- Semua parsing dilakukan sekaligus tanpa pause
- `fromFirestore()` dipanggil 27x berturut-turut

### 3. **No UI Breathing Room**
- Tidak ada delay antara operations
- UI tidak punya kesempatan untuk render frame

## Complete Solutions Applied

### Fix 1: Post Frame Callback
```dart
@override
void initState() {
  super.initState();
  // ✅ Allow first frame to render, then load data
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _loadDestinations();
  });
}
```

**Benefit**: UI dapat render frame pertama sebelum mulai load data

### Fix 2: Batch Processing
```dart
// Parse in batches of 10 with delays
const batchSize = 10;
for (int i = 0; i < querySnapshot.docs.length; i += batchSize) {
  final batch = querySnapshot.docs.sublist(i, end);
  
  // Parse batch
  for (var doc in batch) {
    final destination = Destination.fromFirestore(doc.data(), doc.id);
    destinations.add(destination);
  }
  
  // ✅ Give UI time to breathe
  if (end < querySnapshot.docs.length) {
    await Future.delayed(const Duration(milliseconds: 10));
  }
}
```

**Benefit**: UI tetap responsive saat parsing data

### Fix 3: Timeout Protection
```dart
final querySnapshot = await _firestore
    .collection(_collectionPath)
    .get()
    .timeout(const Duration(seconds: 10)); // ✅ Prevent infinite wait
```

**Benefit**: Aplikasi tidak hang jika Firestore lambat

### Fix 4: Mounted Checks
```dart
Future<void> _loadDestinations() async {
  if (!mounted) return; // ✅ Check before async op
  
  setState(() { isLoading = true; });
  
  // ... async operations ...
  
  if (!mounted) return; // ✅ Check before setState
  
  setState(() { 
    recommendedDestinations = recommended;
    isLoading = false;
  });
}
```

**Benefit**: Prevent setState on unmounted widget

### Fix 5: Error Handling & Retry
```dart
catch (e) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to load: $e'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () {
            _allDestinations.clear();
            _loadDestinations(); // ✅ Allow user to retry
          },
        ),
      ),
    );
  }
}
```

**Benefit**: User dapat retry jika gagal

### Fix 6: Reduced Logging
```dart
// BEFORE ❌
for (var doc in docs) {
  print('✓ Parsed: ${destination.name}'); // 27 logs!
}

// AFTER ✅
print('✅ Loaded $successCount destinations successfully'); // 1 log
```

**Benefit**: Less console overhead

## Performance Comparison

| Metric | Before | After |
|--------|--------|-------|
| InitState Blocking | Yes | No |
| Parse Strategy | All at once | Batched (10 docs) |
| UI Pauses | None | Every 10 docs |
| Timeout | None | 10 seconds |
| Mounted Checks | No | Yes |
| Error Recovery | No | Yes with retry |
| Logging Overhead | High (27 logs) | Low (1-2 logs) |

## Expected Results

### With These Fixes:
1. ✅ First frame renders immediately (loading indicator visible)
2. ✅ Data loads progressively without freezing UI
3. ✅ No more "Skipped frames" warnings
4. ✅ Smooth animations during data load
5. ✅ App stays responsive
6. ✅ Graceful error handling

### Load Timeline:
```
0ms   - InitState called
16ms  - First frame rendered (loading indicator shown)
50ms  - Post frame callback triggered
100ms - Firestore query initiated
500ms - First batch (10 docs) parsed
510ms - UI breathes (10ms delay)
520ms - Second batch parsed
530ms - UI breathes
540ms - Third batch parsed
550ms - All done, UI updated
```

## Testing Checklist

Run app and verify:

- [ ] Loading indicator appears immediately
- [ ] No "Skipped frames" in logs
- [ ] App stays responsive during load
- [ ] Data appears after ~500-1000ms
- [ ] No ANR dialogs
- [ ] Category switching is instant
- [ ] Error messages show if network fails
- [ ] Retry button works

## If Still Having Issues

### Check 1: Device Performance
```bash
adb shell dumpsys cpuinfo | grep loka
```
If CPU usage > 80%, device might be overloaded

### Check 2: Network Speed
```dart
// Add timing logs
final stopwatch = Stopwatch()..start();
final querySnapshot = await _firestore.collection(_collectionPath).get();
print('⏱️ Firestore fetch took: ${stopwatch.elapsedMilliseconds}ms');
```
If > 2000ms, network is slow

### Check 3: Data Size
```dart
print('📦 Data size: ${querySnapshot.docs.length} documents');
for (var doc in querySnapshot.docs) {
  print('  ${doc.id}: ${doc.data().toString().length} bytes');
}
```
If documents are huge, consider limiting fields

### Alternative Solution: Lazy Loading
If still slow, implement lazy loading:

```dart
// Load in chunks as user scrolls
Future<List<Destination>> getDestinationsPaginated({
  int limit = 10,
  DocumentSnapshot? startAfter,
}) async {
  Query query = _firestore.collection(_collectionPath).limit(limit);
  
  if (startAfter != null) {
    query = query.startAfterDocument(startAfter);
  }
  
  final snapshot = await query.get();
  return snapshot.docs
      .map((doc) => Destination.fromFirestore(doc.data()!, doc.id))
      .toList();
}
```

## Files Modified

1. `lib/features/home/pages/home_page.dart`
   - Added PostFrameCallback
   - Added mounted checks
   - Added error handling

2. `lib/shared/data/destination_repository.dart`
   - Added batch processing
   - Added timeout
   - Reduced logging

3. `ANR_FIX_FINAL.md` (this file)
   - Complete documentation

## Additional Optimizations (Future)

### 1. Image Lazy Loading
```dart
CachedNetworkImage(
  imageUrl: destination.imageUrl,
  placeholder: (context, url) => Shimmer(...),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

### 2. Virtual Scrolling
Use `ListView.builder` instead of `ListView` for large lists

### 3. Indexing
Add Firestore indexes for faster queries:
```
Collection: destination
Index: category ASC, createdAt DESC
```

### 4. Persistent Cache
```dart
// Save to local storage
final prefs = await SharedPreferences.getInstance();
await prefs.setString('cached_destinations', jsonEncode(destinations));

// Load from cache first
final cached = prefs.getString('cached_destinations');
if (cached != null) {
  _allDestinations = jsonDecode(cached);
  setState(() { isLoading = false; });
}
```

## Monitoring

Add performance monitoring:

```dart
import 'package:flutter/scheduler.dart';

void checkPerformance() {
  SchedulerBinding.instance.addTimingsCallback((timings) {
    for (var timing in timings) {
      if (timing.buildDuration.inMilliseconds > 16) {
        print('⚠️ Slow build: ${timing.buildDuration.inMilliseconds}ms');
      }
    }
  });
}
```

## Success Criteria

App is considered fixed when:
- ✅ No frames skipped during initial load
- ✅ Loading indicator appears within 16ms
- ✅ Data loads within 1000ms on good network
- ✅ App stays responsive throughout
- ✅ No ANR warnings in logs
- ✅ Smooth 60fps animations

Test on:
- [ ] Low-end device (2GB RAM)
- [ ] Mid-range device (4GB RAM)
- [ ] High-end device (8GB+ RAM)
- [ ] Slow network (2G simulation)
- [ ] Fast network (WiFi)
