import 'dart:io';

import 'package:chatdcg_demo/presentation/pages/contacts_page.dart';
import 'package:chatdcg_demo/presentation/pages/home_page.dart';
import 'package:chatdcg_demo/presentation/widget/bottom_menu_widget.dart';
import 'package:chatdcg_demo/presentation/widget/glass_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Holds the tabs and the bottom menu, so the menu stays visible on every tab.
/// Pages pushed from a tab (e.g. ChatPage) cover the menu, like iOS.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  BottomMenuTab _tab = BottomMenuTab.chats;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      // iOS: lets the tab content scroll behind the bar so the glass has
      // something to blur. The Android bar is opaque, so content stops above it
      extendBody: Platform.isIOS,
      // IndexedStack keeps every tab alive: switching back keeps its scroll
      // position and does not reload it
      body: IndexedStack(
        index: _tab.index,
        children: const [
          ContactsPage(),
          _ComingSoonPage(title: 'Calls'),
          HomePage(),
          _ComingSoonPage(title: 'Settings'),
        ],
      ),
      bottomNavigationBar: Platform.isIOS
          ? GlassTabBar(
              currentIndex: _tab.index,
              onChanged: (i) => setState(() => _tab = BottomMenuTab.values[i]),
            )
          : BottomMenuWidget(
              current: _tab,
              onTap: (tab) => setState(() => _tab = tab),
            ),
    );
  }
}

class _ComingSoonPage extends StatelessWidget {
  const _ComingSoonPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0x1C1C1E),
        centerTitle: true,
        title: Text(
          title,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Center(
        child: Text(
          'Coming soon',
          style: GoogleFonts.inter(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }
}
