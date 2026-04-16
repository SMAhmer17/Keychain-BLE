import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SoriShell extends StatelessWidget {
  const SoriShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: navigationShell,
      bottomNavigationBar: _SoriNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

class _SoriNavBar extends StatelessWidget {
  const _SoriNavBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _NavItem(iconPath: 'assets/icons/light/home_tab.svg'),
    _NavItem(iconPath: 'assets/icons/light/bracelt_tab.svg'),
    _NavItem(iconPath: 'assets/icons/light/upload_tab.svg'),
    _NavItem(iconPath: 'assets/icons/light/settings_tab.svg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0x40000000),
            // color: Colors.black38,
            blurRadius: 4.8,
            spreadRadius: -1,
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(24),
          topRight: const Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          _items.length,
          (i) => _NavItemWidget(
            item: _items[i],
            isSelected: currentIndex == i,
            onTap: () => onTap(i),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String iconPath;

  const _NavItem({required this.iconPath});
}

class _NavItemWidget extends StatelessWidget {
  const _NavItemWidget({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _NeumorphicIconBox(isSelected: isSelected, iconPath: item.iconPath),
        ],
      ),
    );
  }
}

class _NeumorphicIconBox extends StatelessWidget {
  const _NeumorphicIconBox({required this.isSelected, required this.iconPath});

  final bool isSelected;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.5),
      ),
      child: Stack(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              // color: Colors.transparent,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x40000000),
                  blurRadius: 4.8,
                  spreadRadius: -1,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SvgPicture.asset(
                iconPath,
                width: 32,
                height: 32,
                colorFilter: ColorFilter.mode(Colors.black54, BlendMode.srcIn),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
