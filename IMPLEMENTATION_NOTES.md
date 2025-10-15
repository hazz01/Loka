# Implementasi Trip Planner dengan API Integration

## Overview
Implementasi ini mengintegrasikan halaman **Greater City** dan **Timeline Trip** dengan endpoint API untuk membuat trip plan secara dinamis.

## Endpoint API
- **URL**: `http://automation.brohaz.dev/webhook/NewTrip`
- **Method**: POST
- **Content-Type**: application/json

## File-file yang Dibuat/Dimodifikasi

### 1. Models
#### `lib/features/home/models/trip_request_model.dart`
Model untuk request ke API dengan struktur:
- `TripRequest` - Model utama request
- `TripType` - Jenis trip (city, greater_city, province)
- `TripDateTime` - Tanggal dan waktu perjalanan
- `TripPreferences` - Preferensi perjalanan (dummy data)

#### `lib/features/home/models/trip_response_model.dart`
Model untuk response dari API dengan struktur:
- `TripResponse` - Model utama response
- `DaySchedule` - Jadwal per hari
- `ActivitySchedule` - Aktivitas per jadwal

### 2. Service Layer
#### `lib/features/home/services/trip_service.dart`
Service untuk komunikasi dengan API:
```dart
TripService.createTrip(TripRequest request) // POST ke API
```

### 3. Pages (Updated)
#### `lib/features/home/pages/kategori_greater_city_page.dart`
**Perubahan:**
- Menambahkan fungsi `submitTripPlan()` untuk mengirim data ke API
- Menambahkan mapping kategori frontend ke format API
- Menambahkan loading state saat request API
- Navigasi ke timeline page dengan data response

**Flow:**
1. User mengisi form (kota, tanggal, budget, dll)
2. User memilih kategori
3. Klik "Next Process"
4. Call API dengan `TripService.createTrip()`
5. Navigate ke timeline page dengan response data

#### `lib/features/home/pages/timeline_trip_Page.dart`
**Perubahan:**
- Menerima `TripResponse?` sebagai parameter
- Fungsi `_loadApiData()` untuk convert response API ke model UI
- Fungsi `_loadDummyData()` sebagai fallback
- Menampilkan data dinamis dari API atau dummy

**Flow:**
1. Terima data dari navigation (extra parameter)
2. Convert `TripResponse` → `DayTrip` → `Activity`
3. Tampilkan timeline sesuai data API
4. Fallback ke dummy data jika tidak ada response

### 4. Routing (Updated)
#### `lib/routing/app_router.dart`
Update route timeline untuk menerima extra data:
```dart
GoRoute(
  path: 'timeline',
  name: 'timeline-trip',
  builder: (context, state) {
    final tripResponse = state.extra as TripResponse?;
    return TimelineTripPage(tripResponse: tripResponse);
  },
)
```

## Mapping Data

### Input Frontend → API Request
| Frontend Field | API Field | Notes |
|----------------|-----------|-------|
| selectedCity | tripType.name, targetCities | Nama kota |
| startDate | tripStart.date | Format: yyyy-MM-dd |
| endDate | tripEnd.date | Format: yyyy-MM-dd |
| startTime | tripStart.daypart | morning/noon/evening/night |
| endTime | tripEnd.daypart | morning/noon/evening/night |
| cost | budget | Integer |
| people | peopleCount | Integer |
| categories | categories | Array lowercase |
| - | tripDuration | Calculated from dates |
| - | preferences | **Dummy data** (hardcoded) |

### API Response → UI Display
| API Field | UI Field | Notes |
|-----------|----------|-------|
| days[].dayNumber | DayTrip.dayNumber | Nomor hari |
| days[].activities[] | Activity[] | List aktivitas |
| activityType | activityType | "travel" or "visit" |
| destinationName | destinationName | Nama destinasi |
| startTime, endTime | timeRange | Ditampilkan sebagai range |
| notes | description | Deskripsi aktivitas |
| - | imagePath | **Dummy** (default image) |
| - | price | **Dummy** ("Free") |
| - | address | **Dummy** (generated) |

## Dummy Data / Workaround

Karena ada ketidaksesuaian field antara frontend dan API, beberapa field menggunakan dummy data:

### Request (Hard-coded)
```dart
preferences: TripPreferences(
  transportMode: "car",
  restPreference: "moderate",
  mealPreference: "local food",
  pace: "balanced",
)
```

### Response (Generated)
```dart
imagePath: 'assets/image/kayutangan.png', // Default image
price: 'Free',
address: '${destinationName} Area',
```

## Testing

### Manual Test Flow:
1. Buka aplikasi
2. Navigate ke Trip AI Planner
3. Pilih "Greater City"
4. Isi form:
   - Pilih kota (Jakarta/Bogor/Depok/Tangerang/Bekasi)
   - Pilih tanggal mulai dan selesai
   - Pilih waktu mulai dan selesai
   - Isi budget (IDR)
   - Isi jumlah orang
   - Pilih kategori (minimal 1)
5. Klik "Next Process"
6. Tunggu loading
7. Lihat hasil timeline trip

### Test dengan Dummy Data:
Jika API tidak tersedia atau error, halaman timeline akan otomatis load dummy data.

## Dependencies Baru
- `http: ^1.2.2` - Untuk HTTP requests

## Error Handling
- Loading state saat request API
- Error dialog jika API gagal
- Fallback ke dummy data di timeline page
- Form validation sebelum submit

## Future Improvements
1. Tambahkan user authentication untuk `userId`
2. Implementasi trip preferences selection di UI
3. Cache response untuk offline access
4. Add loading screen yang lebih menarik
5. Implementasi image dari API atau database
6. Add retry mechanism untuk failed requests
7. Implementasi save trip plan ke local storage/backend

## Notes
- User ID saat ini hardcoded: "user123"
- Preferences menggunakan default values
- Image, price, dan address menggunakan dummy data
- Format date: yyyy-MM-dd
- Format time: HH:mm
- Daypart mapping: Morning/Noon/Evening/Night → lowercase
