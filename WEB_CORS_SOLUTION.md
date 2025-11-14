# Solusi CORS untuk Web Platform

## Masalah
Ketika menjalankan aplikasi di web browser (Chrome, Firefox, dll), terjadi error:
```
failed to fetch, url=http://automation.brohaz.dev/webhook/NewTrip
```

Error ini disebabkan oleh **CORS (Cross-Origin Resource Sharing) policy** di browser. Browser modern memblokir HTTP request ke domain lain kecuali server tersebut mengizinkan dengan header CORS yang tepat.

## Solusi

### Opsi 1: Konfigurasi Server (RECOMMENDED) ✅
Server `automation.brohaz.dev` perlu menambahkan CORS headers:

```
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: POST, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type
```

**Cara implementasi di server:**
- Jika menggunakan Express.js:
  ```javascript
  app.use(cors());
  ```
- Jika menggunakan Node.js webhook:
  ```javascript
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  ```

### Opsi 2: Proxy Server (WORKAROUND)
Buat proxy server sederhana yang meneruskan request:

1. Install package `cors-anywhere` atau gunakan cloud function
2. Deploy proxy yang mengizinkan CORS
3. Update `TripService` untuk menggunakan proxy URL di web

Contoh proxy dengan Vercel:
```javascript
// api/proxy.js
module.exports = async (req, res) => {
  const response = await fetch('http://automation.brohaz.dev/webhook/NewTrip', {
    method: 'POST',
    headers: req.headers,
    body: req.body
  });
  
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.json(await response.json());
};
```

### Opsi 3: Chrome Extension untuk Development
Untuk testing di development:
1. Install extension "CORS Unblock" atau "Allow CORS"
2. Enable extension saat testing
3. **PENTING**: Ini hanya untuk development, tidak work untuk production

### Opsi 4: Disable Web Security (DEVELOPMENT ONLY) ⚠️
**HANYA UNTUK TESTING, TIDAK AMAN!**

Windows:
```bash
chrome.exe --user-data-dir="C:/Chrome dev session" --disable-web-security
```

Mac:
```bash
open -n -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --user-data-dir="/tmp/chrome_dev_test" --disable-web-security
```

## Implementasi di Aplikasi

File `trip_service.dart` sudah diupdate untuk:
1. ✅ Deteksi platform (web vs mobile)
2. ✅ Mencoba HTTPS dulu, fallback ke HTTP
3. ✅ Error handling yang lebih baik
4. ✅ Timeout handling (60 detik)

## Status
- **Android/iOS**: ✅ Berfungsi normal
- **Web**: ⚠️ Tergantung konfigurasi CORS di server

## Rekomendasi
1. **Jangka Pendek**: Gunakan Chrome extension untuk development/testing
2. **Jangka Panjang**: Minta admin server untuk enable CORS headers
3. **Alternative**: Deploy proxy server sendiri

## Testing
1. Android: Sudah berfungsi ✅
2. Web dengan CORS disabled: Berfungsi ⚠️
3. Web normal: Perlu CORS dari server 🔧
