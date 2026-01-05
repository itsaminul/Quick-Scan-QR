import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../core/history_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  String? scannedResult;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // URL নিরাপদে খোলার ফাংশন
  Future<void> openLink(String url) async {
    if (url.isEmpty) return;

    try {
      final Uri uri = Uri.parse(Uri.encodeFull(url));

      if (kIsWeb) {
        // Web-এ খোলার জন্য
        if (!await launchUrl(uri)) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("This link could not be opened: $url")),
          );
        }
      } else {
        // Android / iOS-এ খোলার জন্য
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("This link could not be opened: $url")),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Wrong URL: $url")),
      );
    }
  }

  // QR/Barcode স্ক্যান হ্যান্ডল করা
  void handleResult(String code) async {
    setState(() {
      scannedResult = code;
    });

    // History-তে সংরক্ষণ
    await HistoryStorage.saveScan(code);

    // URL হলে অটো ওপেন করার ডায়ালগ
    if (code.startsWith("http://") || code.startsWith("https://")) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Will the link open?"),
          content: Text(
            code,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                openLink(code);
              },
              child: const Text("Open"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR / Barcode"),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Column(
        children: [
          // ক্যামেরা ভিউ
          Expanded(
            flex: 5,
            child: MobileScanner(
              controller: controller,
              onDetect: (barcodeCapture) {
                final String? code = barcodeCapture.barcodes.first.rawValue;
                if (code != null && code != scannedResult) {
                  handleResult(code);
                }
              },
            ),
          ),

          // Result প্যানেল
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Scan Result",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: SelectableText(
                        scannedResult ?? "Scan a QR or Barcode",
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.copy),
                      label: const Text("Copy"),
                      onPressed: scannedResult == null
                          ? null
                          : () {
                        Clipboard.setData(
                          ClipboardData(text: scannedResult!),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Copied to clipboard"),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
