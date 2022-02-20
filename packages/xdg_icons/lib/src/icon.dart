import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:gtk_icon_theme/gtk_icon_theme.dart';

import 'theme.dart';

class XdgIcon extends StatefulWidget {
  const XdgIcon({
    Key? key,
    required this.name,
    required this.size,
    this.scale,
  }) : super(key: key);

  final String name;
  final int size;
  final int? scale;

  @override
  State<XdgIcon> createState() => _XdgIconState();
}

class _XdgIconState extends State<XdgIcon> {
  GtkIconInfo? _icon;
  GtkIconTheme? _theme;

  void _lookupIcon() {
    final XdgIconThemeData data = XdgIconTheme.of(context);

    _theme ??= data.theme?.isNotEmpty == true
        ? GtkIconTheme.custom(data.theme!)
        : GtkIconTheme();

    _icon = _theme!.lookupIcon(
      widget.name,
      size: widget.size,
      scale: widget.scale ?? data.scale,
    );
  }

  @override
  void dispose() {
    _icon?.dispose();
    _theme?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _lookupIcon();
  }

  @override
  void didUpdateWidget(covariant XdgIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.name != oldWidget.name ||
        widget.size != oldWidget.size ||
        widget.scale != oldWidget.scale) {
      _lookupIcon();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_icon == null) {
      return SizedBox.square(dimension: widget.size.toDouble());
    }
    return Image.file(
      File(_icon!.fileName),
      height: widget.size.toDouble(),
      width: widget.size.toDouble(),
    );
  }
}
