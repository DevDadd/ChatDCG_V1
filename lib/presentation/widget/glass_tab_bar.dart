import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GlassTabBar extends StatefulWidget {
  const GlassTabBar({super.key, required this.currentIndex, required this.onChanged});

  final int currentIndex;
  final ValueChanged<int> onChanged;

  @override
  State<GlassTabBar> createState() => _GlassTabBarState();
}

class _GlassTabBarState extends State<GlassTabBar> {
  MethodChannel? _channel;

  static const _items = [
    {'title': 'Contacts', 'icon': 'person.crop.circle'},
    {'title': 'Calls', 'icon': 'phone'},
    {'title': 'Chats', 'icon': 'bubble.left.and.bubble.right'},
    {'title': 'Settings', 'icon': 'gearshape'},
  ];

  @override
  void didUpdateWidget(covariant GlassTabBar old) {
    super.didUpdateWidget(old);
    if (old.currentIndex != widget.currentIndex) {
      _channel?.invokeMethod('setIndex', widget.currentIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return NavigationBar(
        selectedIndex: widget.currentIndex,
        onDestinationSelected: widget.onChanged,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.account_circle), label: 'Contacts'),
          NavigationDestination(icon: Icon(Icons.phone), label: 'Calls'),
          NavigationDestination(icon: Icon(Icons.forum), label: 'Chats'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      );
    }

    return SizedBox(
      height: 90 + MediaQuery.of(context).padding.bottom,
      child: UiKitView(
        viewType: 'glass_tab_bar',
        // Hand every touch to the native bar right away so dragging the
        // bubble isn't delayed or stolen by Flutter's gesture arena
        gestureRecognizers: {
          Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
        },
        // Start on the right tab: setIndex is only sent on later changes
        creationParams: {'items': _items, 'index': widget.currentIndex},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (id) {
          _channel = MethodChannel('glass_tab_bar_$id')
            ..setMethodCallHandler((call) async {
              if (call.method == 'onSelect') widget.onChanged(call.arguments as int);
            });
        },
      ),
    );
  }
}