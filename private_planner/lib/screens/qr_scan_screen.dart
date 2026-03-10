import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/services/auth_service.dart';
import 'dart:convert';
import 'package:private_planner/services/user_service.dart';

class QrScanScreen extends ConsumerWidget {
  final bool isHousehold;
  const QrScanScreen({super.key, this.isHousehold = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
          title: Text(isHousehold
              ? 'Haushalt QR-Code scannen'
              : 'Server QR-Code scannen')),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: MobileScanner(
              onDetect: (capture) async {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  final String? code = barcode.rawValue;
                  if (code != null) {
                    _processCode(context, ref, code);
                    break;
                  }
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text('Oder Pairing-Code manuell eingeben:'),
                const SizedBox(height: 8),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Pairing-Code',
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () =>
                      _processCode(context, ref, controller.text.trim()),
                  child: const Text('Manuell verbinden'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processCode(
      BuildContext context, WidgetRef ref, String code) async {
    if (code.isEmpty) return;
    try {
      if (isHousehold) {
        String householdToken;
        if (code.startsWith('{')) {
          final data = jsonDecode(code);
          householdToken = data['household_token'] ?? code;
        } else {
          try {
            // Check if it's base64 encoded
            final decoded = utf8.decode(base64Decode(code));
            final data = jsonDecode(decoded);
            householdToken = data['household_token'] ?? code;
          } catch (_) {
            householdToken = code;
          }
        }
        await ref.read(userServiceProvider).joinHousehold(householdToken);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Erfolgreich dem Haushalt beigetreten')),
          );
          Navigator.of(context).pop();
        }
      } else {
        await ref.read(authServiceProvider).loginWithQr(code);
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verbindung fehlgeschlagen: $e')),
        );
      }
    }
  }
}
