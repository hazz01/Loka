# Partner Destinations Update

## Ringkasan Perubahan

### 1. **Penambahan 3 Destinasi Baru dengan Virtual Tour**

Ditambahkan 3 destinasi baru yang sudah bermitra dengan Loka, lengkap dengan virtual tour:

#### A. Kampung Jodipan (Rainbow Village)
- **ID:** `dest_21`
- **Lokasi:** Malang, Jawa Timur
- **Rating:** 4.7
- **Virtual Tour URL:** `https://vragio-vtour.benspace.xyz/vragio%20web%20jodipan/`
- **Kategori:** Heritage
- **Harga Tiket:**
  - Weekday: IDR 10,000
  - Weekend: IDR 15,000
- **Fitur:**
  - Rainbow village dengan 232+ rumah warna-warni
  - Street art dan mural kreatif
  - Rainbow bridge dan stairs
  - Instagram-worthy spots
  - Community workshops
- **Tour Options:**
  - Rainbow Walking Tour (IDR 30,000)
  - Photography Package (IDR 50,000)

#### B. Kampung Umbulan Tanaka
- **ID:** `dest_22`
- **Lokasi:** Batu, Jawa Timur
- **Rating:** 4.6
- **Virtual Tour URL:** `https://vragio-vtour.benspace.xyz/vragio%20web%20tanaka/`
- **Kategori:** Heritage
- **Harga Tiket:**
  - Weekday: IDR 15,000
  - Weekend: IDR 20,000
- **Fitur:**
  - Traditional Javanese village experience
  - Natural spring (umbulan)
  - Rice fields dan bamboo groves
  - Traditional wooden houses
  - Farming activities
  - Local craft workshops
- **Tour Options:**
  - Village Cultural Tour (IDR 40,000)
  - Farming Experience (IDR 60,000)

#### C. Desa Wisata Bulukerto
- **ID:** `dest_23`
- **Lokasi:** Batu, Jawa Timur
- **Rating:** 4.8
- **Virtual Tour URL:** `https://bulukerto-virtual-tour.web.app`
- **Kategori:** Heritage
- **Harga Tiket:**
  - Weekday: IDR 20,000
  - Weekend: IDR 25,000
- **Fitur:**
  - Agro-tourism village di kaki Gunung Bromo
  - Organic farming
  - Coffee and tea plantations
  - Mountain views
  - Rural homestay experience
  - Sustainable tourism practices
- **Tour Options:**
  - Agro Tourism Package (IDR 75,000)
  - Full Day Experience (IDR 120,000)

---

### 2. **Revamp Section "Featured Destinations" (Previously "Recommended")**

#### Perubahan UI yang Dilakukan:

**A. Header Section yang Lebih Menarik**
- Menambahkan **"VERIFIED PARTNER" badge** dengan gradient biru
- Badge menggunakan icon `badgeCheck` dari Lucide Icons
- Menambahkan **subtitle**: "Explore our exclusive partner destinations"
- Layout yang lebih informatif dan professional

**B. Fixed Destinations List**
Section ini sekarang menampilkan 4 destinasi fixed yang sudah bermitra dengan Loka:

1. **Desa Wisata Bulukerto** (dest_23)
2. **Jatim Park 1** (dest_1)
3. **Kampung Jodipan** (dest_21)
4. **Kampung Umbulan Tanaka** (dest_22)

**C. Partner Badge pada Setiap Card**
- Setiap destination card sekarang memiliki badge **"PARTNER"**
- Badge dengan gradient biru dan icon badgeCheck
- Positioned di kiri atas image untuk visibility maksimal

**D. Independent dari Category Filter**
- Featured destinations tidak lagi berubah ketika user memilih category filter
- Destinasi tetap fix menampilkan 4 partner utama
- Category filter hanya mempengaruhi section "Based on your location"

#### Before & After

**Before:**
```
┌─────────────────────────────────┐
│ Recommended          [Explore] │
├─────────────────────────────────┤
│ [Destinations based on category]│
│ (Changes when filter selected)  │
└─────────────────────────────────┘
```

**After:**
```
┌─────────────────────────────────┐
│ [✓ VERIFIED PARTNER]            │
│ Featured Destinations           │
│ Explore our exclusive partner  │
│ destinations                    │
├─────────────────────────────────┤
│ [Fixed 4 partner destinations]  │
│ Each with PARTNER badge         │
│ (Independent from filters)      │
└─────────────────────────────────┘
```

---

### 3. **Technical Changes**

#### File: `lib/shared/data/mock_data_source.dart`

**Penambahan:**
- 3 destinasi baru (dest_21, dest_22, dest_23)
- Setiap destinasi lengkap dengan:
  - Detailed descriptions
  - Virtual tour URLs
  - Ticket prices
  - Tour options
  - Activities list
  - Coordinates (latitude/longitude)

#### File: `lib/features/home/pages/home_page.dart`

**Perubahan pada `_loadDestinations()`:**
```dart
void _loadDestinations() {
  setState(() {
    // Fixed recommended destinations - destinations partnered with Loka
    recommendedDestinations = [
      MockDataSource.destinations.firstWhere((d) => d.id == 'dest_23'), // Desa Wisata Bulukerto
      MockDataSource.destinations.firstWhere((d) => d.id == 'dest_1'),  // Jatim Park 1
      MockDataSource.destinations.firstWhere((d) => d.id == 'dest_21'), // Kampung Jodipan
      MockDataSource.destinations.firstWhere((d) => d.id == 'dest_22'), // Kampung Tanaka
    ];
    nearestDestinations = MockDataSource.getNearestDestinations(limit: 10);
  });
}
```

**Perubahan pada UI:**
1. Updated section header dengan badge dan subtitle
2. Removed category-based filtering untuk recommended destinations
3. Added partner badge pada setiap destination card
4. Increased card height untuk accommodate badge (270-300px)

**Perubahan pada Category Chips:**
- Removed logic yang mengubah `recommendedDestinations`
- Category chips sekarang hanya untuk visual reference
- Filter category hanya mempengaruhi "Based on your location" section (future implementation)

---

## Cara Menambah Partner Destination Baru

Jika ingin menambahkan partner destination baru:

1. **Tambahkan data destinasi** di `mock_data_source.dart`:
```dart
const Destination(
  id: 'dest_xx',
  name: 'Nama Destinasi',
  hasVirtualTour: true,
  virtualTourUrl: 'https://...',
  category: 'Heritage',
  // ... field lainnya
),
```

2. **Update array di `_loadDestinations()`**:
```dart
recommendedDestinations = [
  MockDataSource.destinations.firstWhere((d) => d.id == 'dest_23'),
  MockDataSource.destinations.firstWhere((d) => d.id == 'dest_1'),
  MockDataSource.destinations.firstWhere((d) => d.id == 'dest_21'),
  MockDataSource.destinations.firstWhere((d) => d.id == 'dest_22'),
  MockDataSource.destinations.firstWhere((d) => d.id == 'dest_xx'), // New partner
];
```

---

## Testing Checklist

- [ ] Homepage menampilkan "VERIFIED PARTNER" badge di header section
- [ ] Featured Destinations menampilkan 4 destinasi fix
- [ ] Setiap card memiliki badge "PARTNER" di kiri atas
- [ ] Featured destinations tidak berubah saat memilih category filter
- [ ] Virtual tour untuk setiap destinasi berfungsi dengan benar:
  - [ ] Desa Wisata Bulukerto → `bulukerto-virtual-tour.web.app`
  - [ ] Jatim Park 1 → `vragio web jatim park`
  - [ ] Kampung Jodipan → `vragio web jodipan`
  - [ ] Kampung Tanaka → `vragio web tanaka`
- [ ] Detail page untuk setiap destinasi menampilkan informasi lengkap
- [ ] Ticket prices dan tour options ditampilkan dengan benar

---

## Design Specifications

### Partner Badge Colors
- **Primary Gradient:** `#539DF3` → `#3B7DD8`
- **Text Color:** White (`#FFFFFF`)
- **Font Weight:** 700 (Bold)
- **Letter Spacing:** 0.3-0.5px

### Section Header
- **Badge Font Size:** 9-10px (responsive)
- **Title Font Size:** 14-16px (responsive)
- **Subtitle Font Size:** 11-12px (responsive)
- **Subtitle Color:** `Colors.grey[600]`

### Card Badge
- **Font Size:** 8-9px (responsive)
- **Icon Size:** 10-11px (responsive)
- **Padding:** 4-5px vertical, 6-8px horizontal
- **Border Radius:** 6px

---

## Notes

- Virtual tour URLs sudah ditest dan working
- Semua destinasi memiliki koordinat GPS untuk map integration
- Rating destinasi berdasarkan review rata-rata
- Harga tiket dapat diupdate sesuai kebutuhan
- Tour options dapat ditambah/dikurangi sesuai kebutuhan

---

## Future Enhancements

Potensi improvement untuk section ini:
1. Add animation/transition effects untuk card
2. Add "View All Partners" button
3. Implement partner rotation/highlight of the month
4. Add partner badges di detail page juga
5. Create dedicated partner page
6. Add partner benefits/perks information
7. Implement booking integration untuk partner destinations
