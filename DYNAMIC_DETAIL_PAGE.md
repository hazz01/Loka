# Dynamic Detail Component Page

## Perubahan yang Dilakukan

### 1. **Model yang Diupdate**
File: `lib/shared/data/models.dart`

Model `Destination` yang sudah ada diupdate dengan field opsional untuk detail page:
- `address`: Alamat lengkap destinasi
- `openingHours`: Jam operasional
- `latitude`, `longitude`: Koordinat untuk map
- `ticketPrices`: List of `TicketPrice` (Weekday/Weekend)
- `tourOptions`: List of `TourOption`
- `activities`: List of aktivitas yang tersedia

**Sub-models:**
- `TicketPrice`: Model untuk harga tiket dengan availability
- `TourOption`: Model untuk paket tour tambahan

### 2. **Service Layer**
File: `lib/features/home/services/destination_detail_service.dart`

Service yang mengambil data dari `MockDataSource`:
- `getDestinationDetail(String id)`: Fetch data destinasi berdasarkan ID
- `getDestinationsByCategory(String category)`: Filter by kategori
- `getNearbyDestinations(int limit)`: Get destinasi terdekat
- `getVirtualTourDestinations()`: Get destinasi dengan virtual tour

### 3. **Mock Data Update**
File: `lib/shared/data/mock_data_source.dart`

Data destinasi diupdate dengan informasi lengkap untuk:
- `dest_1` (Jatim Park 1)
- `dest_2` (Museum Angkut)
- `dest_7` (Kampoeng Heritage Kajoetangan)

### 3. **Detail Component Page - Dinamis**
File: `lib/features/home/pages/detail_component_page.dart`

**Perubahan Utama:**

#### State Management
```dart
bool isLoading = true;
DestinationDetail? destinationDetail;
```

#### Loading State
- Menampilkan `CircularProgressIndicator` saat loading
- Menampilkan error state jika data tidak ditemukan

#### Data Dinamis
1. **Image**: Menggunakan `destinationDetail.imageUrl`
2. **Title & Rating**: Dari `destinationDetail.name` dan `destinationDetail.rating`
3. **Address**: Dari `destinationDetail.address`
4. **Opening Hours**: Dari `destinationDetail.openingHours`
5. **Description**: Dari `destinationDetail.description`
6. **Ticket Prices**: Loop dari `destinationDetail.ticketPrices`
7. **Tour Options**: Loop dari `destinationDetail.tourOptions`
8. **Map Coordinates**: Menggunakan `destinationDetail.latitude` dan `longitude`
9. **Activities**: Loop dari `destinationDetail.activities`

#### Fitur Dinamis
- **Ticket Selection**: Otomatis menyesuaikan dengan available tickets
- **Tour Selection**: Menggunakan tour ID untuk tracking selection
- **Price Calculation**: Menghitung total harga secara dinamis
- **Map Integration**: Koordinat dari data destinasi

### 4. **Cara Penggunaan**

#### Menambah Data Destinasi Baru
Edit file `destination_detail_service.dart` dan tambahkan entry baru di `_mockDestinations`:

```dart
'dest_new_id': const DestinationDetail(
  id: 'dest_new_id',
  name: 'Nama Destinasi',
  description: 'Deskripsi lengkap...',
  imageUrl: 'https://...',
  location: 'Kota',
  address: 'Alamat lengkap',
  province: 'Provinsi',
  rating: 4.5,
  hasVirtualTour: true,
  category: 'Category',
  distance: 10.5,
  openingHours: '8:00 AM - 5:00 PM',
  latitude: -7.1234,
  longitude: 112.5678,
  ticketPrices: [
    TicketPrice(type: 'Weekday', price: 50000, isAvailable: true),
    TicketPrice(type: 'Weekend', price: 75000, isAvailable: true),
  ],
  tourOptions: [
    TourOption(
      id: 'tour_1',
      name: 'Tour Name',
      description: 'Description',
      price: 100000,
      destinationCount: 5,
    ),
  ],
  activities: [
    'Activity 1',
    'Activity 2',
  ],
),
```

#### Testing
1. Navigasi ke detail page dengan ID destinasi yang valid
2. Coba switch antara Weekday dan Weekend tickets
3. Pilih tour options dan lihat perubahan harga
4. Test map interactivity dan directions
5. Test responsive di berbagai ukuran layar

### 5. **Benefits**

✅ **Maintainability**: Data terpisah dari UI logic
✅ **Scalability**: Mudah menambah destinasi baru
✅ **Flexibility**: Support berbagai konfigurasi ticket dan tour
✅ **Type Safety**: Full type checking dengan Dart models
✅ **Reusability**: Model dan service dapat digunakan di tempat lain

### 6. **Future Improvements**

- [ ] Integrasi dengan API backend
- [ ] Caching untuk improve performance
- [ ] Favorite functionality dengan local storage
- [ ] Review system integration
- [ ] Image gallery untuk multiple images
- [ ] Real-time availability check
- [ ] Dynamic pricing based on date/season
- [ ] Multi-language support

### 7. **API Integration (Future)**

Ketika ready untuk integrasi API, replace mock service dengan real API call:

```dart
static Future<DestinationDetail> getDestinationDetail(String id) async {
  final response = await http.get(
    Uri.parse('https://api.example.com/destinations/$id'),
  );
  
  if (response.statusCode == 200) {
    return DestinationDetail.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load destination');
  }
}
```

---

**Created**: October 17, 2025
**Status**: ✅ Completed and tested
