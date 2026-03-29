import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keychain_ble/features/ble/provider/ble_config_notifier.dart';

/// Dialog that lets the user read and edit the BLE Service UUID and
/// Characteristic UUID. Changes are persisted to SharedPreferences immediately.
class UuidConfigDialog extends ConsumerStatefulWidget {
  const UuidConfigDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const UuidConfigDialog(),
    );
  }

  @override
  ConsumerState<UuidConfigDialog> createState() => _UuidConfigDialogState();
}

class _UuidConfigDialogState extends ConsumerState<UuidConfigDialog> {
  late final TextEditingController _serviceCtrl;
  late final TextEditingController _charCtrl;

  @override
  void initState() {
    super.initState();
    final config = ref.read(bleConfigNotifierProvider);
    _serviceCtrl = TextEditingController(text: config.serviceUuid);
    _charCtrl = TextEditingController(text: config.characteristicUuid);
  }

  @override
  void dispose() {
    _serviceCtrl.dispose();
    _charCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final notifier = ref.read(bleConfigNotifierProvider.notifier);
    await notifier.updateServiceUuid(_serviceCtrl.text);
    await notifier.updateCharacteristicUuid(_charCtrl.text);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _reset() async {
    await ref.read(bleConfigNotifierProvider.notifier).resetToDefaults();
    if (!mounted) return;
    final config = ref.read(bleConfigNotifierProvider);
    _serviceCtrl.text = config.serviceUuid;
    _charCtrl.text = config.characteristicUuid;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('BLE UUID Configuration'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'These values must match your ESP32 firmware.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            _UuidField(
              label: 'Service UUID',
              hint: 'e.g. 0000FFE0-0000-1000-8000-00805F9B34FB',
              controller: _serviceCtrl,
            ),
            const SizedBox(height: 16),
            _UuidField(
              label: 'Characteristic UUID',
              hint: 'e.g. 0000FFE1-0000-1000-8000-00805F9B34FB',
              controller: _charCtrl,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _reset,
          child: const Text('Reset to Defaults'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _UuidField extends StatelessWidget {
  const _UuidField({
    required this.label,
    required this.hint,
    required this.controller,
  });

  final String label;
  final String hint;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          autocorrect: false,
          enableSuggestions: false,
          textCapitalization: TextCapitalization.characters,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade400,
              fontFamily: 'monospace',
            ),
            border: const OutlineInputBorder(),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear, size: 18),
              onPressed: () => controller.clear(),
              tooltip: 'Clear',
            ),
          ),
        ),
      ],
    );
  }
}
