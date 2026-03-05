import 'dart:io';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ota_update/ota_update.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';

part 'update_service.g.dart';

class UpdateInfo {
  final String latestVersion;
  final String downloadUrl;
  final bool isIgnored;

  UpdateInfo({
    required this.latestVersion,
    required this.downloadUrl,
    this.isIgnored = false,
  });

  UpdateInfo copyWith({bool? isIgnored}) {
    return UpdateInfo(
      latestVersion: latestVersion,
      downloadUrl: downloadUrl,
      isIgnored: isIgnored ?? this.isIgnored,
    );
  }
}

@riverpod
class UpdateService extends _$UpdateService {
  final _dio = Dio();
  final _repo = 'SeimSoft/SecurePlanner';

  @override
  FutureOr<UpdateInfo?> build() async {
    // Check for updates on startup
    return await checkForUpdates(silent: true);
  }

  Future<UpdateInfo?> checkForUpdates({bool silent = false}) async {
    try {
      final response =
          await _dio.get('https://api.github.com/repos/$_repo/releases/latest');
      if (response.statusCode == 200) {
        final latestVersion = response.data['tag_name'] as String;
        final packageInfo = await PackageInfo.fromPlatform();
        final currentVersion = 'v${packageInfo.version}';

        if (_isNewer(latestVersion, currentVersion)) {
          final downloadUrl = _getDownloadUrl(response.data);
          if (downloadUrl != null) {
            final info = UpdateInfo(
                latestVersion: latestVersion, downloadUrl: downloadUrl);
            state = AsyncData(info);
            return info;
          }
        }
      }
    } catch (e) {
      if (!silent) {
        rethrow;
      }
    }
    state = const AsyncData(null);
    return null;
  }

  void ignoreUpdate() {
    state.whenData((info) {
      if (info != null) {
        state = AsyncData(info.copyWith(isIgnored: true));
      }
    });
  }

  bool _isNewer(String latest, String current) {
    // Simple version comparison (e.g., v0.1.2 vs v0.1.1)
    // Remove 'v' prefix if present
    final l = latest.replaceAll('v', '');
    final c = current.replaceAll('v', '');

    final lParts = l.split('.').map(int.parse).toList();
    final cParts = c.split('.').map(int.parse).toList();

    for (var i = 0; i < lParts.length && i < cParts.length; i++) {
      if (lParts[i] > cParts[i]) return true;
      if (lParts[i] < cParts[i]) return false;
    }
    return lParts.length > cParts.length;
  }

  String? _getDownloadUrl(Map<String, dynamic> releaseData) {
    final assets = releaseData['assets'] as List;
    if (Platform.isAndroid) {
      final apk = assets.firstWhere((a) => a['name'].endsWith('.apk'),
          orElse: () => null);
      return apk?['browser_download_url'];
    } else if (Platform.isWindows) {
      final win = assets.firstWhere((a) => a['name'].contains('windows.zip'),
          orElse: () => null);
      return win?['browser_download_url'];
    } else if (Platform.isMacOS) {
      final mac = assets.firstWhere((a) => a['name'].contains('macos'),
          orElse: () => null);
      return mac?['browser_download_url'];
    } else if (Platform.isLinux) {
      final linux = assets.firstWhere((a) => a['name'].contains('linux'),
          orElse: () => null);
      return linux?['browser_download_url'];
    }
    return null;
  }

  Future<void> performUpdate(String url) async {
    if (Platform.isAndroid) {
      try {
        OtaUpdate().execute(url, destinationFilename: 'app-update.apk').listen(
          (OtaEvent event) {
            debugPrint('Update progress: ${event.status}');
          },
        );
      } catch (e) {
        debugPrint('Failed to update: $e');
      }
    } else {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    }
  }
}
