# 🧪 Testing Guide - AI Trip Planner (Android & Web)

## Quick Test Commands

### Test di Android
```bash
flutter run -d android
```

### Test di Chrome (Web)
```bash
flutter run -d chrome
```

### Test dengan Hot Reload
Setelah aplikasi running, tekan `r` untuk hot reload atau `R` untuk hot restart.

---

## 📱 Testing Flow - Android

### 1. Launch App
```bash
flutter run -d android
```

### 2. Navigate to AI Trip Planner
Home → "Trip AI Planner" button

### 3. Select Trip Type
Pilih salah satu:
- ✅ Province
- ✅ **Greater City** (recommended untuk test cepat)
- ✅ City

### 4. Fill Form (Greater City Example)
- **City**: Jakarta
- **Start Date**: Pilih tanggal hari ini atau besok
- **End Date**: Pilih +1 atau +2 hari dari start
- **Start Time**: Morning
- **End Time**: Evening
- **Budget**: 500000
- **People**: 2
- **Categories**: Centang minimal 1 (contoh: Nature, Culinary)

### 5. Submit
Klik "Next Process" → Loading → Timeline Page

### ✅ Expected Result (Android)
```
✓ Loading indicator muncul
✓ API call berhasil
✓ Navigate ke Timeline page dengan data dari API
✓ Trip summary ditampilkan
✓ List destinasi sesuai kategori yang dipilih
✓ Estimasi biaya ditampilkan
```

---

## 🌐 Testing Flow - Web (Chrome)

### 1. Launch App
```bash
flutter run -d chrome
```

### 2. Navigate to AI Trip Planner
Home → "Trip AI Planner" button

### 3. Fill Form
(Sama seperti Android testing di atas)

### 4. Submit
Klik "Next Process" → Loading → **Error Dialog Muncul**

### ⚠️ Expected Result (Web - dengan CORS issue)
```
✓ Loading indicator muncul
✓ Error dialog muncul dengan pesan:
  
  🌐 Platform Limitation
  
  Web Browser Limitation
  The AI Trip Planner feature works perfectly
  on Android and iOS apps, but has limitations
  on web browsers due to security policies (CORS).
  
  Solutions:
  1. Use the Android or iOS mobile app
  2. View a sample trip plan below
  3. For developers: See WEB_CORS_SOLUTION.md

✓ Tombol "View Sample Trip" tersedia
✓ Klik "View Sample Trip" → Navigate ke Timeline dengan dummy data
```

### 🎯 Web Testing (jika CORS sudah fixed)
Jika server sudah support CORS:
```
✓ Loading indicator muncul
✓ API call berhasil
✓ Navigate ke Timeline page dengan data dari API
✓ Sama seperti Android
```

---

## 🔍 Debugging

### Check Console Logs

**Android**:
```
flutter logs -d android
```

**Web (Chrome DevTools)**:
1. Buka DevTools (F12)
2. Tab "Console"
3. Look for errors

### Common Logs

**Success (Android)**:
```
I/flutter: Sending request to API...
I/flutter: City: Jakarta
I/flutter: Budget: 500000.0
I/flutter: Duration: 2 days
I/flutter: Response received: trip_plan_id_xxxxx
```

**CORS Error (Web)**:
```
Console Error:
Access to XMLHttpRequest at 'http://automation.brohaz.dev/webhook/NewTrip'
from origin 'http://localhost:xxxxx' has been blocked by CORS policy
```

**App Log (Web)**:
```
flutter: Error creating trip: Exception: Unable to connect to the server...
```

---

## 🧩 Test Scenarios

### Scenario 1: Happy Path (Android) ✅
```
Input:
- City: Bogor
- Dates: Today → Tomorrow
- Budget: 1000000
- People: 4
- Categories: Family, Nature

Expected:
✓ API call success
✓ Timeline shows 2 days
✓ Activities match selected categories
✓ Total cost ≈ budget
```

### Scenario 2: Web Browser (CORS) ⚠️
```
Input: (Same as Scenario 1)

Expected:
✓ Error dialog appears
✓ Message explains web limitation
✓ "View Sample Trip" works
✓ Sample data loads
```

### Scenario 3: Network Error (Both Platforms) ❌
```
Simulate: Turn off internet

Expected:
✓ Timeout after 60 seconds
✓ Error dialog appears
✓ Message: "Request timeout. Please check connection"
✓ "View Sample Trip" available
```

### Scenario 4: Server Error (Both Platforms) ❌
```
Simulate: Server returns 500

Expected:
✓ Error dialog appears
✓ Message includes status code
✓ "View Sample Trip" available
```

---

## 📊 Checklist

### Before Testing
- [ ] Flutter installed and updated
- [ ] Android device/emulator ready (untuk Android test)
- [ ] Chrome browser ready (untuk Web test)
- [ ] Internet connection active
- [ ] `flutter doctor` shows no issues

### Android Testing
- [ ] App launches successfully
- [ ] Navigation to Trip AI Planner works
- [ ] Form validation works
- [ ] API call succeeds
- [ ] Timeline displays correctly
- [ ] Data matches input
- [ ] No console errors

### Web Testing (with CORS issue)
- [ ] App launches successfully
- [ ] Navigation works
- [ ] Form validation works
- [ ] Error dialog appears on submit
- [ ] Error message is clear and helpful
- [ ] "View Sample Trip" button works
- [ ] Sample timeline loads correctly

### Web Testing (after CORS fix)
- [ ] App launches successfully
- [ ] Navigation works
- [ ] Form validation works
- [ ] API call succeeds
- [ ] Timeline displays correctly
- [ ] Same behavior as Android

---

## 🛠️ Troubleshooting

### Error: "No device found"
```bash
# Check connected devices
flutter devices

# For Android
flutter emulators
flutter emulators --launch <emulator_id>

# For web
flutter run -d web-server
```

### Error: "Build failed"
```bash
# Clean build
flutter clean
flutter pub get
flutter run
```

### Error: "Package not found"
```bash
# Get dependencies
flutter pub get

# Check pubspec.yaml includes:
# - http: ^1.2.2
# - go_router: ^14.2.7
```

### Web CORS tidak muncul error (malah success)
Kemungkinan:
- Server sudah support CORS ✅
- Menggunakan Chrome extension yang disable CORS
- Server sudah fixed

---

## 📸 Screenshots Reference

### Android Success
```
┌──────────────────────────────┐
│     Loka                     │
│  < Timeline Trip        ☰    │
├──────────────────────────────┤
│                              │
│  📍 Jakarta                  │
│  2-Day Trip                  │
│  💰 Rp 500,000              │
│                              │
│  Day 1 | Day 2               │
│  ───────────────             │
│                              │
│  🌄 Morning (08:00)          │
│  📍 Taman Mini Indonesia     │
│  ⏱️ 08:00 - 12:00           │
│                              │
│  🌞 Noon (12:00)             │
│  📍 Lunch at Local Rest...   │
│  ⏱️ 12:00 - 14:00           │
│                              │
└──────────────────────────────┘
```

### Web CORS Error Dialog
```
┌──────────────────────────────┐
│ 🌐 Platform Limitation       │
├──────────────────────────────┤
│                              │
│ Web Browser Limitation       │
│                              │
│ The AI Trip Planner feature  │
│ works perfectly on Android   │
│ and iOS apps, but has        │
│ limitations on web browsers  │
│ due to security policies.    │
│                              │
│ Solutions:                   │
│ 1. Use mobile app            │
│ 2. View sample below         │
│ 3. See documentation         │
│                              │
│    [OK]  [View Sample Trip]  │
└──────────────────────────────┘
```

---

## 🎯 Success Criteria

### Android ✅
- [x] API call berhasil 100%
- [x] Data ditampilkan dengan benar
- [x] No crashes
- [x] Smooth navigation
- [x] Error handling works

### Web ⚠️
- [x] Graceful error handling
- [x] Clear communication to user
- [x] Fallback to sample data works
- [x] No crashes
- [x] User understands limitation

---

## 📞 Support

Jika menemukan issue:
1. Check console logs
2. Lihat `WEB_CORS_SOLUTION.md` untuk CORS issues
3. Lihat `AI_TRIP_PLANNER_WEB_UPDATE.md` untuk context
4. Test di platform lain (Android vs Web)

---

**Last Updated**: November 14, 2025
**Platforms Tested**: 
- ✅ Android (Working)
- ⚠️ Web (Limited by CORS, graceful degradation implemented)
