# Update Documentation - AI Trip Planner Response Format V2

## Tanggal Update
31 Januari 2026

## Ringkasan Perubahan
Mengupdate model response dari AI Trip Planner untuk mendukung format endpoint terbaru dengan struktur yang lebih lengkap, termasuk:
- **Cost Breakdown** untuk pemisahan biaya destinations, meals, dan travel
- **Activity Types** untuk membedakan visit, meal, dan travel activities
- **Meal ID** untuk referensi ke meal items
- **Detailed Cost per Activity** untuk estimasi biaya per aktivitas
- **Location Notes** untuk informasi lokasi yang lebih detail

## Format Response Endpoint V2

```json
{
  "summary": "string",
  "totalEstimatedCost": number,
  "costBreakdown": {
    "destinations": number,
    "meals": number,
    "travel": number
  },
  "days": [
    {
      "dayNumber": number,
      "activities": [
        {
          "activityType": "visit | meal | travel",
          "destinationId": "dest[uid] | null",
          "mealId": "meal[uid] | null",
          "name": "string",
          "startTime": "HH:MM",
          "endTime": "HH:MM",
          "estimatedCost": number,
          "locationNote": "string",
          "notes": "string"
        }
      ]
    }
  ]
}
```

## Perubahan Detail pada Model

### 1. TripResponse Class
**Fields Baru:**
- `costBreakdown?: CostBreakdown` - Breakdown biaya berdasarkan kategori

**Updated:**
- `totalEstimatedCost: num` - Tetap ada, berisi total dari semua biaya
- Backward compatibility tetap terjaga melalui computed getters

### 2. CostBreakdown Class (NEW)
Class baru untuk menampung informasi breakdown biaya:
```dart
class CostBreakdown {
  final num? destinations;  // Total biaya untuk destinasi/attraction
  final num? meals;          // Total biaya untuk makanan
  final num? travel;         // Total biaya untuk transportasi
}
```

**Parsing Features:**
- Support untuk int, double, dan String number format
- Semua field optional dengan default null
- Safe parsing dengan null handling

### 3. ActivitySchedule Class (MAJOR UPDATE)
**Fields Baru:**
```dart
- activityType: String        // "visit" | "meal" | "travel"
- mealId: String?             // ID untuk meal items
- name: String?               // Nama aktivitas
- estimatedCost: num?         // Biaya estimasi per aktivitas
- locationNote: String?       // Catatan lokasi detail
```

**Updated Fields:**
```dart
- destinationId: String?      // Sekarang optional, karena meal/travel tidak selalu punya destination
- notes: String               // Required, default empty string
- startTime: String           // Required
- endTime: String             // Required
```

**Field Order (by priority):**
1. `activityType` - Required, default "visit"
2. `destinationId` - Optional, untuk visit activities
3. `mealId` - Optional, untuk meal activities
4. `name` - Optional, nama aktivitas
5. `startTime` - Required
6. `endTime` - Required
7. `estimatedCost` - Optional, biaya per aktivitas
8. `locationNote` - Optional, informasi lokasi
9. `notes` - Required, catatan/deskripsi

## Activity Types Explanation

### 1. Visit Activity (activityType: "visit")
- **Purpose:** Kunjungan ke destinasi wisata
- **Required:** destinationId, name, startTime, endTime
- **Optional:** estimatedCost, locationNote, notes
- **Example:**
```json
{
  "activityType": "visit",
  "destinationId": "dest001",
  "mealId": null,
  "name": "Museum Angkut",
  "startTime": "09:00",
  "endTime": "11:30",
  "estimatedCost": 100000,
  "locationNote": "Jl. Terusan Sultan Agung No.2",
  "notes": "Start your day at Museum Angkut..."
}
```

### 2. Meal Activity (activityType: "meal")
- **Purpose:** Waktu makan (breakfast, lunch, dinner)
- **Required:** name, startTime, endTime
- **Optional:** mealId, estimatedCost, locationNote, notes
- **Example:**
```json
{
  "activityType": "meal",
  "destinationId": null,
  "mealId": "meal001",
  "name": "Lunch at Warung Soto Batu",
  "startTime": "12:00",
  "endTime": "13:00",
  "estimatedCost": 50000,
  "locationNote": "Jl. Panglima Sudirman No.99",
  "notes": "Enjoy authentic Malang cuisine..."
}
```

### 3. Travel Activity (activityType: "travel")
- **Purpose:** Perjalanan/transportasi antar lokasi
- **Required:** name, startTime, endTime
- **Optional:** estimatedCost, locationNote, notes
- **Example:**
```json
{
  "activityType": "travel",
  "destinationId": null,
  "mealId": null,
  "name": "Return to Hotel",
  "startTime": "18:30",
  "endTime": "19:00",
  "estimatedCost": 50000,
  "locationNote": "Hotel area",
  "notes": "Return to hotel and rest..."
}
```

## Backward Compatibility

### Computed Properties di TripResponse
Model tetap menyediakan properties lama untuk compatibility:
```dart
// Old way (still works)
final tripName = response.tripName;           // Returns "AI Generated Trip"
final city = response.city;                   // Returns "Various Locations"
final budget = response.totalBudget;          // Returns totalEstimatedCost as int
final itinerary = response.dailyItinerary;    // Mapped dari days

// New way (recommended)
final summary = response.summary;
final cost = response.totalEstimatedCost;
final breakdown = response.costBreakdown;
final days = response.days;
```

### Destination Mapping di dailyItinerary
Activities otomatis di-map ke Destination objects:
- `destinationId` atau `mealId` → `id`
- `name` → `title`
- `notes` → `description`
- `locationNote` → `address`
- `estimatedCost` → `ticketPricePerPerson` dan `estimatedCostForGroup`

## Error Handling & Validation

### Parsing Safety Features
1. **Type-safe parsing:** Support untuk int, double, String numbers
2. **Null handling:** Semua optional fields dengan default values
3. **Try-catch blocks:** Error tidak menyebabkan crash
4. **Fallback values:** Return minimal valid object on error

### Validation Rules
```dart
✅ Required Fields:
- summary (default: empty string)
- totalEstimatedCost (default: 0)
- days array (default: empty array)
- activities.activityType (default: "visit")
- activities.startTime (default: "09:00")
- activities.endTime (default: "17:00")
- activities.notes (default: empty string)

📝 Optional Fields (can be null):
- tripPlanId
- userId
- costBreakdown.*
- activities.destinationId
- activities.mealId
- activities.name
- activities.estimatedCost
- activities.locationNote
- activities.destinationName
```

## Testing Guide

### 1. Test Response dengan Full Data
```dart
// Use TEST_RESPONSE_FORMAT.json
final response = await TripService.createTrip(request);
expect(response.summary, isNotEmpty);
expect(response.totalEstimatedCost, greaterThan(0));
expect(response.costBreakdown, isNotNull);
expect(response.days.length, equals(3));
```

### 2. Test Activity Types
```dart
final day = response.days[0];
final activities = day.activities;

// Check for visit activity
final visit = activities.firstWhere((a) => a.activityType == 'visit');
expect(visit.destinationId, isNotNull);
expect(visit.name, isNotEmpty);

// Check for meal activity
final meal = activities.firstWhere((a) => a.activityType == 'meal');
expect(meal.mealId, isNotNull);

// Check for travel activity
final travel = activities.firstWhere((a) => a.activityType == 'travel');
expect(travel.estimatedCost, greaterThanOrEqualTo(0));
```

### 3. Test Cost Breakdown
```dart
final breakdown = response.costBreakdown!;
final total = (breakdown.destinations ?? 0) + 
              (breakdown.meals ?? 0) + 
              (breakdown.travel ?? 0);
expect(total, equals(response.totalEstimatedCost));
```

### 4. Test Backward Compatibility
```dart
final itinerary = response.dailyItinerary;
expect(itinerary.length, equals(response.days.length));

final destinations = itinerary[0].destinations;
expect(destinations, isNotEmpty);
```

## UI Display Recommendations

### Timeline Page Updates
```dart
// Group activities by type
final visits = day.activities.where((a) => a.activityType == 'visit');
final meals = day.activities.where((a) => a.activityType == 'meal');
final travels = day.activities.where((a) => a.activityType == 'travel');

// Display with different icons/colors
for (var activity in day.activities) {
  Widget icon;
  Color color;
  
  switch (activity.activityType) {
    case 'visit':
      icon = Icon(Icons.place, color: Colors.blue);
      break;
    case 'meal':
      icon = Icon(Icons.restaurant, color: Colors.orange);
      break;
    case 'travel':
      icon = Icon(Icons.directions_car, color: Colors.green);
      break;
  }
  
  // Display activity with appropriate icon
}
```

### Cost Display
```dart
// Show cost breakdown
if (response.costBreakdown != null) {
  final breakdown = response.costBreakdown!;
  
  // Destinations cost
  if (breakdown.destinations != null) {
    Text('Destinations: Rp ${formatCurrency(breakdown.destinations)}');
  }
  
  // Meals cost
  if (breakdown.meals != null) {
    Text('Meals: Rp ${formatCurrency(breakdown.meals)}');
  }
  
  // Travel cost
  if (breakdown.travel != null) {
    Text('Travel: Rp ${formatCurrency(breakdown.travel)}');
  }
  
  // Total
  Text('Total: Rp ${formatCurrency(response.totalEstimatedCost)}',
       style: TextStyle(fontWeight: FontWeight.bold));
}
```

## Backend Integration Notes

### For AI Agent/LLM Response
Pastikan AI agent mengembalikan response dalam format JSON yang valid dengan struktur:

```json
{
  "summary": "Generated trip summary",
  "totalEstimatedCost": 1500000,
  "costBreakdown": {
    "destinations": 900000,
    "meals": 450000,
    "travel": 150000
  },
  "days": [
    {
      "dayNumber": 1,
      "activities": [
        {
          "activityType": "visit",
          "destinationId": "exact_firestore_id",
          "name": "Destination Name",
          "startTime": "09:00",
          "endTime": "12:00",
          "estimatedCost": 100000,
          "locationNote": "Full address",
          "notes": "Detailed description"
        }
      ]
    }
  ]
}
```

### Validation di Backend
1. `totalEstimatedCost` = sum of `costBreakdown.*`
2. `costBreakdown.destinations` = sum of all visit activities' estimatedCost
3. `costBreakdown.meals` = sum of all meal activities' estimatedCost
4. `costBreakdown.travel` = sum of all travel activities' estimatedCost
5. `destinationId` harus exact match dengan Firestore document ID
6. `activityType` harus salah satu dari: "visit", "meal", "travel"

## Migration Checklist

- [x] Update `TripResponse` class dengan `costBreakdown`
- [x] Create `CostBreakdown` class
- [x] Update `ActivitySchedule` class dengan fields baru
- [x] Update `TEST_RESPONSE_FORMAT.json` dengan format V2
- [x] Maintain backward compatibility dengan computed getters
- [x] Add comprehensive error handling
- [ ] Test dengan real API response
- [ ] Update UI untuk display activity types
- [ ] Update UI untuk display cost breakdown
- [ ] Add unit tests
- [ ] Update API documentation

## Breaking Changes

**TIDAK ADA BREAKING CHANGES** - Semua perubahan backward compatible.

## Known Issues & Solutions

### Issue 1: Activity tanpa name
**Solution:** Gunakan destinationName sebagai fallback, atau "Activity" sebagai default

### Issue 2: Cost tidak match dengan breakdown
**Solution:** Gunakan totalEstimatedCost sebagai source of truth

### Issue 3: Missing activityType
**Solution:** Default ke "visit" untuk backward compatibility

## Future Enhancements

1. **Real-time Cost Calculation:** Update cost saat user ubah activities
2. **Activity Reordering:** Drag & drop untuk ubah urutan activities
3. **Custom Activity Types:** Support untuk activity types tambahan
4. **Budget Alerts:** Warning jika melebihi budget
5. **Map Integration:** Show route untuk travel activities

## Support & Contact

Untuk pertanyaan atau issue terkait implementasi, silakan:
1. Check logs di console untuk error details
2. Verify response format sesuai dengan specification
3. Test dengan TEST_RESPONSE_FORMAT.json
4. Contact backend team untuk API issues

---

**Last Updated:** 31 Januari 2026
**Version:** 2.0
**Status:** ✅ Ready for Testing
