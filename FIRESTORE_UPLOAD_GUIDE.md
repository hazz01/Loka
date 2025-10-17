# Panduan Upload Data ke Firestore

## Prasyarat
1. Pastikan Firebase sudah terkonfigurasi dengan benar
2. Pastikan file `firebase_options.dart` sudah ada di root project
3. Pastikan akun Firebase memiliki akses Firestore

## Cara 1: Upload Manual via Firebase Console

### Langkah-langkah:
1. Buka Firebase Console: https://console.firebase.google.com
2. Pilih project Loka
3. Pergi ke **Firestore Database**
4. Klik **Start collection**
5. Nama collection: `destination`
6. Tambahkan dokumen dengan struktur berikut:

#### Document ID (Custom):
```
dest024
```

#### Field dan Value:
```
activitiesDescription: "Foto-foto, camping, menikmati pemandangan pantai."
address: "Sitiarjo, Malang"
availability: "available"
description: "Pantai dengan ombak besar dan batu karang unik."
openingHours: "06:00 - 18:00"
tags: ["adventure", "beach", "nature"]  // tipe: array
ticketPrice: 15000  // tipe: number
title: "Pantai Goa Cina"
```

7. Ulangi untuk destinasi lainnya (lihat `SAMPLE_FIRESTORE_DATA.json`)

## Cara 2: Upload Menggunakan Script (Lebih Cepat)

### Langkah-langkah:

1. **Edit file upload script** (opsional):
   ```bash
   lib/shared/data/upload_sample_data.dart
   ```
   Anda bisa menambah atau mengurangi data sesuai kebutuhan.

2. **Jalankan script**:
   ```bash
   flutter run lib/shared/data/upload_sample_data.dart
   ```

3. **Output yang diharapkan**:
   ```
   Starting upload to Firestore...
   Collection: destination
   Total documents: 10
   ---
   ✓ Uploaded: Pantai Goa Cina (ID: dest024)
   ✓ Uploaded: Museum Angkut (ID: dest001)
   ✓ Uploaded: Jatim Park 2 (ID: dest002)
   ...
   ---
   Upload complete!
   Success: 10
   Failed: 0
   ```

## Cara 3: Import JSON via Firestore Extension

### Menggunakan Firebase CLI:

1. **Install Firebase CLI**:
   ```bash
   npm install -g firebase-tools
   ```

2. **Login ke Firebase**:
   ```bash
   firebase login
   ```

3. **Buat file import JSON** (sudah tersedia: `SAMPLE_FIRESTORE_DATA.json`)

4. **Import data** menggunakan tools seperti:
   - [firestore-import-export](https://www.npmjs.com/package/firestore-import-export)
   - Atau gunakan Firebase Admin SDK

## Verifikasi Data

### Setelah upload, verifikasi dengan:

1. **Firebase Console**:
   - Buka Firestore Database
   - Lihat collection `destination`
   - Pastikan semua dokumen terlihat

2. **Melalui Aplikasi**:
   - Jalankan aplikasi Flutter
   - Buka HomePage
   - Data destinasi seharusnya muncul
   - Jika tidak muncul, cek console untuk error

## Troubleshooting

### Problem: "Permission denied"
**Solusi**: 
1. Periksa Firestore Rules
2. Set rules untuk development:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true; // WARNING: Development only!
    }
  }
}
```

### Problem: "Collection not found"
**Solusi**: 
- Pastikan nama collection adalah `destination` (lowercase)
- Periksa path di `destination_repository.dart`

### Problem: Data tidak muncul di aplikasi
**Solusi**:
1. Cek koneksi internet
2. Buka DevTools dan lihat log error
3. Pastikan Firebase sudah terinisialisasi di `main.dart`
4. Restart aplikasi

## Format Data yang Benar

### Field Types:
- `activitiesDescription`: **string**
- `address`: **string**
- `availability`: **string** ("available" atau "unavailable")
- `description`: **string**
- `openingHours`: **string** (format: "HH:mm - HH:mm")
- `tags`: **array** of strings
- `ticketPrice`: **number** (integer)
- `title`: **string**

### Document ID:
- Format: `dest###` (contoh: dest001, dest024)
- Harus unique untuk setiap destinasi

## Tips

### 1. Batch Upload
Jika memiliki banyak data, gunakan batch write untuk efisiensi:
```dart
final batch = firestore.batch();
// Add multiple documents
await batch.commit();
```

### 2. Backup Data
Sebelum melakukan perubahan besar:
```bash
gcloud firestore export gs://[BUCKET_NAME]
```

### 3. Testing Data
Gunakan emulator Firestore untuk testing:
```bash
firebase emulators:start --only firestore
```

## Security Rules untuk Production

Setelah development selesai, update rules:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /destination/{docId} {
      allow read: if true; // Public read
      allow write: if request.auth != null && request.auth.token.admin == true; // Admin only
    }
  }
}
```

## Monitoring

### Firebase Console:
- Monitor reads/writes di tab **Usage**
- Pastikan tidak melebihi quota gratis
- Set up billing alerts

### Quota Gratis Firebase (Spark Plan):
- 50,000 document reads/day
- 20,000 document writes/day
- 20,000 document deletes/day

## Next Steps

Setelah data berhasil di-upload:

1. ✅ Test semua fitur aplikasi
2. ✅ Verifikasi search dan filter
3. ✅ Test pagination
4. ✅ Monitor performance
5. ⚠️ Setup security rules yang proper
6. ⚠️ Implementasi caching untuk mengurangi reads
7. ⚠️ Consider indexing untuk query yang complex

## Support

Jika mengalami masalah:
1. Cek log error di aplikasi
2. Cek Firestore rules
3. Lihat Firebase Console > Firestore > Data
4. Review dokumentasi: https://firebase.google.com/docs/firestore
