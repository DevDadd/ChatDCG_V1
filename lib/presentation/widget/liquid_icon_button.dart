import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Round Liquid Glass button with an icon, rendered natively by SwiftUI on iOS
/// (GlassIconButton.swift), with a Material fallback elsewhere.
///
/// [sfSymbol] is the SF Symbol shown on iOS (e.g. 'square.and.pencil');
/// [icon] is the Material icon shown on other platforms.
class LiquidIconButton extends StatefulWidget {
  const LiquidIconButton({
    super.key,
    required this.sfSymbol,
    required this.icon,
    required this.onPressed,
    this.color,
    this.tint,
    this.size = 44,
    this.iconSize = 18,
  });

  final String sfSymbol;
  final IconData icon;
  final VoidCallback onPressed;

  // Icon color; defaults to the system primary color
  final Color? color;

  // Color laid over the glass
  final Color? tint;

  // Width and height of the round button
  final double size;
  final double iconSize;

  @override
  State<LiquidIconButton> createState() => _LiquidIconButtonState();
}

class _LiquidIconButtonState extends State<LiquidIconButton> {
  MethodChannel? _channel;

  void _onCreate(int id) {
    _channel = MethodChannel('glassiconbutton_$id')
      ..setMethodCallHandler((call) async {
        if (call.method == 'onPressed') widget.onPressed();
      });
  }

  @override
  void didUpdateWidget(covariant LiquidIconButton old) {
    super.didUpdateWidget(old);
    if (old.sfSymbol != widget.sfSymbol) {
      _channel?.invokeMethod('setSymbol', widget.sfSymbol);
    }
  }

  @override
  void dispose() {
    _channel?.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return SizedBox.square(
        dimension: widget.size,
        child: IconButton.filled(
          onPressed: widget.onPressed,
          iconSize: widget.iconSize,
          color: widget.color,
          style: IconButton.styleFrom(backgroundColor: widget.tint),
          icon: Icon(widget.icon),
        ),
      );
    }

    // widthFactor/heightFactor 1: keep the circle at its own size inside
    // tight constraints, e.g. AppBar actions are stretched to toolbar height
    return Center(
      widthFactor: 1,
      heightFactor: 1,
      child: SizedBox.square(
        dimension: widget.size,
        child: UiKitView(
          viewType: 'glass_icon_button',
          creationParams: {
            'symbol': widget.sfSymbol,
            'iconSize': widget.iconSize,
            if (widget.color != null) 'color': widget.color!.toARGB32(),
            if (widget.tint != null) 'tint': widget.tint!.toARGB32(),
          },
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: _onCreate,
        ),
      ),
    );
  }
}
