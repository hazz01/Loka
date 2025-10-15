# Quick Start Guide - Trip Planner API Integration

## 🚀 Cara Menjalankan

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run Aplikasi
```bash
flutter run
```

## 📱 Cara Testing

### Testing dengan API (Real Data)

1. **Buka Aplikasi**
   - Launch aplikasi di emulator atau device

2. **Navigate ke Trip AI Planner**
   - Dari home page, klik menu Trip AI Planner
   - Pilih **"Greater City"**

3. **Isi Form**
   - **City**: Pilih salah satu (Jakarta/Bogor/Depok/Tangerang/Bekasi)
   - **Travel Dates**: 
     - Start: Pilih tanggal mulai
     - End: Pilih tanggal selesai
   - **Time of Day**:
     - Start Time: Morning/Noon/Evening/Night
     - End Time: Morning/Noon/Evening/Night
   - **Budget**: Masukkan angka (contoh: 500000)
   - **People**: Jumlah orang (contoh: 3)
   - **Categories**: Pilih minimal 1 kategori

4. **Submit**
   - Klik tombol **"Next Process"**
   - Tunggu loading (akan call API)
   - Jika berhasil → akan redirect ke Timeline Page dengan data dari API
   - Jika gagal → akan tampil error dialog dengan opsi "View Sample"

### Testing dengan Dummy Data (Fallback)

Jika API tidak tersedia atau error:
1. Klik "View Sample" pada error dialog, ATAU
2. Navigate langsung ke `/trip-ai-planner/timeline` tanpa parameter

## 🔧 Troubleshooting

### Error: Failed to create trip
**Kemungkinan penyebab:**
- Tidak ada koneksi internet
- API endpoint sedang down
- Format data tidak sesuai

**Solusi:**
1. Check internet connection
2. Lihat console log untuk detail error
3. Gunakan "View Sample" untuk melihat dummy data

### Error: Unused import
**Solusi:**
```bash
flutter analyze
# Hapus import yang tidak digunakan sesuai petunjuk
```

### Build Error
**Solusi:**
```bash
flutter clean
flutter pub get
flutter run
```

## 📝 Test Scenarios

### Scenario 1: Weekend Trip (1-2 Days)
```
City: Bogor
Start: 2025-10-25 (Morning)
End: 2025-10-26 (Evening)
Budget: IDR 1,000,000
People: 2
Categories: Nature, Family
```

### Scenario 2: Short City Break (3 Days)
```
City: Jakarta
Start: 2025-11-01 (Morning)
End: 2025-11-03 (Evening)
Budget: IDR 2,000,000
People: 2
Categories: Culinary, History, Art & Culture
```

### Scenario 3: Budget Trip (1 Day)
```
City: Batu
Start: 2025-10-20 (Morning)
End: 2025-10-20 (Evening)
Budget: IDR 500,000
People: 3
Categories: Family, Nature
```

## 🧪 Testing API Directly

### Using curl:
```bash
curl -X POST http://automation.brohaz.dev/webhook/NewTrip \
  -H "Content-Type: application/json" \
  -d '[{
    "userId": "user123",
    "tripType": {"type": "greater_city", "name": "Batu"},
    "targetCities": ["Batu"],
    "budget": 500000,
    "peopleCount": 3,
    "tripDuration": 1,
    "tripStart": {"date": "2025-10-20", "daypart": "morning"},
    "tripEnd": {"date": "2025-10-21", "daypart": "evening"},
    "categories": ["family", "nature"],
    "preferences": {
      "transportMode": "car",
      "restPreference": "moderate",
      "mealPreference": "local food",
      "pace": "balanced"
    }
  }]'
```

### Using Postman/Thunder Client:
1. Method: **POST**
2. URL: `http://automation.brohaz.dev/webhook/NewTrip`
3. Headers: 
   - Content-Type: `application/json`
4. Body: Copy dari `TEST_DATA.json`

## 📊 Expected Results

### On Success:
- Loading spinner tampil
- API dipanggil
- Navigate ke timeline page
- Tampil data trip dari API:
  - City name
  - Trip summary
  - Estimated budget
  - Daily activities dengan time range
  - Destination details

### On Error:
- Error dialog tampil
- 2 options:
  - "OK" - close dialog
  - "View Sample" - lihat dummy data

## 🔍 Debug Mode

Untuk melihat log API:
1. Buka console/terminal tempat flutter run
2. Look for print statements:
   ```
   Sending request to API...
   City: Jakarta
   Budget: 2000000.0
   Duration: 3 days
   Response received: _20251015_083353
   ```

## 📋 Checklist Testing

- [ ] Form validation works (button disabled when incomplete)
- [ ] Loading state shows when submitting
- [ ] API call successful dengan internet connection
- [ ] Timeline displays API data correctly
- [ ] Error handling works when API fails
- [ ] Dummy data fallback works
- [ ] Navigation back button works
- [ ] Multiple days display correctly
- [ ] Date selector works
- [ ] Activity timeline cards render properly

## 🎯 Key Files to Check

- `lib/features/home/pages/kategori_greater_city_page.dart` - Form & API call
- `lib/features/home/pages/timeline_trip_Page.dart` - Display results
- `lib/features/home/services/trip_service.dart` - API service
- `lib/features/home/models/trip_request_model.dart` - Request model
- `lib/features/home/models/trip_response_model.dart` - Response model
- `lib/routing/app_router.dart` - Navigation with data passing

## 💡 Tips

1. **Always check console** untuk error messages
2. **Test internet connection** before blaming code
3. **Use View Sample** untuk quick visual check
4. **Try different cities** untuk variety
5. **Test with different budgets** untuk see different recommendations

## 📞 Support

Jika ada issue atau pertanyaan, check:
1. Console logs
2. API endpoint status
3. Network connection
4. IMPLEMENTATION_NOTES.md untuk detail teknis
