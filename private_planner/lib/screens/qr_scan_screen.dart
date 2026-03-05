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
    return Scaffold(
      appBar: AppBar(
          title: Text(isHousehold
              ? 'Haushalt QR-Code scannen'
              : 'Server QR-Code scannen')),
      body: MobileScanner(
        onDetect: (capture) async {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final String? code = barcode.rawValue;
            if (code != null) {
              try {
                if (isHousehold) {
                  // If it's a household QR, we expect something like {"household_token": "..."}
                  final String householdToken;
                  if (code.startsWith('{')) {
                    final data = jsonDecode(code);
                    householdToken = data['household_token'] ?? code;
                  } else {
                    householdToken = code;
                  }
                  await ref
                      .read(userServiceProvider)
                      .joinHousehold(householdToken);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Erfolgreich dem Haushalt beigetreten')),
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
                    SnackBar(content: Text('QR-Scan fehlgeschlagen: $e')),
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
