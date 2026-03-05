import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/services/auth_service.dart';

class QrScanScreen extends ConsumerWidget {
  const QrScanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Server QR-Code scannen')),
      body: MobileScanner(
        onDetect: (capture) async {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final String? code = barcode.rawValue;
            if (code != null) {
              try {
                await ref.read(authServiceProvider).loginWithQr(code);
                if (context.mounted) {
                  Navigator.of(context).pushReplacementNamed('/home');
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('QR-Login fehlgeschlagen: $e')),
                  );
                }
              }
              break;
            }
          }
        },
      ),
    );
  }
}
