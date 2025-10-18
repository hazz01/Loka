# Revisi Detail Component Page

## Perubahan yang Dilakukan

### 1. **Perbaikan Kapitalisasi Judul**
**Masalah:** Judul destinasi ditampilkan dalam huruf kecil semua karena menggunakan `.toLowerCase()`

**File:** `lib/features/home/pages/detail_component_page.dart`

**Perubahan:**
```dart
// Sebelum (baris 353)
Text(
  destinationDetail!.name.toLowerCase(),
  ...
)

// Sesudah
Text(
  destinationDetail!.name,
  ...
)
```

**Hasil:** Judul destinasi sekarang ditampilkan dengan kapitalisasi asli sesuai dengan data di mock_data_source.dart (misalnya: "Jatim Park 1" bukan "jatim park 1")

---

### 2. **Virtual Tour URL Dinamis**

**Masalah:** URL virtual tour hardcoded untuk semua destinasi, sehingga semua destinasi menampilkan virtual tour yang sama

**Solusi:** Menambahkan field `virtualTourUrl` ke model `Destination` dan memuat URL secara dinamis berdasarkan destinasi

#### A. Update Model Destination

**File:** `lib/shared/data/models.dart`

**Perubahan:**
- Menambahkan field `virtualTourUrl` ke class `Destination`
```dart
final String? virtualTourUrl; // URL untuk virtual tour
```

- Update constructor untuk menerima parameter `virtualTourUrl`
```dart
const Destination({
  ...
  this.virtualTourUrl,
});
```

#### B. Update Mock Data

**File:** `lib/shared/data/mock_data_source.dart`

**Perubahan:** Menambahkan `virtualTourUrl` untuk setiap destinasi yang memiliki virtual tour

**Destinasi dengan Virtual Tour:**

1. **Jatim Park 1** (`dest_1`)
   - `virtualTourUrl: 'https://vragio-vtour.benspace.xyz/vragio%20web%20jatim%20park/'`

2. **Museum Angkut** (`dest_2`)
   - `virtualTourUrl: 'https://vragio-vtour.benspace.xyz/vragio%20web%20museum%20angkut/'`

3. **Jatim Park 2** (`dest_3`)
   - `virtualTourUrl: 'https://vragio-vtour.benspace.xyz/vragio%20web%20jatim%20park%202/'`

4. **Kampoeng Heritage Kajoetangan** (`dest_7`)
   - `virtualTourUrl: 'https://vragio-vtour.benspace.xyz/vragio%20web%20kajoetangan/'`

#### C. Update Virtual Tour Page

**File:** `lib/features/home/pages/virtual_tour_page.dart`

**Perubahan:**

1. Menambahkan import service dan state untuk URL dinamis
```dart
import '../services/destination_detail_service.dart';
```

2. Menambahkan field untuk menyimpan URL:
```dart
String _virtualTourUrl = '';
```

3. Membuat method `_loadDestinationAndInitialize()` untuk memuat data destinasi dan URL virtual tour:
```dart
Future<void> _loadDestinationAndInitialize() async {
  try {
    final destination = await DestinationDetailService.getDestinationDetail(
      widget.destinationId,
    );
    
    if (mounted) {
      setState(() {
        _virtualTourUrl = destination?.virtualTourUrl ?? 
            'https://vragio-vtour.benspace.xyz/vragio%20web%20kajoetangan/'; // Fallback URL
      });
      
      _initializeWebView();
    }
  } catch (e) {
    if (mounted) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to load virtual tour';
        _isLoading = false;
      });
    }
  }
}
```

4. Update WebView untuk menggunakan URL dinamis:
```dart
..loadRequest(Uri.parse(_virtualTourUrl));
```

5. Update Link widget untuk VR Mode button:
```dart
Link(
  target: LinkTarget.self,
  uri: Uri.parse(_virtualTourUrl),
  ...
)
```

---

## Cara Menambah Virtual Tour untuk Destinasi Baru

Untuk menambahkan virtual tour ke destinasi baru:

1. **Set `hasVirtualTour: true`** di data destinasi
2. **Tambahkan `virtualTourUrl`** dengan URL virtual tour yang sesuai:

```dart
const Destination(
  id: 'dest_xx',
  name: 'Nama Destinasi',
  hasVirtualTour: true,
  virtualTourUrl: 'https://vragio-vtour.benspace.xyz/vragio%20web%20nama-destinasi/',
  // ... field lainnya
),
```

---

## Testing

Untuk menguji perubahan:

1. **Test Kapitalisasi Judul:**
   - Buka detail page untuk destinasi manapun
   - Verifikasi bahwa judul ditampilkan dengan kapitalisasi yang benar

2. **Test Virtual Tour Dinamis:**
   - Buka detail page untuk "Jatim Park 1" → klik "360 View" → harus membuka virtual tour Jatim Park 1
   - Buka detail page untuk "Museum Angkut" → klik "360 View" → harus membuka virtual tour Museum Angkut
   - Buka detail page untuk "Kampoeng Heritage Kajoetangan" → klik "360 View" → harus membuka virtual tour Kajoetangan
   - Verifikasi bahwa setiap destinasi menampilkan virtual tour yang sesuai

---

## Catatan

- Jika destinasi tidak memiliki `virtualTourUrl`, sistem akan menggunakan fallback URL (Kajoetangan)
- Untuk destinasi yang tidak memiliki virtual tour (`hasVirtualTour: false`), tombol "360 View" akan tetap muncul namun menggunakan fallback URL
- Pastikan URL virtual tour valid dan dapat diakses sebelum menambahkannya ke data
