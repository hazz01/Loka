# Migrasi dari Mock Data ke Firestore

## Ringkasan Perubahan

Aplikasi Loka telah diubah dari menggunakan mock data menjadi mengambil data dari Firestore. Berikut adalah perubahan yang telah dilakukan:

## 1. Model Destination yang Diperbarui

File: `lib/shared/data/models.dart`

### Field Baru dari Firestore:
- `address` - Alamat lengkap destinasi
- `activitiesDescription` - Deskripsi aktivitas yang tersedia
- `availability` - Status ketersediaan (available/unavailable)
- `openingHours` - Jam operasional (format: "HH:mm - HH:mm")
- `tags` - List string untuk kategori (adventure, beach, nature, dll)
- `ticketPrice` - Harga tiket dalam integer (Rupiah)
- `title` - Judul destinasi

### Field dengan Mock Data:
- `rating` - Generate dari hashCode (4.0 - 4.9)
- `distance` - Generate dari hashCode (1.0 - 50.0 km)

### Method Baru:
- `fromFirestore()` - Factory method untuk membuat Destination dari Firestore document
- `toFirestore()` - Method untuk convert Destination ke Firestore document
- `_getCategoryFromTags()` - Helper method untuk mapping tags ke category

## 2. Repository Pattern

File: `lib/shared/data/destination_repository.dart`

### Method yang Tersedia:
- `getAllDestinations()` - Mengambil semua destinasi
- `getDestinationById(String id)` - Mengambil destinasi berdasarkan ID
- `getDestinationsByCategory(String category)` - Filter berdasarkan kategori
- `getDestinations()` - Dengan pagination dan search
- `getNearestDestinations()` - Sort berdasarkan distance (mock)
- `streamDestinations()` - Real-time updates
- `streamDestinationsByCategory()` - Real-time updates by category
- `addDestination()` - Tambah destinasi baru
- `updateDestination()` - Update destinasi
- `deleteDestination()` - Hapus destinasi

## 3. Firebase Initialization

File: `lib/main.dart`

Firebase diinisialisasi di `main()` dengan:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: LokaApp()));
}
```

## 4. Halaman yang Diupdate

### HomePage (`lib/features/home/pages/home_page.dart`)
- Mengganti `MockDataSource` dengan `DestinationRepository`
- Menambahkan loading state dan error handling
- Category tabs sekarang async

### ExplorePage (`lib/features/home/pages/explore_page.dart`)
- Menggunakan `DestinationRepository`
- Async data loading dengan proper error handling

### SearchPage (`lib/features/search/pages/search_page.dart`)
- Pagination menggunakan Firestore
- Search query bekerja dengan repository

### TripPlanPage (`lib/features/saved/pages/trip_plan_page.dart`)
- Mengambil detail destinasi dari Firestore
- Menambahkan loading state

## 5. Struktur Data Firestore

### Collection: `destination`
### Document ID: [auto-generated atau custom]

```json
{
  "activitiesDescription": "Foto-foto, camping, menikmati pemandangan pantai.",
  "address": "Sitiarjo, Malang",
  "availability": "available",
  "description": "Pantai dengan ombak besar dan batu karang unik.",
  "openingHours": "06:00 - 18:00",
  "tags": ["adventure", "beach", "nature"],
  "ticketPrice": 15000,
  "title": "Pantai Goa Cina"
}
```

### Mapping Category dari Tags:
- Tags: `culinary`, `food` → Category: "Culinary"
- Tags: `shopping`, `souvenir` → Category: "Souvenir"
- Tags: `adventure`, `tour` → Category: "Tour & Trip"
- Default → Category: "Tourist Attraction"

## 6. Catatan Penting

### Mock Data yang Masih Digunakan:
1. **Rating**: Digenerate dari hash document ID untuk konsistensi
2. **Distance**: Digenerate dari hash document ID untuk sorting
3. **Province**: Hardcoded "Jawa Timur" (bisa disesuaikan)
4. **hasVirtualTour**: Default false
5. **imageUrl**: Kosong (tidak ada di Firestore)

### TripPlans:
TripPlans masih menggunakan MockDataSource karena belum ada collection di Firestore untuk ini.

## 7. Cara Menggunakan

### Menambah Data ke Firestore:
```dart
final repository = DestinationRepository();
final destination = Destination(
  id: '', // akan di-generate
  name: 'Nama Destinasi',
  // ... field lainnya
);

final docId = await repository.addDestination(destination);
```

### Mengambil Data:
```dart
// Semua destinasi
final destinations = await repository.getAllDestinations();

// By category
final touristSpots = await repository.getDestinationsByCategory('Tourist Attraction');

// By ID
final dest = await repository.getDestinationById('dest024');

// Real-time stream
repository.streamDestinations().listen((destinations) {
  // Update UI
});
```

## 8. Dependencies yang Dibutuhkan

Pastikan `pubspec.yaml` memiliki:
```yaml
dependencies:
  cloud_firestore: ^latest_version
  firebase_core: ^latest_version
```

## 9. Perubahan untuk Developer

### Sebelum (Mock):
```dart
final destinations = MockDataSource.getDestinationsByCategory('Culinary');
```

### Sesudah (Firestore):
```dart
final repository = DestinationRepository();
final destinations = await repository.getDestinationsByCategory('Culinary');
```

### Loading State:
Semua halaman sekarang memiliki loading indicator saat mengambil data dari Firestore.

## 10. Next Steps (Opsional)

1. Tambahkan caching untuk mengurangi Firestore reads
2. Implementasi offline persistence
3. Tambahkan imageUrl ke Firestore schema
4. Migrate TripPlans ke Firestore
5. Tambahkan field province yang dinamis ke Firestore
6. Implementasi search yang lebih advanced dengan Algolia atau sejenisnya
