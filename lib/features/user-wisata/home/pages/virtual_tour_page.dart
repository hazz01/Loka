import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/link.dart';
import 'package:webview_flutter/webview_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_android/webview_flutter_android.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../services/destination_detail_service.dart';

class VirtualTourPage extends StatefulWidget {
  final String destinationId;

  const VirtualTourPage({super.key, required this.destinationId});

  @override
  State<VirtualTourPage> createState() => _VirtualTourPageState();
}

class _VirtualTourPageState extends State<VirtualTourPage> {
  WebViewController? _controller; // Ubah ke nullable
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  String _virtualTourUrl = '';

  @override
  void initState() {
    super.initState();
    // Set landscape orientation saat halaman dibuka
    _setLandscapeMode();
    _loadDestinationAndInitialize();
  }

  Future<void> _loadDestinationAndInitialize() async {
    try {
      final destination = await DestinationDetailService.getDestinationDetail(
        widget.destinationId,
      );

      if (mounted) {
        final url =
            destination?.virtualTourUrl ??
            'https://vragio-vtour.benspace.xyz/vragio%20web%20kajoetangan/'; // Fallback URL

        // Validasi URL
        if (url.isEmpty) {
          throw Exception('URL virtual tour tidak tersedia');
        }

        // Validasi format URL
        try {
          final uri = Uri.parse(url);
          if (!uri.hasScheme || (!uri.scheme.startsWith('http'))) {
            throw Exception('Format URL tidak valid');
          }
        } catch (e) {
          throw Exception('Format URL tidak valid: ${e.toString()}');
        }

        setState(() {
          _virtualTourUrl = url;
        });

        _initializeWebView();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Gagal memuat virtual tour: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Kembalikan orientasi ke normal saat keluar dari halaman
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  // Set halaman ke landscape mode
  Future<void> _setLandscapeMode() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // Optional: Hide system UI untuk lebih immersive
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _initializeWebView() {
    // Pastikan URL sudah diset
    if (_virtualTourUrl.isEmpty) {
      setState(() {
        _hasError = true;
        _errorMessage = 'URL virtual tour tidak tersedia';
        _isLoading = false;
      });
      return;
    }

    // Inisialisasi platform-specific implementation
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      params = AndroidWebViewControllerCreationParams();
    } else if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final controller = WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }

            // Inject CSS untuk menyembunyikan elemen yang tidak diperlukan (opsional)
            controller.runJavaScript('''
              (function() {
                // Pastikan halaman sudah siap
                if (document.readyState === 'complete') {
                  console.log('Page loaded successfully');
                }
              })();
            ''');
          },
          onWebResourceError: (WebResourceError error) {
            if (mounted) {
              setState(() {
                _isLoading = false;
                _hasError = true;
                _errorMessage = 'Gagal memuat resource: ${error.description}';
              });
            }
          },
          onHttpError: (HttpResponseError error) {
            if (mounted) {
              setState(() {
                _isLoading = false;
                _hasError = true;
                _errorMessage =
                    'HTTP Error: ${error.response?.statusCode ?? "Unknown"}';
              });
            }
          },
        ),
      );

    // Konfigurasi tambahan untuk Android
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    // Set controller dan load URL
    setState(() {
      _controller = controller;
    });

    // Load URL setelah controller siap
    controller.loadRequest(Uri.parse(_virtualTourUrl));
  }

  // Fungsi untuk membuka URL di browser eksternal untuk mode VR

  // Fungsi untuk reload halaman
  void _reloadPage() {
    if (_controller == null) {
      // Jika controller belum diinisialisasi, coba load ulang dari awal
      _loadDestinationAndInitialize();
      return;
    }

    setState(() {
      _hasError = false;
      _isLoading = true;
    });
    _controller!.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // WebView
          if (!_hasError && _controller != null)
            WebViewWidget(controller: _controller!)
          else if (!_hasError && _controller == null)
            // Loading state saat controller belum siap
            Container(
              color: Colors.black,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.blue),
                    SizedBox(height: 16),
                    Text(
                      'Mempersiapkan Virtual Tour...',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            )
          else
            // Error state
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Gagal memuat Virtual Tour',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _reloadPage,
                      icon: const Icon(Icons.refresh, size: 20),
                      label: const Text('Coba Lagi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Loading indicator
          if (_isLoading)
            Container(
              color: Colors.black87,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.blue),
                    SizedBox(height: 16),
                    Text(
                      'Memuat Virtual Tour 360°...',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

          // Top bar dengan tombol back dan VR
          if (!_isLoading &&
              !_hasError &&
              _controller != null &&
              _virtualTourUrl.isNotEmpty)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  ),
                ),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tombol Back
                      Material(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: () => context.pop(),
                          borderRadius: BorderRadius.circular(8),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Kembali',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Tombol VR Mode
                      Material(
                        color: Colors.blue.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                        child: Link(
                          target: LinkTarget.self,
                          uri: Uri.parse(_virtualTourUrl),
                          builder: (context, followLink) => InkWell(
                            onTap: followLink,
                            borderRadius: BorderRadius.circular(8),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    LucideIcons.camera,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Mode VR',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
