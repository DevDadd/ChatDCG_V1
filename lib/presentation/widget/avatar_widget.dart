import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Round user avatar loaded from [url]. Shows a plain blue circle while
/// loading, when there is no url, or when loading fails.
///
/// The server sends DiceBear urls (…/svg?seed=…), which are SVG, so those go
/// through flutter_svg; anything else is treated as a bitmap.
class AvatarWidget extends StatelessWidget {
  const AvatarWidget({super.key, required this.url, required this.size});

  final String? url;
  final double size;

  bool get _isSvg {
    final path = Uri.tryParse(url!)?.path ?? '';
    return path.endsWith('.svg') || path.endsWith('/svg');
  }

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: size,
      height: size,
      color: Colors.lightBlue,
    );

    return ClipOval(
      child: SizedBox.square(
        dimension: size,
        child: url == null
            ? placeholder
            : _isSvg
            ? SvgPicture.network(
                url!,
                fit: BoxFit.cover,
                placeholderBuilder: (_) => placeholder,
                errorBuilder: (_, _, _) => placeholder,
              )
            : Image.network(
                url!,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) =>
                    progress == null ? child : placeholder,
                errorBuilder: (_, _, _) => placeholder,
              ),
      ),
    );
  }
}
