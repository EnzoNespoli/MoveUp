import 'dart:io';
import '../lingua.dart';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'open_location_settings_compact.dart';

/// Funzione pubblica da richiamare quando l’utente tocca il banner.
Future<void> openQualityFix(BuildContext context) async {
  if (!Platform.isAndroid) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _QualityIosSheet(),
    );
    return;
  }
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _QualityAndroidSheet(),
  );
}

/* ----------------------------- ANDROID SHEET ---------------------------- */

class _QualityAndroidSheet extends StatefulWidget {
  const _QualityAndroidSheet({super.key});
  @override
  State<_QualityAndroidSheet> createState() => _QualityAndroidSheetState();
}

class _QualityAndroidSheetState extends State<_QualityAndroidSheet> {
  bool? locAlwaysOk; // posizione “Sempre” ok?
  bool? gpsOn; // servizio localizzazione attivo?
  bool? ignoringBattery; // non verificabile senza plugin → lasciamo null
  String? manufacturer; // per tip specifici (MIUI, EMUI, ecc.)

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    // Vendor
    final info = await DeviceInfoPlugin().androidInfo;
    manufacturer = info.manufacturer?.toLowerCase();

    // Permessi localizzazione
    final whenInUse = await Permission.location.status;
    final always = await Permission.locationAlways.status;
    locAlwaysOk = always.isGranted || (whenInUse.isGranted && always.isLimited);

    // GPS ON?
    final service = await Permission.location.serviceStatus;
    gpsOn = service == ServiceStatus.enabled;

    // Batteria: lasciamo null (pallino grigio)
    ignoringBattery = null;

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                height: 4,
                width: 48,
                decoration: BoxDecoration(
                    color: cs.outlineVariant,
                    borderRadius: BorderRadius.circular(99))),
            const SizedBox(height: 12),
            Text(context.t.fix_qualita_dati, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(context.t.fix_message, 
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: cs.onSurfaceVariant)),
            const SizedBox(height: 12),
            _tile(
              ok: locAlwaysOk,
              title: context.t.fix_permessi,
              subtitle: context.t.fix_permessi_sub,
              onTap: () async {
                final st = await Permission.locationAlways.request();
                if (st.isPermanentlyDenied || st.isDenied) {
                  await AppSettings.openAppSettings();
                }
                await _refresh();
              },
            ),
            _tile(
  ok: gpsOn,
  title: context.t.fix_gps_attivo,
  subtitle: context.t.fix_gps_attivo_sub,
  onTap: () async {
    await openLocationSettingsCompat();
    await Future.delayed(const Duration(milliseconds: 400));
    await _refresh();
  },
),
            _batteryTile(),
            if (_needsVendorTip(manufacturer))
              _tile(
                ok: null,
                title: context.t.fix_auto_start,
                subtitle: _vendorHint(manufacturer, context),
                onTap: () async {
                  await _openVendorAutostart(manufacturer);
                },
              ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _refresh,
                icon: const Icon(Icons.refresh),
                label: Text(context.t.fix_auto_ricontrolla),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile({
    required bool? ok,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;
    Color dot;
    if (ok == null)
      dot = cs.outline;
    else if (ok)
      dot = Colors.green;
    else
      dot = Colors.orange;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: Icon(Icons.circle, size: 14, color: dot),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _batteryTile() {
    return _tile(
      ok: ignoringBattery, // resta grigio (null)
      title: context.t.fix_battery,
      subtitle: context.t.fix_battery_sub,
      onTap: () async {
        try {
          final pkg = (await PackageInfo.fromPlatform()).packageName;
          final req = AndroidIntent(
            action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
            data: 'package:$pkg',
          );
          await req.launch();
        } catch (_) {
          try {
            const openList = AndroidIntent(
              action: 'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
            );
            await openList.launch();
          } catch (_) {
            await AppSettings.openAppSettings();
          }
        }
        if (mounted) setState(() {});
      },
    );
  }
}

// Helper vendor
bool _needsVendorTip(String? man) {
  if (man == null) return false;
  final m = man.toLowerCase();

  return m.contains('xiaomi') ||
      m.contains('redmi') ||
      m.contains('poco') ||
      m.contains('huawei') ||
      m.contains('honor') ||
      m.contains('oppo') ||
      m.contains('realme') ||
      m.contains('vivo') ||
      m.contains('oneplus') ||
      m.contains('samsung');
}

String _vendorHint(String? man, BuildContext context) {
  final m = (man ?? '').toLowerCase();
  if (m.contains('xiaomi') || m.contains('redmi') || m.contains('poco')) {
    return context.t.fix_vendor_01;
  }
  if (m.contains('huawei') || m.contains('honor')) {
    return context.t.fix_vendor_02;
  }
  if (m.contains('oppo') || m.contains('realme') || m.contains('vivo')) {
    return context.t.fix_vendor_03;
  }
  if (m.contains('oneplus')) {
    return context.t.fix_vendor_04;
  }
  if (m.contains('samsung')) {
    return context.t.fix_vendor_05;
  }
  return context.t.fix_vendor_06;
}

Future<void> _openVendorAutostart(String? man) async {
  final intents = <AndroidIntent>[
    const AndroidIntent(
      action: 'android.intent.action.MAIN',
      category: 'android.intent.category.DEFAULT',
      package: 'com.miui.securitycenter',
      componentName: 'com.miui.powercenter.PowerSettings',
    ),
    const AndroidIntent(
      action: 'android.intent.action.MAIN',
      category: 'android.intent.category.DEFAULT',
      package: 'com.miui.securitycenter',
    ),
    const AndroidIntent(
      action: 'android.intent.action.MAIN',
      package: 'com.huawei.systemmanager',
    ),
  ];
  for (final it in intents) {
    try {
      await it.launch();
      return;
    } catch (_) {}
  }
  await AppSettings.openAppSettings();
}

/* ------------------------------ IOS SHEET ------------------------------- */

class _QualityIosSheet extends StatelessWidget {
  const _QualityIosSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                height: 4,
                width: 48,
                decoration: BoxDecoration(
                    color: cs.outlineVariant,
                    borderRadius: BorderRadius.circular(99))),
            const SizedBox(height: 12),
            Text(context.t.fix_qualita_dati, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              context.t.fix_messag_01,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.t.fix_chiudi_button)),
          ],
        ),
      ),
    );
  }
}
