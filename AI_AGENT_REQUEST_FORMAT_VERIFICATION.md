# Verifikasi Format Request ke AI Agent Endpoint

## Tanggal: 31 Januari 2026

## ✅ Status: FORMAT SUDAH 100% SESUAI

### Format Request yang Dikirim

Aplikasi mengirimkan data ke endpoint AI Agent dengan format sebagai berikut:

```json
[
  {
    "userId": "user123",
    "tripType": {
      "type": "city",
      "name": "Batu"
    },
    "targetCities": [
      "Batu"
    ],
    "budget": 500000,
    "peopleCount": 3,
    "tripDuration": 1,
    "tripStart": {
      "date": "2025-10-20",
      "daypart": "morning"
    },
    "tripEnd": {
      "date": "2025-10-21",
      "daypart": "evening"
    },
    "categories": [
      "family",
      "nature"
    ],
    "preferences": {
      "transportMode": "car",
      "restPreference": "moderate",
      "mealPreference": "local food",
      "pace": "balanced"
    }
  }
]
```

### Implementasi di Kode

#### 1. Model Request (`lib/features/home/models/trip_request_model.dart`)

```dart
class TripRequest {
  final String userId;
  final TripType tripType;
  final List<String> targetCities;
  final int budget;
  final int peopleCount;
  final int tripDuration;
  final TripDateTime tripStart;
  final TripDateTime tripEnd;
  final List<String> categories;
  final TripPreferences preferences;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'tripType': tripType.toJson(),
      'targetCities': targetCities,
      'budget': budget,
      'peopleCount': peopleCount,
      'tripDuration': tripDuration,
      'tripStart': tripStart.toJson(),
      'tripEnd': tripEnd.toJson(),
      'categories': categories,
      'preferences': preferences.toJson(),
    };
  }
}
```

**✅ Tidak ada property tambahan yang dikirimkan.**

#### 2. Service Layer (`lib/features/home/services/trip_service.dart`)

```dart
static Future<TripResponse> createTrip(TripRequest request) async {
  final url = Uri.parse('$baseUrl/MakingTrip');
  
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode([request.toJson()]), // Array dengan 1 object
  );
  // ...
}
```

**✅ Data dikirim sebagai array dengan format yang tepat.**

### Struktur Sub-Models

#### TripType
```dart
Map<String, dynamic> toJson() {
  return {
    'type': type,      // "city", "greater_city", "province"
    'name': name,      // Nama kota/provinsi
  };
}
```

#### TripDateTime
```dart
Map<String, dynamic> toJson() {
  return {
    'date': date,      // Format: "YYYY-MM-DD"
    'daypart': daypart, // "morning", "noon", "evening", "night"
  };
}
```

#### TripPreferences
```dart
Map<String, dynamic> toJson() {
  return {
    'transportMode': transportMode,      // e.g., "car"
    'restPreference': restPreference,    // e.g., "moderate"
    'mealPreference': mealPreference,    // e.g., "local food"
    'pace': pace,                        // e.g., "balanced"
  };
}
```

### Endpoint Configuration

```dart
static const String baseUrl = 'https://michie-mykisah.app.n8n.cloud/webhook';
// Endpoint lengkap: https://michie-mykisah.app.n8n.cloud/webhook/MakingTrip
```

### Contoh Real Usage dari Kode

#### Dari Greater City Page:
```dart
final request = TripRequest(
  userId: "user123",
  tripType: TripType(type: "greater_city", name: selectedCity!),
  targetCities: [selectedCity!],
  budget: cost!.toInt(),
  peopleCount: people,
  tripDuration: duration,
  tripStart: TripDateTime(
    date: DateFormat('yyyy-MM-dd').format(startDate!),
    daypart: mapTimeOfDay(startTime!),
  ),
  tripEnd: TripDateTime(
    date: DateFormat('yyyy-MM-dd').format(endDate!),
    daypart: mapTimeOfDay(endTime!),
  ),
  categories: getSelectedCategories(),
  preferences: TripPreferences(
    transportMode: "car",
    restPreference: "moderate",
    mealPreference: "local food",
    pace: "balanced",
  ),
);

final response = await TripService.createTrip(request);
```

### Verifikasi Properties

| Property | Type | Required | Source | Status |
|----------|------|----------|--------|--------|
| userId | String | ✅ | Hardcoded "user123" | ✅ Sent |
| tripType | Object | ✅ | User selection | ✅ Sent |
| tripType.type | String | ✅ | Category type | ✅ Sent |
| tripType.name | String | ✅ | City/Province name | ✅ Sent |
| targetCities | Array[String] | ✅ | Selected cities | ✅ Sent |
| budget | Integer | ✅ | User input | ✅ Sent |
| peopleCount | Integer | ✅ | User input | ✅ Sent |
| tripDuration | Integer | ✅ | Calculated from dates | ✅ Sent |
| tripStart | Object | ✅ | User input | ✅ Sent |
| tripStart.date | String | ✅ | Date picker | ✅ Sent |
| tripStart.daypart | String | ✅ | Time selection | ✅ Sent |
| tripEnd | Object | ✅ | User input | ✅ Sent |
| tripEnd.date | String | ✅ | Date picker | ✅ Sent |
| tripEnd.daypart | String | ✅ | Time selection | ✅ Sent |
| categories | Array[String] | ✅ | Category selection | ✅ Sent |
| preferences | Object | ✅ | Hardcoded values | ✅ Sent |
| preferences.transportMode | String | ✅ | Hardcoded "car" | ✅ Sent |
| preferences.restPreference | String | ✅ | Hardcoded "moderate" | ✅ Sent |
| preferences.mealPreference | String | ✅ | Hardcoded "local food" | ✅ Sent |
| preferences.pace | String | ✅ | Hardcoded "balanced" | ✅ Sent |

### ✅ Kesimpulan

**TIDAK ADA PROPERTY TAMBAHAN** yang dikirimkan ke endpoint AI Agent.

Format request yang dikirimkan adalah **100% sesuai** dengan format yang diinginkan:
- ✅ Dikirim sebagai array dengan 1 element
- ✅ Semua property sesuai dengan spesifikasi
- ✅ Tidak ada property extra
- ✅ Struktur nested objects (tripType, tripStart, tripEnd, preferences) sudah benar
- ✅ Tipe data sudah sesuai (String, Integer, Array)
- ✅ Format tanggal sudah benar (YYYY-MM-DD)

### Testing

Untuk memverifikasi, dapat dilakukan testing dengan:

1. **Debug Print di Service:**
   ```dart
   print('Request Body: ${jsonEncode([request.toJson()])}');
   ```

2. **Network Inspector:**
   - Gunakan tools seperti Charles Proxy atau Flutter DevTools
   - Inspect network request ke endpoint
   - Verify request body matches expected format

3. **Backend Logging:**
   - Check backend logs untuk melihat exact payload yang diterima
   - Pastikan tidak ada extra properties

### Files Involved

1. `lib/features/home/models/trip_request_model.dart` - Model definition
2. `lib/features/home/services/trip_service.dart` - API call
3. `lib/features/home/pages/kategori_city_page.dart` - City page implementation
4. `lib/features/home/pages/kategori_greater_city_page.dart` - Greater City page implementation
5. `lib/features/home/pages/kategori_provinsi_page.dart` - Province page implementation

### Update History

- **31 Januari 2026**: Verified format is 100% correct, no extra properties sent
