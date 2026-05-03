import 'package:flutter/material.dart';
import 'package:frontend/features/wardrobe/presentation/pages/wardrobe_page.dart';
import '../../../mix_match/presentation/pages/mix_match_page.dart';

import '../widgets/app_bottom_navbar.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../shop/presentation/pages/shop_page.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key, this.tabBodies});

  /// When non-null (e.g. tests), replaces the five default tab roots. Must have length 5.
  final List<Widget>? tabBodies;

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = widget.tabBodies ??
      const [
        HomePage(),
        WardrobePage(),
        MixMatchPage(),
        ShopPage(),
        ProfilePage(),
      ];

  void _onNavTap(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: AppBottomNav(
        selectedIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
