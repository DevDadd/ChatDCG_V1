import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Liquid Glass button rendered natively by SwiftUI on iOS (glassbutton.swift),
/// with a Material fallback elsewhere.
///
/// A platform view cannot size itself to its content, so the width is worked
/// out here from the label, matching the SwiftUI text and padding.
class LiquidButton extends StatefulWidget {
  const LiquidButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.tint,
    this.height = 48,
  });

  final String label;
  final VoidCallback onPressed;
  final Color? tint;
  final double height;

  @override
  State<LiquidButton> createState() => _LiquidButtonState();
}

class _LiquidButtonState extends State<LiquidButton> {
  MethodChannel? _channel;

  // Same as the Text in glassbutton.swift: system 16 semibold, not scaled
  // by the accessibility text size, 16 padding each side
  static const _labelStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static const _horizontalPadding = 16.0;

  double get _width {
    final painter = TextPainter(
      text: TextSpan(text: widget.label, style: _labelStyle),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    final width = painter.width;
    painter.dispose();
    // +2: rounding differences between Flutter's and SwiftUI's text layout
    return width.ceilToDouble() + _horizontalPadding * 2 + 2;
  }

  void _onCreate(int id) {
    _channel = MethodChannel('glassbutton_$id')
      ..setMethodCallHandler((call) async {
        if (call.method == 'onPressed') widget.onPressed();
      });
  }

  @override
  void didUpdateWidget(covariant LiquidButton old) {
    super.didUpdateWidget(old);
    if (old.label != widget.label) {
      _channel?.invokeMethod('setLabel', widget.label);
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
      return SizedBox(
        height: widget.height,
        child: FilledButton(
          onPressed: widget.onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: widget.tint,
            shape: const StadiumBorder(),
          ),
          child: Text(widget.label),
        ),
      );
    }

    // widthFactor/heightFactor 1: shrink to the button inside loose
    // constraints, and centre it inside tight ones (e.g. AppBar.leading)
    return Center(
      widthFactor: 1,
      heightFactor: 1,
      child: SizedBox(
        width: _width,
        height: widget.height,
        child: UiKitView(
          viewType: 'glass_button',
          creationParams: {
            'label': widget.label,
            if (widget.tint != null) 'tint': widget.tint!.toARGB32(),
          },
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: _onCreate,
        ),
      ),
    );
  }
}
