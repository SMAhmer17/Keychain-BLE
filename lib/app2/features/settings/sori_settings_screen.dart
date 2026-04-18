import 'package:flutter/material.dart';
import 'package:keychain_ble/app2/core/widgets/sori_dots_background.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────

class _SettingsItem {
  final IconData icon;
  final String title;
  final String subtitle;
  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

class SoriSettingsScreen extends StatelessWidget {
  const SoriSettingsScreen({super.key});

  static const _items = [
    _SettingsItem(
      icon: Icons.map_outlined,
      title: 'Tutorial',
      subtitle: 'Need a refresher?',
    ),
    _SettingsItem(
      icon: Icons.star_outline_rounded,
      title: 'Quests',
      subtitle: 'Unlock special items!',
    ),
    _SettingsItem(
      icon: Icons.favorite_outline_rounded,
      title: 'Friends',
      subtitle: 'See new and old pals',
    ),
    _SettingsItem(
      icon: Icons.help_outline_rounded,
      title: 'Help',
      subtitle: 'Have a question?',
    ),
    _SettingsItem(
      icon: Icons.settings_outlined,
      title: 'Settings',
      subtitle: 'Customize app experience',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SoriDotsBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              // Menu card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _SettingsCard(items: _items),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Settings card container
// ─────────────────────────────────────────────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.items});

  final List<_SettingsItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 24,
            offset: Offset(0, 6),
          ),
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _SettingsMenuItem(item: items[i]),
            if (i < items.length - 1)
              const Divider(
                color: Color(0xFFF0EDF6),
                thickness: 1,
                height: 1,
                indent: 76,
              ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Settings menu item
// ─────────────────────────────────────────────────────────────────────────────

class _SettingsMenuItem extends StatelessWidget {
  const _SettingsMenuItem({required this.item});

  final _SettingsItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        child: Row(
          children: [
            _MenuIconBox(icon: item.icon),
            const SizedBox(width: 16),
            Expanded(child: _MenuItemText(item: item)),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFD4C5EC),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Icon box (neumorphic — SVG will replace icon later)
// ─────────────────────────────────────────────────────────────────────────────

class _MenuIconBox extends StatelessWidget {
  const _MenuIconBox({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x28000000),
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
          BoxShadow(color: Colors.white, blurRadius: 4, offset: Offset(-2, -2)),
        ],
      ),
      child: Icon(icon, size: 26, color: const Color(0xFFBBB5CC)),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Menu item text (title + subtitle)
// ─────────────────────────────────────────────────────────────────────────────

class _MenuItemText extends StatelessWidget {
  const _MenuItemText({required this.item});

  final _SettingsItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.title,
          style: const TextStyle(
            fontFamily: 'Punto',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF5C5470),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          item.subtitle,
          style: const TextStyle(
            fontFamily: 'Punto',
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Color(0xFFAA9BB5),
          ),
        ),
      ],
    );
  }
}
