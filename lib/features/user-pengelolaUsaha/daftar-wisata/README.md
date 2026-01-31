# Local Destination Database

Database sementara untuk menyimpan data destination yang ditambahkan oleh pengelola usaha menggunakan SharedPreferences.

## Fitur

- ✅ **Tambah Destination**: Simpan destination baru ke database lokal
- ✅ **Lihat Semua Destination**: Tampilkan semua destination yang tersimpan
- ✅ **Update Destination**: Perbarui data destination yang sudah ada
- ✅ **Hapus Destination**: Hapus destination dari database
- ✅ **Filter by Status**: Filter destination berdasarkan status (Draft/Active)
- ✅ **Search**: Cari destination berdasarkan nama atau lokasi
- ✅ **Increment Views**: Hitung jumlah views pada setiap destination

## Struktur Data

Setiap destination disimpan dengan struktur data sebagai berikut:

```dart
{
  'id': 'local_dest_1234567890', // Auto-generated unique ID
  'name': 'Nama Destinasi',
  'description': 'Deskripsi lengkap destinasi',
  'location': 'Kota, Provinsi',
  'province': 'Nama Provinsi',
  'city': 'Nama Kota',
  'address': 'Alamat lengkap',
  'openingHours': '08:00 - 17:00',
  'image': 'assets/image/path.png',
  'images': [
    {'name': 'image1.jpg', 'path': 'assets/image/path1.png'},
    {'name': 'image2.jpg', 'path': 'assets/image/path2.png'},
  ],
  'tickets': [
    {'type': 'Weekday', 'price': 50000},
    {'type': 'Weekend', 'price': 75000},
  ],
  'tours': [
    {'name': 'Tour Name', 'description': 'Tour description', 'price': 100000},
  ],
  'activities': ['Activity 1', 'Activity 2'],
  'categories': ['Nature', 'Culture'],
  'has360Experience': false,
  'status': 'Draft', // 'Draft' atau 'Active'
  'views': 0,
  'createdAt': '2026-01-31T10:00:00.000Z',
  'updatedAt': '2026-01-31T10:00:00.000Z'
}
```

## Cara Penggunaan

### 1. Import Service

```dart
import '../services/local_destination_service.dart';
```

### 2. Tambah Destination Baru

```dart
final destinationData = {
  'name': 'Pantai Kuta',
  'description': 'Pantai yang indah...',
  'location': 'Badung, Bali',
  // ... data lainnya
};

final success = await LocalDestinationService.addDestination(destinationData);
if (success) {
  print('Destination berhasil ditambahkan!');
}
```

### 3. Ambil Semua Destinations

```dart
final destinations = await LocalDestinationService.getAllDestinations();
print('Total destinations: ${destinations.length}');
```

### 4. Ambil Destination by ID

```dart
final destination = await LocalDestinationService.getDestinationById('local_dest_1234567890');
if (destination != null) {
  print('Found: ${destination['name']}');
}
```

### 5. Update Destination

```dart
final updatedData = {
  'name': 'Pantai Kuta (Updated)',
  'description': 'Deskripsi baru...',
  // ... data lainnya
};

final success = await LocalDestinationService.updateDestination('local_dest_1234567890', updatedData);
```

### 6. Hapus Destination

```dart
final success = await LocalDestinationService.deleteDestination('local_dest_1234567890');
```

### 7. Filter by Status

```dart
// Ambil hanya destinations dengan status 'Draft'
final draftDestinations = await LocalDestinationService.getDestinationsByStatus('Draft');

// Ambil hanya destinations dengan status 'Active'
final activeDestinations = await LocalDestinationService.getDestinationsByStatus('Active');
```

### 8. Update Status

```dart
// Ubah status dari Draft ke Active
final success = await LocalDestinationService.updateDestinationStatus('local_dest_1234567890', 'Active');
```

### 9. Search Destinations

```dart
final results = await LocalDestinationService.searchDestinations('pantai');
print('Found ${results.length} destinations');
```

### 10. Increment Views

```dart
final success = await LocalDestinationService.incrementViews('local_dest_1234567890');
```

## Integrasi dengan UI

### Manager Destinations Page

`manager_destinations_page.dart` sudah terintegrasi dengan local database:

- ✅ Load destinations dari database saat halaman dibuka
- ✅ Refresh otomatis setelah menambah destination baru
- ✅ Tampilkan loading indicator saat fetch data
- ✅ Tampilkan message jika tidak ada destinations

### Add Destination Page

`add_destination_page.dart` sudah terintegrasi untuk menyimpan data:

- ✅ Validasi form sebelum submit
- ✅ Simpan data ke local database
- ✅ Generate ID unik otomatis
- ✅ Set default status sebagai 'Draft'
- ✅ Return result ke halaman sebelumnya untuk trigger refresh

## Testing

### Hapus Semua Data (untuk testing)

```dart
final success = await LocalDestinationService.clearAllDestinations();
```

### Cek Jumlah Destinations

```dart
final count = await LocalDestinationService.getDestinationsCount();
print('Total destinations: $count');
```

## Catatan Penting

1. **Data bersifat lokal**: Data hanya tersimpan di device dan tidak tersinkronisasi dengan server
2. **Persistensi**: Data akan tetap ada meskipun aplikasi ditutup dan dibuka lagi
3. **ID unik**: Setiap destination mendapat ID unik berdasarkan timestamp
4. **Status default**: Destination baru otomatis memiliki status 'Draft'
5. **Views counter**: Dimulai dari 0 dan bisa di-increment

## Future Improvements

- [ ] Sinkronisasi dengan API backend
- [ ] Backup dan restore data
- [ ] Export data ke JSON/CSV
- [ ] Image compression dan optimization
- [ ] Batch operations (bulk delete, bulk update status)
- [ ] Data encryption untuk keamanan
- [ ] Offline queue untuk sync nanti
